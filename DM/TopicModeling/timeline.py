import pandas as pd
from pymongo import MongoClient


def timelining(num_topics, per_contrib, num_news_threshold, folder):
  timeline_df = pd.DataFrame(columns = ['Keywords', 'Date', 'Title'])

  for i in range(1, num_topics+1): # 
    news_df = pd.read_csv(folder + "topic("+str(i)+")_news.csv")
    pd.set_option('display.max_columns', None)
    pd.set_option('display.max_rows', None)
    #print(news_df)
    
    topic_news = news_df[news_df["Topic_Perc_Contrib"] >= per_contrib]
    
    #print(topic_news)
    if len(topic_news) != 0:
      histogram = {}  
      for date in topic_news["Date"].tolist(): 
        histogram[date] = histogram.get(date, 0) + 1 # histogram은 날짜에 해당 토픽이 몇번 나왔는지 들어있음
      #print(histogram)
      for key, value in histogram.items():
        if value >= num_news_threshold:
          title_list = list(topic_news['Title'])
          timeline_df = timeline_df.append({'Keywords': topic_news["Keywords"][0], 'Date': key, 'Title':title_list}, ignore_index=True)
    
    timeline_df = timeline_df.sort_values(by='Date', ascending=False)

  return timeline_df

if __name__ == '__main__':
  
  #print(timeline)
  client = MongoClient("mongodb+srv://BaekYeonsun:hello12345@cluster.3dypr.mongodb.net/database?retryWrites=true&w=majority")
  db = client.database
  topic_collection = db.topics
  post = {'query': '코로나 hj test2',
          'topicNum': [
            {'num': 0,
            
            },
            {'num': 1
            
            },
            {'num': 2
            
            }]
          }
  folders = ["C:\\Users\\rosy0\\OneDrive\\문서\\소융대 자료\\capstone-2022-29\\한겨레_title_40\\", "C:\\Users\\rosy0\\OneDrive\\문서\\소융대 자료\\capstone-2022-29\\한겨레_title_60\\", "C:\\Users\\rosy0\\OneDrive\\문서\\소융대 자료\\capstone-2022-29\\한겨레_title_70\\"]
  for i in range(3):
    folder = folders[i]
    num_topic = int(folder.split('\\')[-2].split('_')[-1])
    print(num_topic)
    timeline = timelining(num_topic, 0.08, 3, folder)
    topics = []
    for j in range(len(timeline.index)):
      t = timeline.iloc[j]
      a = [{'date': str(t.Date),
                    'news': [{'news_id': x} for x in t.Title],
                    'topic': t.Keywords}]
      topics.append(a)

    post['topicNum'][i]['topics'] = topics
    print(post)
    #   post.append(a)
    result = topic_collection.insert_one(post)
    # print(result.inserted_id)
    # print(post)
    # timeline.to_csv("timeline_한겨례2_nobelow100_60_2_영쩜사_3.csv")

