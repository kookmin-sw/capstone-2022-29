# -*- coding: utf-8 -*-

import pandas as pd
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
from pandas import json_normalize
from api import *
from datetime import datetime

mallet_path = "/home/ubuntu/capstone-2022-29/tmp/mallet-2.0.8/bin/mallet"
mecab = Mecab()

def get_key_tokens(text):
    f = open("stopwords.txt", 'r')
    lines = f.readlines()
    f.close()

    stopwords = []
    for line in lines:
        stopwords.append(line.strip())
    
    key_pos = ['SL', 'NNG', 'NNP', 'VV', 'VA', 'XR', 'SH'] # ['NNG', 'NNP', 'SL', 'SH']
    
    text = re.sub(r'\[[^)]*\]', '', text) # 한겨레 [포토], [인터뷰], [11회 비정규 노동 수기 공모전], [단독] 이런거 없애기
    
    text = text.lower()
    
    tokens = mecab.pos(text)
    token_list = []
    """
    for token, pos in tokens:
        if token in stopwords:
            continue
        token_list.append(token)
    """    
    for token, pos in filter(lambda x: (x[1] in key_pos), tokens):
        if pos == 'VV' or pos == 'VA' or pos == 'XR':
            if len(token) <= 1:
                continue
        if token in stopwords:
            continue
        token_list.append(token)
    
    return token_list

def preprocess(news_data, nobelow):
    news_df = json_normalize(json.loads(news_data.text))
    #print(list(news_data))
    #print(pd.DataFrame(list(news_data)))
    print(55)
    #col_name = ["_id", "content", "date", "journal", "summary", "title", "url"]
    #print(news_data)
    #news_dict = list(news_data)
    print(66)
    #news_df = pd.DataFrame(news_data, columns=col_name)
    #print(news_df.head())
    print(10)
    news_df_len = len(news_df.index)
    print(11)
    # get only the time, title data
    news_df = news_df[['_id', 'date', 'title']]
    print(12)
    # chage data type
    news_df['date'] = pd.to_datetime(news_df['date'])
    news_df['title'] = news_df['title'].astype(str)
    news_df['_id'] = news_df['_id'].astype(str)

    # tokenize & get the pos
    title_list = []
    for i in tqdm(range(len(news_df['title']))):
        title_list.append(get_key_tokens(news_df.loc[i,'title']))

    # make Corpus
    id2word = corpora.Dictionary(title_list)
    id2word.filter_extremes(no_below=nobelow) 
    corpus = [id2word.doc2bow(content) for content in title_list]

    return news_df, id2word, corpus, title_list, news_df_len

# 2.2 delete stopwords => TODO => 완료

# 2.3 make user dictionary => TODO => 완료



# 4. Topic Modeling
def topic_modeling(id2word, corpus, title_list, num_topics, iteration):

    # 얘 passes라는 인자로 epoch 조절 가능
    # ver 1.
    # lda_model = gensim.models.LdaModel(corpus=corpus, num_topics=60, id2word=id2word) # 아래랑 성능 비교하기(너무 오래걸려;)
    # print(lda_model.print_topics(60, 3))
    # coherence_model = CoherenceModel(model=lda_model, texts=title_list, dictionary=id2word, topn=10)
    # coherence = coherence_model.get_coherence() # 얘가 문제
    # print(coherence)

    # ver 2.
    # # 그 막 출력되는게 위에 코드 결과야 1000번 도는거 아마 1000번이 default인가봐
    ldamallet = gensim.models.wrappers.LdaMallet(mallet_path, corpus=corpus, num_topics=num_topics, id2word=id2word, iterations=iteration) # gensim 3.8 버전에만 존재
    pprint(ldamallet.show_topics(num_topics=num_topics, num_words=3))
    # # 4.1 get coherence
    #coherence_model_ldamallet = CoherenceModel(model=ldamallet, texts=title_list, dictionary=id2word, coherence='c_v')
    #coherence_ldamallet = coherence_model_ldamallet.get_coherence()

    return ldamallet

