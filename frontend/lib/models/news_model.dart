class News {
  late String journal;
  late String date;
  late String title;
  late String url;
  late String content;
  late String summary;

  News({
    required this.journal,
    required this.date,
    required this.title,
    required this.url,
    required this.content,
    required this.summary,
  });

  News.fromJson(Map<String, dynamic> json) {
    journal = json['journal'];
    date = json['date'];
    title = json['title'];
    url = json['url'];
    content = json['content'];
    summary = json['summary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['journal'] = this.journal;
    data['date'] = this.date;
    data['title'] = this.title;
    data['url'] = this.url;
    data['content'] = this.content;
    data['summary'] = this.summary;
    return data;
  }
}
