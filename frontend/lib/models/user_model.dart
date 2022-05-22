class User {
  late String accessToken;
  late String nickname;
  late String profile;
  late String id;
  late String password;
  // late String? email = "";

  User({
    required this.accessToken,
    required this.nickname,
    required this.profile,
    required this.id,
    required this.password,
    // required this.email,
  });

  User.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    nickname = json['nickname'];
    profile = json['profile'];
    id = json['id'];
    password = json['password'];
    // email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['nickname'] = this.nickname;
    data['profile'] = this.profile;
    data['id'] = this.id;
    data['password'] = this.password;
    // data['email'] = this.email;
    return data;
  }
}