def timelining(per_contrib, num_news_threshold, news_df, timeline_df, iters):
    # print(news_df["Topic_Perc_Contrib"])

    topic_news = news_df[news_df["Topic_Perc_Contrib"] >= per_contrib]
    topic_news = topic_news.sort_values(by='Date', ascending=False)

    #print(topic_news)
    if len(topic_news) != 0:
        histogram = {}  
        prev_date = datetime(2023, 12, 30)
        for date in topic_news["Date"].tolist(): 
            histogram[date] = histogram.get(date, 0) + 1 # histogram은 날짜에 해당 토픽이 몇번 나왔는지 들어있음
        date_frequency = list(histogram.items())
        
        for i in range(iters):
            if i >= len(date_frequency): 
                break
            date = date_frequency[i][0] 
            frequency = date_frequency[i][1] 
            
            # print(key, value)
            #key = key.split(' ')[0]
            print(prev_date, date)
            
            date_diff = prev_date - date
            print(date_diff.days)
            if date_diff.days > 30:
                if frequency >= num_news_threshold:
                    title_list = list(topic_news['Title'])
                    id_list = list(topic_news['ID'])
                    # id_list = list(topic_news['ID'])
                    # print('ID',id_list)
                    # print('Keywords', topic_news["Keywords"].iloc[0])
                    # print('Date', key)
                    # print('Title',title_list)
                    timeline_df = timeline_df.append({'ID': id_list, 'Keywords': topic_news["Keywords"].iloc[0], 'Date': date, 'Title':title_list}, ignore_index=True)
                    prev_date = date
    print(timeline_df)
    return timeline_df

def split_date(x):
    return x.split(' ')[0]

# 4.3 formmating output with DF
def topics_to_timeline(news_df, ldamodel, corpus, num_keywords, num_topics, perc_threshold, num_news, iters):
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

    topics_info_df = pd.concat([topics_info_df, news_df['_id'], news_df['title'],news_df['date']], axis=1)

    topics_info_df = topics_info_df.reset_index()
    topics_info_df.columns = ['Document_No', 'Dominant_Topic', 'Topic_Perc_Contrib', 'Keywords', 'ID', 'Title', 'Date']

    topics_info_df['Dominant_Topic'] =topics_info_df['Dominant_Topic'] +1
    topics_info_df.Dominant_Topic = topics_info_df.Dominant_Topic.astype(str)
    topics_info_df['Dominant_Topic'] = topics_info_df['Dominant_Topic'].str.split('.').str[0]
    topic_per_mean_list = []
    topic_per_thres_list = []
    for i in range(1, num_topics+1):
        df = topics_info_df.loc[topics_info_df.Dominant_Topic==str(i)]
        print(df)
        print('len: ', len(df.index))
        # df.set_index('ID')
        print('num_topics:', i, df['Topic_Perc_Contrib'].mean())
        #idx = round(len(df.index) * 0.8)
        #idx = int(df['Document_No'].iloc[round(len(df.index) * 0.8)])
        #print('idx', idx)
        #idx = df.index[(df['Document_No'] == idx)]
        #thres_row = df.loc[df['Document_No'] == idx]
        #print('idx',idx)
        #print(thres_row['Topic_Perc_Contrib'].item())
        #if thres_row['Topic_Perc_Contrib'].item():
        if len(df.index) > 2:
           topic_per_thres_list.append(df['Topic_Perc_Contrib'].iloc[round(len(df.index)*0.8)])
        #topic_per_thres_list.append(thres_row['Topic_Perc_Contrib'].item())
        #topic_per_mean_list.append(df['Topic_Perc_Contrib'].mean())
        # topic_per_list.append(df.loc[:10, 'Topic_Perc_Contrib'].mean())
        # print(topic_per_list)
    per_mean = sum(topic_per_thres_list) / len(topic_per_thres_list)
    print("total mean:", per_mean)
            


    timeline_df = pd.DataFrame(columns = ['ID', 'Keywords', 'Date', 'Title'])
    for i in range(1,num_topics+1):
        globals()['df_{}'.format(i)]=topics_info_df.loc[topics_info_df.Dominant_Topic==str(i)]
        globals()['df_{}'.format(i)] = globals()['df_{}'.format(i)].sort_values('Topic_Perc_Contrib',ascending=False)
        #timeline_df = timelining(per_mean-0.0004*num_topics, 2, globals()['df_{}'.format(i)], timeline_df)
        #timeline_df = timelining(per_mean-0.0002*(100-num_topics), 2, globals()['df_{}'.format(i)], timeline_df)
        timeline_df = timelining(0.003, num_news, globals()['df_{}'.format(i)], timeline_df, iters)


    print("Final df")
    print(timeline_df)
    timeline_df = timeline_df.sort_values(by='Date', ascending=False)
    timeline_df.Date = timeline_df.Date.astype(str)
    timeline_df.Date = timeline_df.Date.apply(split_date)

    return timeline_df



