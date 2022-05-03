class Keyword {
  late String user_id;
  late Keywords keywords;

  Keyword({
    required this.user_id,
    required this.keywords,
  });

  Keyword.fromJson(Map<String, dynamic> json) {
    user_id = json['user_id'];
    keywords = Keywords.fromJson(json['keywords']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.user_id;
    data['keywords'] = this.keywords;
    return data;
  }
}

class Keywords {
  late String keyword;

  Keywords({
    required this.keyword,
  });

  Keywords.fromJson(List<dynamic> json) {
    keyword = json[0]['keyword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['keyword'] = this.keyword;
    return data;
  }
}
