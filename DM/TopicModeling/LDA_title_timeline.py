# -*- coding: utf-8 -*-

import pandas as pd
from pandas import json_normalize
from konlpy.tag import Mecab
from tqdm import tqdm
import gensim
import gensim.corpora as corpora
from gensim.models.coherencemodel import CoherenceModel
from pprint import pprint
import re
from LDA_score import get_score
import os
import requests
import json
from pymongo import MongoClient
from datetime import datetime, timedelta
from api import *

mecab = Mecab("C:\\mecab\\mecab-ko-dic") # mecab dictionary 경로. colab에서 할 때는 안 넣어줘도 됐었음
mallet_path = "C:\\Mallet\\bin\\mallet"  # 이거 mallet2108어쩌구인가로도 바꿔보기


# 1. Preprocessing Data
def get_key_tokens(text):
    key_pos = ['SL', 'NNG', 'NNP', 'VV', 'VA', 'XR', 'SH'] # ['NNG', 'NNP', 'SL', 'SH']
    text = re.sub(r'\[[^)]*\]', '', text) # 한겨레 [포토], [인터뷰], [11회 비정규 노동 수기 공모전], [단독] 이런거 없애기
    tokens = mecab.pos(text)
    token_list = []
    for token, pos in filter(lambda x: (x[1] in key_pos), tokens):
        if pos == 'VV' or pos == 'VA' or pos == 'XR':
            if len(token) <= 1:
                continue
        token_list.append(token)

    return token_list


def preprocess(file, nobelow):
    news_df = pd.read_csv(file)

    news_df_len = len(news_df.index)

    # get only the time, title data
    news_df = news_df[['date', 'title']]
    
    # chage data type
    news_df['date'] = pd.to_datetime(news_df['date'])
    #news_df['content'] = news_df['content'].astype(str)
    #news_df['_id'] = news_df['_id'].astype(str)

    #2. Delete Stopwords
    # 2.1 tokenize & get the pos
    # 뉴스 데이터의 특징: 띄어쓰기, 오탈자 문제 적음.
    title_list = []
    for i in tqdm(range(len(news_df['title']))):
        title_list.append(get_key_tokens(news_df.loc[i,'title']))

    # 3. Make Corpus
    id2word = corpora.Dictionary(title_list)
    id2word.filter_extremes(no_below=nobelow) 
    corpus = [id2word.doc2bow(content) for content in title_list]

    return news_df, id2word, corpus, title_list

# 2.2 delete stopwords => TODO

# 2.3 make user dictionary => TODO



# 4. Topic Modeling
def topic_modeling(id2word, corpus, title_list, num_topics):

    # 얘 passes라는 인자로 epoch 조절 가능
    # ver 1.
    # lda_model = gensim.models.LdaModel(corpus=corpus, num_topics=60, id2word=id2word) # 아래랑 성능 비교하기(너무 오래걸려;)
    # print(lda_model.print_topics(60, 3))
    # coherence_model = CoherenceModel(model=lda_model, texts=title_list, dictionary=id2word, topn=10)
    # coherence = coherence_model.get_coherence() # 얘가 문제
    # print(coherence)

    # ver 2.
    # # 그 막 출력되는게 위에 코드 결과야 1000번 도는거 아마 1000번이 default인가봐
    ldamallet = gensim.models.wrappers.LdaMallet(mallet_path, corpus=corpus, num_topics=num_topics, id2word=id2word, iterations=1000) # gensim 3.8 버전에만 존재
    pprint(ldamallet.show_topics(num_topics=num_topics, num_words=3))
    # # 4.1 get coherence
    #coherence_model_ldamallet = CoherenceModel(model=ldamallet, texts=title_list, dictionary=id2word, coherence='c_v')
    #coherence_ldamallet = coherence_model_ldamallet.get_coherence()

    return ldamallet

def timelining(per_contrib, num_news_threshold, news_df, timeline_df):
    # print(news_df["Topic_Perc_Contrib"])
    topic_news = news_df[news_df["Topic_Perc_Contrib"] >= per_contrib]
    # topic_news = topic_news.sort_values(by='Date', ascending=False)

    #print(topic_news)
    if len(topic_news) != 0:
        histogram = {}  
        # prev_date = datetime(2999, 12, 30)
        for date in topic_news["Date"].tolist(): 
            histogram[date] = histogram.get(date, 0) + 1 # histogram은 날짜에 해당 토픽이 몇번 나왔는지 들어있음
        date_frequency = list(histogram.items())
        
        for i in range(3):
            if i >= len(date_frequency):
                break
            date = date_frequency[i][0] 
            frequency = date_frequency[i][1] 
            
            # print(key, value)
            #key = key.split(' ')[0]

            if frequency >= num_news_threshold:
                title_list = list(topic_news['Title'])
                # id_list = list(topic_news['ID'])
                # print('ID',id_list)
                # print('Keywords', topic_news["Keywords"].iloc[0])
                # print('Date', key)
                # print('Title',title_list)
                timeline_df = timeline_df.append({'Keywords': topic_news["Keywords"].iloc[0], 'Date': date, 'Title':title_list}, ignore_index=True)

    return timeline_df
