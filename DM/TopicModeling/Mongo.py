from pymongo import MongoClient

client = MongoClient(host='127.0.0.1', port=27017, username='BaekYeonsun', password='hello12345')
# db = clinet.database
# collection = db.news
print(client.list_database_names())