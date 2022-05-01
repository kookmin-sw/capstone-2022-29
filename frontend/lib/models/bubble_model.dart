class Bubble {
  late String user_id;
  late Bubbles bubbles;

  Bubble({
    required this.user_id,
    required this.bubbles,
  });

  Bubble.fromJson(Map<String, dynamic> json) {
    user_id = json['user_id'];
    bubbles = Bubbles.fromJson(json['bubble']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.user_id;
    data['bubble'] = this.bubbles;
    return data;
  }
}

class Bubbles {
  late String query;
  late int count;

  Bubbles({
    required this.query,
    required this.count,
  });

  Bubbles.fromJson(Map<String, dynamic> json) {
    query = json['query'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['query'] = this.query;
    data['count'] = this.count;
    return data;
  }
}
