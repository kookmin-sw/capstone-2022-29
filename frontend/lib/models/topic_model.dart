class Topic {
  late String query;
  late TopicNum topicNum;

  Topic({
    required this.query,
    required this.topicNum,
  });

  Topic.fromJson(Map<String, dynamic> json) {
    query = json['query'];
    topicNum = TopicNum.fromJson(json['topicNum']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['query'] = this.query;
    data['topicNum'] = this.topicNum;
    return data;
  }
}

class TopicNum {
  late int num;
  late Topics topics;

  TopicNum({
    required this.num,
    required this.topics,
  });

  TopicNum.fromJson(Map<String, dynamic> json) {
    num = json['num'];
    topics = Topics.fromJson(json['topics']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num'] = this.num;
    data['topics'] = this.topics;
    return data;
  }
}

class Topics {
  late String date;
  late String topic;
  late NewsId newsId;

  Topics({
    required this.date,
    required this.topic,
    required this.newsId,
  });

  Topics.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    topic = json['topic'];
    newsId = NewsId.fromJson(json['news']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['topic'] = this.topic;
    data['news'] = this.newsId;
    return data;
  }
}

class NewsId {
  late String news_id;

  NewsId({
    required this.news_id,
  });

  NewsId.fromJson(Map<String, dynamic> json) {
    news_id = json['news_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['news_id'] = this.news_id;
    return data;
  }
}
