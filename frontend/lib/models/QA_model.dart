// ignore_for_file: file_names

class QA {
  late String title;
  late String content;
  late String receiver;

  QA({
    required this.title,
    required this.content,
    required this.receiver,
  });

  QA.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    receiver = json['recevier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['content'] = content;
    return data;
  }
}
