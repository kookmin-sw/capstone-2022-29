import pandas as pd


def timelining(num_topics, per_contrib, num_news_threshold):
  timeline_df = pd.DataFrame(columns = ['Keywords', 'Date'])

  for i in range(1, num_topics+1): # 
    news_df = pd.read_csv("topic("+str(i)+")_news.csv")
    topic_news = news_df[news_df["Topic_Perc_Contrib"] >= per_contrib]
  if len(topic_news) != 0:
    histogram = {}  
    for date in topic_news["Date"].tolist(): 
      histogram[date] = histogram.get(date, 0) + 1 # histogram은 날짜에 해당 토픽이 몇번 나왔는지 들어있음
    print(histogram)
    for key, value in histogram.items():
      if value >= num_news_threshold:
        timeline_df = timeline_df.append({'Keywords': topic_news["Keywords"][0], 'Date': key}, ignore_index=True)
  
  timeline_df = timeline_df.sort_values(by='Date', ascending=False)

  return timeline_df

if __name__ == '__main__':

  timeline = timelining(60, 0.4, 3)
  timeline.to_csv("timeline_한겨례2_nobelow100_60_2_영쩜사_3.csv")

