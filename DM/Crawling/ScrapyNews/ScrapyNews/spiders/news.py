import scrapy
from ..items import ScrapynewsItem
from newspaper import Article
from datetime import datetime, date, timedelta


class DongaNewsSpider(scrapy.Spider):
    name = 'NewsCrawler'

    def start_requests(self):
        yesterday = date.today() - timedelta(1)
        yesterday = yesterday.strftime("%Y%m%d")

        urlList = []
        for page in range(1,300,20):
            urlList.append(['https://www.donga.com/news/List?p={}&prod=news&ymd={}&m=NP'.format(page, yesterday),self.dongaParse])
        for page in range(0,20):
            urlList.append(['https://www.hani.co.kr/arti/list{}.html'.format(page),self.haniParse])
        
        for url, parse in urlList:
            yield scrapy.Request(url=url, callback=parse)

    def dongaParse(self, response):
        print(response)
        print('')
        for i in range(4,24):
            item = ScrapynewsItem()
            date = response.xpath('//*[@id="content"]/div[{}]/div[@class="rightList"]/span[@class="date"]/text()'.format(i)).extract_first()
            title = response.xpath('//*[@id="content"]/div[{}]/div[@class="rightList"]/span[@class="tit"]/a/text()'.format(i)).extract_first()
            url = response.xpath('//*[@id="content"]/div[{}]/div[@class="rightList"]/span[@class="tit"]/a/@href'.format(i)).extract_first()            

            article = Article(url)
            article.download()
            article.parse()

            item['journal'] = '동아일보'
            item['date'] = datetime.fromisoformat(date).strftime("%Y-%m-%d")
            item['title'] = title
            item['url'] = url
            item['content'] = article.text
            print(title)

            yield item

    def haniParse(self, response):
        print(response)
        for i in range(1,16):
            item = ScrapynewsItem()

            yesterday = datetime.today() - timedelta(1)
            yesterday = yesterday.strftime("%Y-%m-%d")

            date = response.xpath('//*[@id="section-left-scroll-in"]/div[3]/div[{}]/div/p/span[@class="date"]/text()'.format(i)).extract_first()
            date = datetime.fromisoformat(date).strftime("%Y-%m-%d")
            title = response.xpath('//*[@id="section-left-scroll-in"]/div[3]/div[{}]/div/h4/a/text()'.format(i)).extract_first()
            
            url = response.xpath('//*[@id="section-left-scroll-in"]/div[3]/div[{}]/div/h4/a/@href'.format(i)).extract_first()            
            url = 'https://www.hani.co.kr' + url

            article = Article(url)
            article.download()
            article.parse()

            item['journal'] = '한겨레'
            item['date'] = datetime.fromisoformat(date).strftime("%Y-%m-%d")
            item['title'] = title
            item['url'] = url
            item['content'] = article.text

            print(title)

            yield item
