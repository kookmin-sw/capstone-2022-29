class Bookmark {
  late String user_id;
  late String query;
  late int count;

  Bookmark({
    required this.user_id,
    required this.query,
    required this.count,
  });

  Bookmark.fromJson(Map<String, dynamic> json) {
    user_id = json['user_id'];
    query = json['query'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.user_id;
    data['query'] = this.query;
    data['count'] = this.count;
    return data;
  }
}