# npx nodemon server.js

def split_date(x):
    return x.split(' ')[0]

# 4.3 formmating output with DF
def topics_to_timeline(news_df, ldamodel, corpus, num_keywords, num_topics, perc_threshold):
    # Init output
    topics_info_df = pd.DataFrame()

    # Get main topic in each document
    #ldamodel[corpus]: lda_model에 corpus를 넣어 각 토픽 당 확률을 알 수 있음
    for i, row in enumerate(ldamodel[corpus]):

        # print(i, row) i는 전체 뉴스 기사 idx, row는 [(토픽 idx, 그 토픽일 확률), ... 토픽 개수만큰]
        row = sorted(row, key=lambda x: (x[1]), reverse=True) # 토픽일 확률 기준으로 sort
        # Get the Dominant topic, Perc Contribution and Keywords for each document
        for j, (topic_num, prop_topic) in enumerate(row):
            if j == 0:  # => dominant topic
                wp = ldamodel.show_topic(topic_num, topn=num_keywords) #여기변경~~~~~~~~~~
                topic_keywords = ", ".join([word for word, prop in wp])
                #topics_info_df = pd.concat([topics_info_df, pd.Series([int(topic_num), round(prop_topic,4), topic_keywords])], axis=1)
                topics_info_df = topics_info_df.append(pd.Series([int(topic_num), round(prop_topic,4), topic_keywords]), ignore_index=True)
            else:
                break

    topics_info_df.columns = ['Dominant_Topic', 'Perc_Contribution', 'Topic_Keywords']

    topics_info_df = pd.concat([topics_info_df, news_df['title'], news_df['date']], axis=1)
    topics_info_df = topics_info_df.reset_index()
    topics_info_df.columns = ['Document_No', 'Dominant_Topic', 'Topic_Perc_Contrib', 'Keywords', 'Title', 'Date']

    topics_info_df['Dominant_Topic'] = topics_info_df['Dominant_Topic'] +1
    topics_info_df.Dominant_Topic = topics_info_df.Dominant_Topic.astype(str)
    #topics_info_df.Dominant_Topic = topics_info_df.Date.astype(str)
    topics_info_df['Dominant_Topic'] = topics_info_df['Dominant_Topic'].str.split('.').str[0]

    timeline_df = pd.DataFrame(columns = ['Keywords', 'Date', 'Title'])
    for i in range(1,num_topics+1):
        globals()['df_{}'.format(i)]=topics_info_df.loc[topics_info_df.Dominant_Topic==str(i)]

        globals()['df_{}'.format(i)].sort_values('Topic_Perc_Contrib',ascending=False,inplace = True)
        timeline_df = timelining(perc_threshold, 2, globals()['df_{}'.format(i)], timeline_df)

    timeline_df = timeline_df.sort_values(by='Date', ascending=False)
    timeline_df.Date = timeline_df.Date.astype(str)
    timeline_df.Date = timeline_df.Date.apply(split_date)


    return timeline_df
        



if __name__ == '__main__':
    file = 'DM\\TopicModeling\\han_corona_2.csv'
    
    # query = searchwords_df['words'][0]
    query = '코로나_제목'

    client = MongoClient("mongodb+srv://BaekYeonsun:hello12345@cluster.3dypr.mongodb.net/database?retryWrites=true&w=majority")
    db = client.database
    topic_collection = db.topics
    post = {
            'query': query,
            'topicNum': [{'num': 0},
                         {'num': 1},
                         {'num': 2}]
            }

    news_df, id2word, corpus, title_list = preprocess(file, 5) # 인자값 = no_below 값

    # find optimal topic nums
    #ldamallet, coherence_mallet = topic_modeling(id2word, corpus, title_list)
    start = 30 # 이 범위는 뉴스 개수에 따라 다르게 하기
    limit = 101
    step = 10
    topic_priority = get_score(corpus, id2word, title_list, start, limit, step)
    ''' topic_perc 방정식으로 구해봄
    30 -> 0.2 50 -> 0.15 70 ->0.1
    y = ax + b
    0.2 = 30a + b
    0.15 = 50a + b
    20a = -0.05
    a = -1/400
    0.15 = -1/8 + b
    b = 0.275
    y = -1/400x + 0.275
    '''
    # 0.750 -> 0.7 content의 coherence가 0.05만큼 작아 b값을 0.05만큼 빼줌
    # 0.46이니까 0.24 빼줌
    for i in range(len(topic_priority)):
        ldamallet = topic_modeling(id2word, corpus, title_list, topic_priority[i]) #이렇게하려면 sort해서 주면 안 됨
        timeline = topics_to_timeline(news_df, ldamallet, corpus, 3, topic_priority[i], -0.0025 * topic_priority[i] + 0.15) # 마지막 인자 키워드 개수

        topics = []
        for j in range(len(timeline.index)):
            t = timeline.iloc[j]
            a = {'date': str(t.Date),
                 'news': [{'news_id': x} for x in t.Title],
                 'topic': t.Keywords}
            topics.append(a)
        post['topicNum'][i]['topics'] = topics
    result = topic_collection.insert_one(post)
