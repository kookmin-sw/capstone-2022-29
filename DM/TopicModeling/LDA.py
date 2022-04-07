import pandas as pd
from konlpy.tag import Mecab
from tqdm import tqdm
import gensim
import gensim.corpora as corpora
from gensim.models.coherencemodel import CoherenceModel


file = '한겨레_코로나_content_2.csv'
llet_path = 'mallet-2.0.8/bin/mallet' 


# 1. Preprocessing Data
# load data
news_df = pd.read_csv(file)

# get only the time, content data
news_df = news_df[['date', 'content']]

# chage data type
news_df['date'] = pd.to_datetime(news_df['date'])
news_df['content'] = news_df['content'].astype(str)


#2. Delete Stopwords
# 2.1 tokenize & get the pos
# 뉴스 데이터의 특징: 띄어쓰기, 오탈자 문제 적음.
# 2.1.1 mecab
key_pos = ['NNG', 'NNP', 'SL', 'SH']
mecab = Mecab()

def get_key_tokens(text):
  tokens = mecab.pos(text)

  return ','.join([token for token, pos in filter(lambda x: (x[1] in key_pos), tokens)])

tokenized_content = []
for i in tqdm(range(len(news_df['content']))):
  tokenized_content.append(get_key_tokens(news_df.loc[i,'content']))

# 2.2 delete stopwords => TODO

# 2.3 make user dictionary => TODO


# 3. Make Corpus
content_list = []

for x in tokenized_content:
  content_list.append(x.split(','))

id2word = corpora.Dictionary(content_list)
id2word.filter_extremes(no_below=20)
corpus = [id2word.doc2bow(content) for content in content_list]


# 4. Topic Modeling
ldamallet = gensim.models.wrappers.LdaMallet(mallet_path, corpus=corpus, num_topics=60, id2word=id2word)
ldamallet.show_topics(num_topics=60, num_words=1)

# 4.1 get coherence
coherence_model_ldamallet = CoherenceModel(model=ldamallet, texts=content_list, dictionary=id2word, coherence='c_v')
coherence_ldamallet = coherence_model_ldamallet.get_coherence()

# 4.2 find optimal model, num_topics
def compute_coherence_values(dictionary, corpus, texts, limit, start=4, step=2):

    coherence_values = []
    model_list = []
    for num_topics in range(start, limit, step):
        model = gensim.models.wrappers.LdaMallet(mallet_path, corpus=corpus, num_topics=60, id2word=id2word)
        model_list.append(model)
        coherencemodel = CoherenceModel(model=model, texts=content_list, dictionary=dictionary, coherence='c_v')
        coherence_values.append(coherencemodel.get_coherence())

    return model_list, coherence_values

limit=55 
start=18
step=4
x = range(start, limit, step)
topic_num = 0
count = 0
max_coherence = 0
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
def format_topics_sentences(ldamodel=ldamallet, corpus=corpus, texts=content_list): 
    sent_topics_df = pd.DataFrame()

    # Get main topic in each document
    #ldamodel[corpus]: lda_model에 corpus를 넣어 각 토픽 당 확률을 알 수 있음
    for i, row in tqdm(enumerate(ldamodel[corpus])):
        row = sorted(row, key=lambda x: (x[1]), reverse=True)
        # Get the Dominant topic, Perc Contribution and Keywords for each document
        for j, (topic_num, prop_topic) in enumerate(row):
            if j == 0:  # => dominant topic
                wp = ldamodel.show_topic(topic_num, topn=1)
                topic_keywords = ", ".join([word for word, prop in wp])
                sent_topics_df = sent_topics_df.append(pd.Series([int(topic_num), round(prop_topic,4), topic_keywords]), ignore_index=True)
            else:
                break

    sent_topics_df.columns = ['Dominant_Topic', 'Perc_Contribution', 'Topic_Keywords']

    sent_topics_df = pd.concat([sent_topics_df, news_df['content'],news_df['date']], axis=1)
    sent_topics_df.reset_index()
    sent_topics_df.columns = ['Document_No', 'Dominant_Topic', 'Topic_Perc_Contrib', 'Keywords', 'Content','Date']
    
    return(sent_topics_df)

df_topic_sents_keywords = format_topics_sentences(ldamodel=ldamallet, corpus=corpus, texts=content_list)

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

lda_inform.to_csv ("./한겨례_Results_nobelow20_60_1/lda_inform_한겨례_nobelow200_60_1.csv", index = None)

for i in range(1,60+1):
    globals()['df_{}'.format(i)]=df_topic_news.loc[df_topic_news.Dominant_Topic==str(i)]
    globals()['df_{}'.format(i)].sort_values('Topic_Perc_Contrib',ascending=False,inplace = True)
    globals()['df_{}'.format(i)].to_csv ("./한겨례_Results_nobelow20_60_1/topic("+str(i)+")_news.csv", index = None)
