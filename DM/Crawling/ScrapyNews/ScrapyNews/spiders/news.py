from datetime import datetime
import scrapy
from ScrapyNews.items import ScrapynewsItem
import csv
from newspaper import Article

class NewsUrlSpider(scrapy.Spider):
    name = 'UrlCrawler'

    def start_requests(self):
        return [scrapy.Request(url='https://www.donga.com/news/List?p={}&prod=news&ymd=&m=NP'.format(i), callback=self.parse) for i in range(0,200,20)]


    def parse(self, response):
        for i in range(2,22):
            item = ScrapynewsItem()

            date = response.xpath('//*[@id="content"]/div[{}]/div[@class="rightList"]/a/span[@class="date"]/text()'.format(i)).extract_first()
            title = response.xpath('//*[@id="content"]/div[{}]/div[@class="rightList"]/a/span[@class="tit"]/text()'.format(i)).extract_first()
            url = response.xpath('//*[@id="content"]/div[{}]/div[@class="rightList"]/a/@href'.format(i)).extract_first()            

            article = Article(url)
            article.download()
            article.parse()

            item['journal'] = '동아일보'
            item['date'] = datetime.fromisoformat(date).strftime("%Y-%m-%d")
            item['title'] = title
            item['url'] = url
            item['content'] = article.text

            yield item
