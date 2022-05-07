class User {
  late String accessToken;
  late String nickname;
  late String profile;
  // late String? email = "";

  User({
    required this.accessToken,
    required this.nickname,
    required this.profile,
    // required this.email,
  });

  User.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    nickname = json['nickname'];
    profile = json['profile'];
    // email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['nickname'] = this.nickname;
    data['profile'] = this.profile;
    // data['email'] = this.email;
    return data;
  }
}
