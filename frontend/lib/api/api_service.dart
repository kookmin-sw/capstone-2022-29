// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:frontend/models/user_model.dart';
import 'package:frontend/models/news_model.dart';
import 'package:frontend/models/bookmark_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService _apiService = ApiService._init();
  // static const API_URL = 'http://127.0.0.1:9000/';

  factory ApiService() {
    return _apiService;
  }

  ApiService._init();

  // post user info
  Future<http.Response> postUserInfo(User user) async {
    final url = Uri.http("127.0.0.1:9000", "users");
    http.Response response = await http.post(
      url,
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 200) {
      print(response.body);
    }
    return response;
  }

  // get user info
  Future<dynamic> getUserInfo(dynamic accessToken) async {
    final queryParameters = {
      'accessToken': accessToken,
    };
    final url = Uri.http("127.0.0.1:9000", "users", queryParameters);
    http.Response response = await http.get(url, headers: {
      "Content-type": "application/json",
    });
    if (response.statusCode == 200) {
      print(response.body);
    }
    var decodedData = jsonDecode(response.body);
    for (dynamic u in decodedData) {
      return u;
      // user.add(User.fromJson(u));
    }
  }

  // find user with nickname -> access_token update를 위함
  Future<dynamic> findUser(dynamic nickname) async {
    final queryParameters = {
      'nickname': nickname,
    };
    final url = Uri.http("127.0.0.1:9000", "users/find", queryParameters);
    http.Response response = await http.get(url, headers: {
      "Content-type": "application/json",
    });
    if (response.statusCode == 200) {
      print(response.body);
    }
    var decodedData = jsonDecode(response.body);
    for (dynamic u in decodedData) {
      return u;
      // user.add(User.fromJson(u));
    }
  }

  // update user access_token
  Future<dynamic> updateUserInfo(dynamic nickname, User user) async {
    final queryParameters = {
      'nickname': nickname,
    };
    final url = Uri.http("127.0.0.1:9000", "users", queryParameters);
    http.Response response = await http.put(
      url,
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 200) {
      print(response.body);
    }
    return response;
  }

  // post news
  // Future<http.Response> postNews(News news) async {
  //   final url = Uri.http("127.0.0.1:9000", "news");
  //   http.Response response = await http.post(
  //     url,
  //     body: jsonEncode(news.toJson()),
  //     headers: {
  //       "Content-type": "application/json",
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //   }
  //   return response;
  // }

  // get news info with query
  Future<dynamic> getNews(dynamic query) async {
    List<dynamic> news = [];
    final queryParameters = {
      'query': query,
    };
    final url = Uri.http("127.0.0.1:9000", "news", queryParameters);
    http.Response response = await http.get(url, headers: {
      "Content-type": "application/json",
    });
    if (response.statusCode == 200) {
      print(response.body);
    }
    var decodedData = jsonDecode(response.body);
    for (dynamic n in decodedData) {
      news.add(n);
    }
    return news;
  }

  // post bookmark (user_id, query, count)
  Future<http.Response> postBookmark(Bookmark bookmark) async {
    final url = Uri.http("127.0.0.1:9000", "bookmarks");
    http.Response response = await http.post(
      url,
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(bookmark.toJson()),
    );
    if (response.statusCode == 200) {
      print(response.body);
    }
    return response;
  }

  // find bookmark query with user_id
  Future<dynamic> getBookmark(dynamic user_id) async {
    List<dynamic> bookmark = [];
    final queryParameters = {
      'user_id': user_id,
    };
    final url = Uri.http("127.0.0.1:9000", "bookmarks", queryParameters);
    http.Response response = await http.get(url, headers: {
      "Content-type": "application/json",
    });
    if (response.statusCode == 200) {
      print(response.body);
    }
    var decodedData = jsonDecode(response.body);
    for (dynamic b in decodedData) {
      bookmark.add(b);
    }
    return bookmark;
  }

  // update bookmark count of query
  Future<dynamic> updateBookmark(
      dynamic user_id, dynamic query, Bookmark bookmark) async {
    final queryParameters = {
      'user_id': user_id,
      'query': query,
    };
    final url = Uri.http("127.0.0.1:9000", "bookmarks", queryParameters);
    http.Response response = await http.put(
      url,
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(bookmark.toJson()),
    );
    if (response.statusCode == 200) {
      print(response.body);
    }
    return response;
  }
}
