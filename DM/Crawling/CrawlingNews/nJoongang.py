from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import time
from pandas import DataFrame

driver = webdriver.Chrome()

url = 'https://www.joongang.co.kr/search/news?keyword=%EC%BD%94%EB%A1%9C%EB%82%98'

driver.implicitly_wait(1)
driver.get(url)

df = []
col = ['date', 'title', 'content']
df = DataFrame(df, columns=col)

cnt = 0
while cnt <= 10: # 더보기 계속 클릭하기

    more = driver.find_element_by_css_selector('#container > section > div > section > div > a')
    more.click()
    time.sleep(0.1)
    cnt+=1
    
for i in range(1,200):
    try:
        title = driver.find_element_by_css_selector('#container > section > div > section > ul > li:nth-child(' + str(i) + ') > div > h2 > a')
        date = driver.find_element_by_css_selector('#container > section > div > section > ul > li:nth-child(' + str(i) + ') > div > div > p.date')
        title_text = title.text
        date_text = date.text


        title.send_keys(Keys.ENTER)

        contents = driver.find_elements_by_css_selector('#article_body > p')

        content_text = ''
        for content in contents:
            content_text += content.text

        news = {'date': date_text, "title": title_text, "content": content_text}
        df = df.append(news, ignore_index=True)
        driver.back()
        time.sleep(1)

    except:
        break


df.to_csv('joongang2.csv', encoding='utf-8-sig')
