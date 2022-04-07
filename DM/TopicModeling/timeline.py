import pandas as pd

timeline_df = pd.DataFrame(columns = ['Keywords', 'Date'])

for i in range(1,60+1):
  news_df = pd.read_csv("topic("+str(i)+")_news.csv")
  topic_news = news_df[news_df["Topic_Perc_Contrib"] >= 0.4]

  if len(topic_news) != 0:
    histogram = {}  
    for date in topic_news["Date"].tolist(): 
            histogram[date] = histogram.get(date, 0) + 1
    topic_date = [k for k,v in histogram.items() if max(histogram.values()) == v]

    if histogram[topic_date[0]] >= 3:
      # print(topic_news["Keywords"][0], topic_date, histogram[topic_date[0]])
      for i in range(len(topic_date)):
        timeline_df = timeline_df.append({'Keywords': topic_news["Keywords"][0], 'Date': topic_date[i]}, ignore_index=True)

timeline_df = timeline_df.sort_values(by='Date', ascending=False)
  #topic_news["Date"].value_counts().Date
  # if topic_news["Date"].value_counts()[0] >= 3:
  #   print()
  #print(topic_news)
timeline_df.to_csv("timeline_한겨례2_nobelow100_60_2_영쩜사_3.csv")