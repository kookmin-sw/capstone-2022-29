class Bookmark {
  late String user_id;
  late Bookmarks bookmarks;

  Bookmark({
    required this.user_id,
    required this.bookmarks,
  });

  Bookmark.fromJson(Map<String, dynamic> json) {
    user_id = json['user_id'];
    bookmarks = Bookmarks.fromJson(json['bookmark']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.user_id;
    data['bookmark'] = this.bookmarks;
    return data;
  }
}

class Bookmarks {
  late String news_id;
  late String query;
  late String topic;

  Bookmarks({
    required this.news_id,
    required this.query,
    required this.topic,
  });

  Bookmarks.fromJson(Map<String, dynamic> json) {
    news_id = json['news_id'];
    query = json['query'];
    topic = json['topic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['news_id'] = this.news_id;
    data['query'] = this.query;
    data['topic'] = this.topic;
    return data;
  }
}