if __name__ == '__main__':
    queries = ['비트코인', '자율주행', '유튜브', '축제', '인스타', '배달', '마블', '브라질', '아이유', '태풍', '국민대', '우크라이나', '올림픽', '월드컵', '삼성', '갤럭시', '애플', '선거', '대통령', '카카오', '네이버', '구글', '메타버스', 'NFT', '넷플릭스', '주식', '대한민국', '손흥민', '축구', '야구', '인공지능', '코로나19', '오미크론', '확진자', '부동산', '반도체', '민주당', '이재명', '지방선거', '마스크']
    for query in quries:

        client = MongoClient("mongodb+srv://BaekYeonsun:hello12345@cluster.3dypr.mongodb.net/database?retryWrites=true&w=majority")
        db = client.database
        #collection = db.news
        #news_data = list(collection.find({'$or': [{'content': {'$regex': query, '$options': 'i'}}, {'title': {'$regex':query, '$options': 'i'}} ]}))
        #client = MongoClient("mongodb+srv://BaekYeonsun:hello12345@cluster.3dypr.mongodb.net/database?retryWrites=true&w=majority")
        print(1)
        news_data = requests.get(req + query)
        topic_collection = db.topics
        post = {
                'query': query,
                'topicNum': [{'num': 0},
                             {'num': 1},
                             {'num': 2}]
                }
        print(2)
        news_df, id2word, corpus, title_list, num_doc = preprocess(news_data, 3) # 인자값 = no_below 값
        print(5)
        iteration = 3000

        # find optimal topic nums
        #ldamallet, coherence_mallet = topic_modeling(id2word, corpus, title_list)
        start = 25 # 이 범위는 뉴스 개수에 따라 다르게 하기
        limit = 116
        step = 10
        topic_priority = get_score(corpus, id2word, title_list, start, limit, step, query, iteration, num_doc)
        if num_doc < 200:
            num_news = [2,2,2]
            topic_perc = [0.01, 0.006, 0.002]
            iters = 5
            start = 2
            limit = 21
            step = 2
        elif num_doc < 1000:
            num_news = [2,2,2]
            topic_perc = [0.013, 0.007, 0.003]
            iters = 5
            start = 5
            limit = 51
            step = 5
        elif num_doc < 5000:
            num_news = [2,2,2]
            topic_perc = [0.013, 0.007, 0.003]
            iters = 7
            start = 10
            limit = 74
            step = 7
        elif num_doc < 15000:
            num_news = [2,2,2]
            topic_perc = [0.03, 0.02, 0.01]
            iters = 9
            start = 20
            limit = 111
            step = 10
        elif num_doc < 25000:
            num_news = [2,2,2]
            topic_perc = [0.035, 0.025, 0.015]
            iters = 11
            start = 30
            limit = 166
            step = 15

        else:
            num_news = [2,2,2]
            topic_perc = [0.04, 0.03, 0.02]
            iters = 15
            start = 40
            limit = 176
            step = 15


        for i in range(len(topic_priority)):
            ldamallet = topic_modeling(id2word, corpus, title_list, topic_priority[i], iteration)
            #timeline = topics_to_timeline(news_df, ldamallet, corpus, 3, topic_priority[i], -0.0025 * topic_priority[i] + 0.13, num_news[i]) # 마지막 인자 키워드 개수
            timeline = topics_to_timeline(news_df, ldamallet, corpus, 3, topic_priority[i], topic_perc[i], num_news[i], iters) 
            topics = []
            for j in range(len(timeline.index)):
                t = timeline.iloc[j]
                a = {'date': t.Date,
                     'news': [{'news_id': x} for x in t.ID],
                     'topic': t.Keywords}
                topics.append(a)
            post['topicNum'][i]['topics'] = topics
        result = topic_collection.insert_one(post)
