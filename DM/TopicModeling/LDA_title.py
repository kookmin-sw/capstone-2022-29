# -*- coding: utf-8 -*-

import pandas as pd
from konlpy.tag import Mecab
from tqdm import tqdm
import gensim
import gensim.corpora as corpora
from gensim.models.coherencemodel import CoherenceModel
from pprint import pprint
import re


# gensim 버전 3.8인지, mallet 설치

file = 'DM\\TopicModeling\\han_corona_2.csv' # 경로 입력할 때 역슬래시 두개 넣기,,,
mallet_path = "C:\\Mallet\\bin\\mallet"  # 이거 mallet2108어쩌구인가로도 바꿔보기

# 1. Preprocessing Data
# load data
news_df = pd.read_csv(file)

# get only the time, title data
news_df = news_df[['date', 'title']]

# chage data type
news_df['date'] = pd.to_datetime(news_df['date'])
news_df['title'] = news_df['title'].astype(str)


#2. Delete Stopwords
# 2.1 tokenize & get the pos
# 뉴스 데이터의 특징: 띄어쓰기, 오탈자 문제 적음.
# 2.1.1 mecab
key_pos = ['SL', 'NNG', 'NNP', 'VV', 'VA', 'XR', 'SH'] # ['NNG', 'NNP', 'SL', 'SH']
stop_words = ['포토', '인터뷰', 'Q&A', '사설']
mecab = Mecab("C:\\mecab\\mecab-ko-dic") # mecab dictionary 경로. colab에서 할 때는 안 넣어줘도 됐었음

def get_key_tokens(text):
  text = re.sub(r'\[[^)]*\]', '', text) # [포토], [인터뷰], [11회 비정규 노동 수기 공모전], [단독] 이런거 없애기
  tokens = mecab.pos(text)
  token_list = []
  for token, pos in filter(lambda x: (x[1] in key_pos), tokens):
      if pos == 'VV' or pos == 'VA' or pos == 'XR':
          if len(token) <= 1:
              continue
      token_list.append(token)
  return token_list

  # return ','.join([token for token, pos in filter(lambda x: (x[1] in key_pos), tokens)])

title_list = []
for i in tqdm(range(len(news_df['title']))):
  title_list.append(get_key_tokens(news_df.loc[i,'title']))

# 2.2 delete stopwords => TODO

# 2.3 make user dictionary => TODO


# 3. Make Corpus
# title_list = []

# for x in tokenized_title:
#   title_list.append(x.split(','))

id2word = corpora.Dictionary(title_list)
id2word.filter_extremes(no_below=5)
corpus = [id2word.doc2bow(content) for content in title_list]


# 4. Topic Modeling
print(1111111111111111111111111111111111111111111111)
# 얘 passes라는 인자로 epoch 조절 가능
ldamallet = gensim.models.wrappers.LdaMallet(mallet_path, corpus=corpus, num_topics=60, id2word=id2word, iterations=1000) # gensim 3.8 버전에만 존재
# 그 막 출력되는게 위에 코드 결과야 1000번 도는거 아마 1000번이 default인가봐
print(222222222222222222222222222222222222222222)
pprint(ldamallet.show_topics(num_topics=60, num_words=3))
print(33333333333333333333333333333333333333)

# 4.1 get coherence
coherence_model_ldamallet = CoherenceModel(model=ldamallet, texts=title_list, dictionary=id2word, coherence='c_v')
print(4444444444444444444444444444444444444444444)
coherence_ldamallet = coherence_model_ldamallet.get_coherence()
print(555555555555555555555555555555555555555555555) # -> 이건 실행 안됐음

# 4.2 find optimal model, num_topics
def compute_coherence_values(dictionary, corpus, texts, limit, start, step):

    coherence_values = []
    model_list = []
    for num_topics in range(start, limit, step):
        print(start,"!!!!!!!!!!!!!!!!!!!!", 1111111111111111111111111111111111111111111)
        model = gensim.models.wrappers.LdaMallet(mallet_path, corpus=corpus, num_topics=num_topics, id2word=id2word)
        print(start, "!!!!!!!!!!!!!!!!!!!!",22222222222222222222222222222222222222222222222)
        
        model_list.append(model)
        print(start, "!!!!!!!!!!!!!!!!!!!!",33333333333333333333333333333333333333333333333333333)
        coherencemodel = CoherenceModel(model=model, texts=title_list, dictionary=dictionary, coherence='c_v')
        print(start, "!!!!!!!!!!!!!!!!!!!!",44444444444444444444444444444444)
        coherence_values.append(coherencemodel.get_coherence())

    return model_list, coherence_values

model_list, coherence_values = compute_coherence_values(dictionary=id2word, corpus=corpus, texts=title_list, start=40, limit=71, step=5)

