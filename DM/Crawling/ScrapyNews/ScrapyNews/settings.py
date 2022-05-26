# Scrapy settings for ScrapyNews project
#
# For simplicity, this file contains only settings considered important or
# commonly used. You can find more settings consulting the documentation:
#
#     https://docs.scrapy.org/en/latest/topics/settings.html
#     https://docs.scrapy.org/en/latest/topics/downloader-middleware.html
#     https://docs.scrapy.org/en/latest/topics/spider-middleware.html

BOT_NAME = 'ScrapyNews'

SPIDER_MODULES = ['ScrapyNews.spiders']
NEWSPIDER_MODULE = 'ScrapyNews.spiders'


# Crawl responsibly by identifying yourself (and your website) on the user-agent
#USER_AGENT = 'ScrapyNews (+http://www.yourdomain.com)'

# Obey robots.txt rules
ROBOTSTXT_OBEY = True

LOG_FILE = 'spider.log'  # log 파일 위치
LOG_LEVEL = 'INFO'       # 기본은 DEBUG 임

DOWNLOAD_DELAY = 0.25    # 250ms 기다림, 기본값은 안기다림
CONCURRENT_REQUESTS = 1  # 기본값은 16

HTTPCACHE_ENABLED = True  # 기본 값은 False

MONGO_URI = 'mongodb+srv://BaekYeonsun:hello12345@cluster.3dypr.mongodb.net/database?retryWrites=true&w=majority'  #로컬호스트에 mongdb저장시
MONGO_DATABASE = 'database'  #자신의 몽고db db명

CONCURRENT_REQUESTS = 1  

# Url 크롤링시 CSVPipeline 설정
ITEM_PIPELINES = {'ScrapyNews.pipelines.MongoDBPipeline': 300}
INSTALLED_APPS = (
    'django_crontab'
)
CRONJOBS = [
    ('*/15 * * * *', '/Users/choihyewon/VScode/capstone-2022-29/DM/Crawling/ScrapyNews/crawl.sh')
]

FEED_EXPORT_ENCODING = 'utf-8'
