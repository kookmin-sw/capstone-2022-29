from pymongo import MongoClient

client = MongoClient(host='127.0.0.1', port=###, username='###', password='###')
# db = clinet.database
# collection = db.news
print(client.list_database_names())
