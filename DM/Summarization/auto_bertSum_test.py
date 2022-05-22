from asyncio.windows_events import NULL
import requests
import json
from tqdm import tqdm
import pandas as pd
from more_itertools import locate
from multiprocessing.dummy import Pool as ThreadPool
from bson.objectid import ObjectId
from pymongo import MongoClient
import datetime  
 
today = datetime.date.today()  
yesterday = today - datetime.timedelta(1)
yesterday = yesterday.strftime("%Y-%m-%d")

### 입력 csv 파일 바꿔야함
news_df = pd.read_csv("/home/ubuntu/capstone-2022-29/DM/Crawling/ScrapyNews/ScrapyNews/spiders/newsCrawl-{}.csv".format(yesterday)) #.drop('Unnamed: 0', axis=1)

##############################################################################

### 동아일보 들여쓰기
new_list = []

for i in tqdm(range(len(news_df))):
    # idx = news_df.loc[i]['_id'] ### 언니가 받아오는 건 _id 없을 듯 -> 확인하고 바꿔주기
    test_txt = news_df.loc[i]['content']
    date = news_df.loc[i]['date']
    journal = news_df.loc[i]['journal']
    summary = news_df.loc[i]['summary']
    title = news_df.loc[i]['title']
    url = news_df.loc[i]['url']
        
    if journal == '동아일보':
        # 문장 끝 부호 인덱스 구하기
        pos_1 = list(locate(test_txt, (lambda x: x == ".")))
        pos_2 = list(locate(test_txt, (lambda x: x == "?")))
        pos_3 = list(locate(test_txt, (lambda x: x == "!")))

        pos = (pos_1 + pos_2 + pos_3)
        pos.sort()
        
        # 문장별 리스트로 쪼개기
        txts = []
        for i in range(len(pos)):
            if i == 0:
                txts.append(test_txt[:(pos[i]+1)])
            elif i == (len(pos)-1):
                txts.append(test_txt[(pos[i-1]+1):(pos[i]+1)])
                txts.append(test_txt[(pos[i]+1):])
            else:
                txts.append(test_txt[(pos[i-1]+1):(pos[i]+1)])
                
        # \n 추가
        # 쪼개서 추가하는 이유.. 확인하고 바로 \n 추가하면 인덱스가 달라져서..
        txt = ""
        for i in range(1, len(txts)):
            if len(txts[i]) == 0:
                continue
            elif txts[i][0] != " ":
                txts[i - 1] += "\n\n"

        # 문장 하나로 합치기
        for i in range(len(txts)):
            txt += txts[i]
        
        ### 순서 바꿔야함
        # Df에서 바로 변경하고 싶었지만, 변경되지 않아서 새로 만듦
        new_list.append(
            {
                # "_id" : idx,
                "content" : txt,
                "date" : date,
                "journal" : journal,
                "summary" : summary,
                "title" : title,
                "url" : url
            }
        )
    else: # 한겨레일 때
        new_list.append(
            {
                # "_id" : idx,
                "content" : test_txt,
                "date" : date,
                "journal" : journal,
                "summary" : summary,
                "title" : title,
                "url" : url
            }
        )

col_name = ["content", "date", "journal", "summary", "title", "url"]
news_df_test = pd.DataFrame(new_list, columns=col_name)

##############################################################################

### 리스트 생성
# idxs = news_df_test['_id'].tolist()
texts = news_df_test['content'].tolist()
dates = news_df_test['date'].tolist()
journals = news_df_test['journal'].tolist()
summaries = news_df_test['summary'].tolist()
titles = news_df_test['title'].tolist()
urls = news_df_test['url'].tolist()

idx_text = list(zip(texts, dates, journals, summaries, titles, urls))

for i in tqdm(range(len(idx_text))):
    idx_text[i] = list(idx_text[i])
    
##############################################################################
    
## DB 연결
client = MongoClient("mongodb+srv://BaekYeonsun:hello12345@cluster.3dypr.mongodb.net/database?retryWrites=true&w=majority")
collection = client.database.news

##############################################################################

def inference(texts):
    # idx = texts[0]
    text = texts[0]
    date = texts[1]
    journal = texts[2]
    summary = texts[3]
    title = texts[4]
    url = texts[5]
    
    if (summary == "NaN"):
        if (text != ""):
            headers = {'Content-Type':'application/json', 
                       'User-Agent' : "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36",
                       'Connection':'close'
                      }
            address = "http://127.0.0.1:8000/predict" # 주소 확인해보기
            data = {'text' : text }

            try:
                resp = requests.get(address, data=json.dumps(data), headers=headers)
                news_dict = {
                    "journal" : journal,
                    "date" : date,
                    "title" : title,
                    "url" : url,
                    "content" : text,
                    "summary" : str(resp.content, encoding='utf-8')
                }
                collection.insert_one(news_dict)
                resp.close()
            except requests.exceptions.Timeout as errd:
                print("Timeout Error : ", errd)

            except requests.exceptions.ConnectionError as errc:
                print("Error Connecting : ", errc)

            except requests.exceptions.HTTPError as errb:
                print("Http Error : ", errb)
            # Any Error except upper exception
            except requests.exceptions.RequestException as erra:
                print("AnyException : ", erra)

        else:
            news_dict = {
                "journal" : journal,
                "date" : date,
                "title" : title,
                "url" : url,
                "content" : text,
                "summary" : summary
            }
            collection.insert_one(news_dict)
    
    return ''

##############################################################################

pool = ThreadPool(10)

try:
    for _ in tqdm(pool.imap_unordered(inference, idx_text), total=len(idx_text)):
        pass
    
    # print("finish")
    
except:
    pool.close()
    pool.terminate()
    pool.join()