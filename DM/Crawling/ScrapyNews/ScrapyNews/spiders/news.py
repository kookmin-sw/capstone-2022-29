from datetime import datetime
import scrapy
from ScrapyNews.items import ScrapynewsItem
import csv
from newspaper import Article

class NewsUrlSpider(scrapy.Spider):
    name = 'UrlCrawler'

    def start_requests(self):
        urls = [
            'https://www.donga.com/news/List?p=0&prod=news&ymd=&m=NP',
        ]

        return [scrapy.Request(url=url, callback=self.parse) for url in urls]
        # 또는
        #for url in urls
        #    yield scrapy.Reqest(url=url, callback=self.parse

    def parse(self, response):
        for i in range(2,22):
            item = ScrapynewsItem()

            date = response.xpath('//*[@id="content"]/div[{}]/div[@class="rightList"]/a/span[@class="date"]/text()'.format(i)).extract_first()
            title = response.xpath('//*[@id="content"]/div[{}]/div[@class="rightList"]/a/span[@class="tit"]/text()'.format(i)).extract_first()
            url = response.xpath('//*[@id="content"]/div[{}]/div[@class="rightList"]/a/@href'.format(i)).extract_first()            

            item['date'] = datetime.fromisoformat(date).strftime("%Y-%m-%d")
            item['title'] = title
            item['url'] = url


            yield item


