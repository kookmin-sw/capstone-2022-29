import pandas as pd
from pymongo import MongoClient
from datetime import datetime, timedelta


def timelining(num_topics, per_contrib, num_news_threshold, folder):
  timeline_df = pd.DataFrame(columns = ['ID', 'Keywords', 'Date', 'Title'])

  for i in range(1, num_topics+1): # 
    news_df = pd.read_csv(folder + "topic("+str(i)+")_news.csv")
    # pd.set_option('display.max_columns', None)
    # pd.set_option('display.max_rows', None)
    #print(news_df)
    
    topic_news = news_df[news_df["Topic_Perc_Contrib"] >= per_contrib]
    topic_news = topic_news.sort_values(by='Date', ascending=False)

    #print(topic_news)
    if len(topic_news) != 0:
      histogram = {}  
      prev_date = datetime(2999, 12, 30)
      for date in topic_news["Date"].tolist(): 
        date_list = list(map(int, date.split('-')))
        #print(date_list)
        cur_date = datetime(date_list[0], date_list[1], date_list[2])
        diff_date = prev_date - cur_date
        #print(diff_date.days)
        if diff_date.days <= 7: # 일주일 이내의 중복된 토픽은 제거
          continue
        
        histogram[date] = histogram.get(date, 0) + 1 # histogram은 날짜에 해당 토픽이 몇번 나왔는지 들어있음
        prev_date = cur_date
      #   print(histogram[date])
      # print(histogram)
      #print(histogram)
      for key, value in histogram.items():
        print(key, value)
        if value >= num_news_threshold:
          title_list = list(topic_news['Title'])
          id_list = list(topic_news['ID'])
          timeline_df = timeline_df.append({'ID': id_list, 'Keywords': topic_news["Keywords"][0], 'Date': key, 'Title':title_list}, ignore_index=True)
    
    timeline_df = timeline_df.sort_values(by='Date', ascending=False)

  return timeline_df

if __name__ == '__main__':
  
  #print(timeline)
  client = MongoClient("mongodb+srv://BaekYeonsun:hello12345@cluster.3dypr.mongodb.net/database?retryWrites=true&w=majority")
  db = client.database
  topic_collection = db.topics
  post = {
          'query': '19',
          'topicNum': [{'num': 0},
                       {'num': 1},
                       {'num': 2}]
         }

  # 추후에는 폴더 이름 query_토픽개수로 바꾸기
  folders = ["/home/ubuntu/capstone-2022-29/DM/TopicModeling/result/19_title_35/", "/home/ubuntu/capstone-2022-29/DM/TopicModeling/result/19_title_45/", "/home/ubuntu/capstone-2022-29/DM/TopicModeling/result/19_title_65/"]
  for i in range(3):
    folder = folders[i]
    print(folder.split('/'))
    num_topic = int(folder.split('/')[-2].split('_')[-1])
    print(num_topic)
    timeline = timelining(num_topic, 0.09, 1, folder)
    print(timeline)
    topics = []
    for j in range(len(timeline.index)):
      t = timeline.iloc[j]
      a = {'date': str(t.Date),
                    'news': [{'news_id': x} for x in t.ID],
                    'topic': t.Keywords}
      topics.append(a)
    #print(topics)
    post['topicNum'][i]['topics'] = topics
    # print(topic_collection.index_information())
    #   post.append(a)
  result = topic_collection.insert_one(post)

