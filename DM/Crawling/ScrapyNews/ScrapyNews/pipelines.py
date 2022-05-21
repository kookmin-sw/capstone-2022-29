# # Define your item pipelines here
# #
# # Don't forget to add your pipeline to the ITEM_PIPELINES setting
# # See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# # useful for handling different item types with a single interface
# from itemadapter import ItemAdapter


# class ScrapynewsPipeline:
#     def process_item(self, item, spider):
#         return item


from __future__ import unicode_literals
from scrapy.exporters import JsonItemExporter, CsvItemExporter
from scrapy.exceptions import DropItem
from datetime import datetime, date, timedelta


# from scrapy import log 
 
#JSON파일로 저장하는 클래스
class JsonPipeline(object):
    def __init__(self):
        self.file = open("newsCrawl.json", 'wb')
        self.exporter = JsonItemExporter(self.file, encoding='utf-8', ensure_ascii=False)
        self.exporter.start_exporting()
 
    def close_spider(self, spider):
        self.exporter.finish_exporting()
        self.file.close()
 
    def process_item(self, item, spider):
        self.exporter.export_item(item)
        return item
 
#CSV 파일로 저장하는 클래스
class CsvPipeline(object):
    def __init__(self):
        yesterday = datetime.today() - timedelta(1)
        yesterday = yesterday.strftime("%Y-%m-%d")
        self.file = open("newsCrawl-{}.csv".format(yesterday), 'wb')
        self.exporter = CsvItemExporter(self.file, encoding='utf-8')
        self.exporter.start_exporting()
 
    def close_spider(self, spider):
        self.exporter.finish_exporting()
        self.file.close()
 
    def process_item(self, item, spider):
        self.exporter.export_item(item)
        return item
 
 #MongoDB에 저장하는 
# class MongoDBPipeline(object):
 
#     def __init__(self):
#         connection = pymongo.MongoClient(
#             settings['MONGODB_SERVER'],
#             settings['MONGODB_PORT']
#         )
#         db = connection[settings['MONGODB_DB']]
#         self.collection = db[settings['MONGODB_COLLECTION']]
 
#     def process_item(self, item, spider):
#         valid = True
#         for data in item:
#             if not data:
#                 valid = False
#                 raise DropItem("Missing {0}!". format(data))
 
#         if valid:
#             self.collection.insert(dict(item))
#             log.msg("News added to MongoDB database!",
#                     level=log.DEBUG, spider=spider)
 
#         return item

import pymongo
# from itemadapter import ItemAdapter

# class MongoPipeline:
#     collection_name = 'scrapy_items'

#     def __init__(self, mongo_uri, mongo_db):
#         self.mongo_uri = mongo_uri
#         self.mongo_db = mongo_db

#     @classmethod
#     def from_crawler(cls, crawler):
#         return cls(
#             mongo_uri=crawler.settings.get('MONGO_URI'),
#             mongo_db=crawler.settings.get('MONGO_DATABASE', 'items')
#         )

#     def open_spider(self, spider):
#         self.client = pymongo.MongoClient(self.mongo_uri)
#         self.db = self.client[self.mongo_db]

#     def close_spider(self, spider):
#         self.client.close()

#     def process_item(self, item, spider):
#         self.db[self.collection_name].insert_one(ItemAdapter(item).asdict())
#         return item

class MongoDBPipeline:
    def __init__(self):
        self.conn = pymongo.MongoClient("mongodb+srv://BaekYeonsun:<password>@cluster.3dypr.mongodb.net/database?retryWrites=true&w=majority")

        db = self.conn['database']
        self.collection = db['news']

    def process_item(self, item, spider):
        self.collection.insert(dict(item))
        return item