limit=71
start=40
step=5
x = range(start, limit, step)
topic_num = 0
count = 0
max_coherence = 0
model_list_num = 0
for m, cv in zip(x, coherence_values):
    print("Num Topics =", m, " has Coherence Value of", cv)
    coherence = cv
    if coherence >= max_coherence:
        max_coherence = coherence
        topic_num = m
        model_list_num = count   
    count = count+1

optimal_model = model_list[model_list_num]
model_topics = optimal_model.show_topics(formatted=False)

print(optimal_model.print_topics(num_words=1))


# 4.3 formmating output with DF
def format_topics_sentences(ldamodel=ldamallet, corpus=corpus, texts=title_list):
    # Init output
    sent_topics_df = pd.DataFrame()

    # Get main topic in each document
    #ldamodel[corpus]: lda_model에 corpus를 넣어 각 토픽 당 확률을 알 수 있음
    for i, row in tqdm(enumerate(ldamodel[corpus])):
        row = sorted(row, key=lambda x: (x[1]), reverse=True)
        # Get the Dominant topic, Perc Contribution and Keywords for each document
        for j, (topic_num, prop_topic) in enumerate(row):
            if j == 0:  # => dominant topic
                wp = ldamodel.show_topic(topic_num, topn=2) #여기변경~~~~~~~~~~
                topic_keywords = ", ".join([word for word, prop in wp])
                sent_topics_df = sent_topics_df.append(pd.Series([int(topic_num), round(prop_topic,4), topic_keywords]), ignore_index=True)
            else:
                break
    sent_topics_df.columns = ['Dominant_Topic', 'Perc_Contribution', 'Topic_Keywords']
    print(type(sent_topics_df))

    # Add original text to the end of the output
    #contents = pd.Series(texts)
    #sent_topics_df = pd.concat([sent_topics_df, contents], axis=1)
    sent_topics_df = pd.concat([sent_topics_df, news_df['title'],news_df['date']], axis=1)
    return(sent_topics_df)

df_topic_sents_keywords = format_topics_sentences(ldamodel=ldamallet, corpus=corpus, texts=title_list)


# Format
df_topic_news = df_topic_sents_keywords.reset_index()
df_topic_news.columns = ['Document_No', 'Dominant_Topic', 'Topic_Perc_Contrib', 'Keywords', 'Title','Date']

# 4.4 grouping top 5 
sent_topics_sorteddf_mallet = pd.DataFrame()

sent_topics_outdf_grpd = df_topic_sents_keywords.groupby('Dominant_Topic')

for i, grp in sent_topics_outdf_grpd:
    sent_topics_sorteddf_mallet = pd.concat([sent_topics_sorteddf_mallet, grp.sort_values(['Perc_Contribution'], ascending=[0]).head(1)], axis=0)

# reset index
sent_topics_sorteddf_mallet.reset_index(drop=True, inplace=True)
topic_counts = df_topic_sents_keywords['Dominant_Topic'].value_counts()
topic_counts.sort_index(inplace=True)

topic_contribution = round(topic_counts/topic_counts.sum(), 4)


# 5. Save as csv file
lda_inform = pd.concat([sent_topics_sorteddf_mallet, topic_counts, topic_contribution], axis=1)
lda_inform.columns=["Topic_Num", "Topic_Perc_Contrib", "Keywords", "Content", "Date", "Num_Documents", "Perc_Documents"]
lda_inform = lda_inform[["Topic_Num","Keywords","Num_Documents","Perc_Documents"]]


lda_inform['Topic_Num'] =lda_inform['Topic_Num'] +1
lda_inform.Topic_Num = lda_inform.Topic_Num.astype(str)
lda_inform['Topic_Num'] =lda_inform['Topic_Num'].str.split('.').str[0]
df_topic_news['Dominant_Topic'] =df_topic_news['Dominant_Topic'] +1
df_topic_news.Dominant_Topic = df_topic_news.Dominant_Topic.astype(str)
df_topic_news['Dominant_Topic'] =df_topic_news['Dominant_Topic'].str.split('.').str[0]

lda_inform.to_csv (".\\한겨레_title_nobelow20_60_2\\lda_inform_한겨례_nobelow200_60_1.csv", encoding='euc-kr', index = None)

for i in range(1,60+1):
    globals()['df_{}'.format(i)]=df_topic_news.loc[df_topic_news.Dominant_Topic==str(i)]
    globals()['df_{}'.format(i)].sort_values('Topic_Perc_Contrib',ascending=False,inplace = True)
    globals()['df_{}'.format(i)].to_csv (".\\한겨레_title_nobelow20_60_2\\topic("+str(i)+")_news.csv", encoding='euc-kr', index = None)
