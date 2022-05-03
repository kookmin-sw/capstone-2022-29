// ignore_for_file: constant_identifier_names, avoid_print, non_constant_identifier_names

import 'dart:convert';

import 'package:frontend/models/user_model.dart';
import 'package:frontend/models/news_model.dart';
import 'package:frontend/models/bubble_model.dart';
import 'package:frontend/models/topic_model.dart';
import 'package:frontend/models/bookmark_model.dart';
import 'package:frontend/models/keyword_model.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService _apiService = ApiService._init();
  final String _apiURI = dotenv.get('API_URI');

  factory ApiService() {
    return _apiService;
  }

  ApiService._init();

  // post user info
  Future<http.Response> postUserInfo(User user) async {
    final url = Uri.http(_apiURI, "users");
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

  // get user with nickname -> access_token update를 위함
  Future<dynamic> getUserInfo(dynamic nickname) async {
    final queryParameters = {
      'nickname': nickname,
    };
    final url = Uri.http(_apiURI, "users", queryParameters);
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
    final url = Uri.http(_apiURI, "users", queryParameters);
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
  Future<http.Response> postNews(News news) async {
    final url = Uri.http(_apiURI, "news");
    http.Response response = await http.post(
      url,
      body: jsonEncode(news.toJson()),
      headers: {
        "Content-type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
    }
    return response;
  }

  // get news with query
  Future<dynamic> getNews(dynamic query) async {
    List<dynamic> news = [];
    final queryParameters = {
      'query': query,
    };
    final url = Uri.http(_apiURI, "news", queryParameters);
    http.Response response = await http.get(url, headers: {
      "Content-type": "application/json",
    });
    if (response.statusCode == 200) {
      // print(response.body);
    }
    var decodedData = jsonDecode(response.body);
    for (dynamic n in decodedData) {
      news.add(n);
    }
    return news;
  }

  // post bubble
  Future<http.Response> postBubble(Bubble bubble) async {
    final url = Uri.http(_apiURI, "bubbles");
    http.Response response = await http.post(
      url,
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(bubble.toJson()),
    );
    if (response.statusCode == 200) {
      print(response.body);
    }
    return response;
  }

  // get bubble with user_id
  Future<dynamic> getBubbleUserId(dynamic user_id) async {
    List<dynamic> bubble = [];
    final queryParameters = {
      'user_id': user_id,
    };
    final url = Uri.http(_apiURI, "bubbles", queryParameters);
    http.Response response = await http.get(url, headers: {
      "Content-type": "application/json",
    });
    if (response.statusCode == 200) {
      print(response.body);
    }
    var decodedData = jsonDecode(response.body);
    for (dynamic b in decodedData) {
      // return b;
      bubble.add(b);
    }
    return bubble;
  }

  // get bubble with query
  Future<dynamic> getBubbleQuery(dynamic query) async {
    List<dynamic> bubble = [];
    final queryParameters = {
      'query': query,
    };
    final url = Uri.http(_apiURI, "bubbles", queryParameters);
    http.Response response = await http.get(url, headers: {
      "Content-type": "application/json",
    });
    if (response.statusCode == 200) {
      print(response.body);
    }
    var decodedData = jsonDecode(response.body);
    for (dynamic b in decodedData) {
      // return b;
      bubble.add(b);
    }
    return bubble;
  }

  // get bubble with user_id & query
  Future<dynamic> getBubble(dynamic user_id, dynamic query) async {
    List<dynamic> bubble = [];
    final queryParameters = {
      'user_id': user_id,
      'query': query,
    };
    final url = Uri.http(_apiURI, "bubbles", queryParameters);
    http.Response response = await http.get(url, headers: {
      "Content-type": "application/json",
    });
    if (response.statusCode == 200) {
      print(response.body);
    }
    var decodedData = jsonDecode(response.body);
    for (dynamic b in decodedData) {
      // return b;
      bubble.add(b);
    }
    return bubble;
  }

  // update bubble with user_id -> bubble 추가
  Future<dynamic> updateNewBubble(dynamic user_id, Bubble bubble) async {
    final queryParameters = {
      'user_id': user_id,
    };
    final url = Uri.http(_apiURI, "bubbles", queryParameters);
    http.Response response = await http.put(
      url,
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(bubble.toJson()),
    );
    if (response.statusCode == 200) {
      print(response.body);
    }
    return response;
  }

  // update bubble with user_id & query -> count+1
  Future<dynamic> updateBubbleCount(
      dynamic user_id, dynamic query, Bubble bubble) async {
    final queryParameters = {
      'user_id': user_id,
      'query': query,
    };
    final url = Uri.http(_apiURI, "bubbles", queryParameters);
    http.Response response = await http.put(
      url,
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(bubble.toJson()),
    );
    if (response.statusCode == 200) {
      print(response.body);
    }
    return response;
  }

  // post topic
  Future<http.Response> postTopic(Topic topic) async {
    final url = Uri.http(_apiURI, "topics");
    http.Response response = await http.post(
      url,
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(topic.toJson()),
    );
    if (response.statusCode == 200) {
      print(response.body);
    }
    return response;
  }

  // get topic with query & topicNum
  Future<dynamic> getTopic(dynamic query, dynamic topicNum) async {
    List<dynamic> topic = [];
    final queryParameters = {
      'query': query,
      'topicNum': topicNum,
    };
    final url = Uri.http(_apiURI, "topics", queryParameters);
    http.Response response = await http.get(url, headers: {
      "Content-type": "application/json",
    });
    if (response.statusCode == 200) {
      print(response.body);
    }
    var decodedData = jsonDecode(response.body);
    for (dynamic t in decodedData) {
      // return u;
      topic.add(t);
    }
    return topic;
  }

  // post bookmark
  Future<http.Response> postBookmark(Bookmark bookmark) async {
    final url = Uri.http(_apiURI, "bookmarks");
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

  // get bookmark with user_id
  Future<dynamic> getBookmark(dynamic user_id) async {
    List<dynamic> bookmark = [];
    final queryParameters = {
      'user_id': user_id,
    };
    final url = Uri.http(_apiURI, "bookmarks", queryParameters);
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

  // update bookmark with user_id -> bookmark 추가
  Future<dynamic> updateBookmark(dynamic user_id, Bookmark bookmark) async {
    final queryParameters = {
      'user_id': user_id,
    };
    final url = Uri.http(_apiURI, "bookmarks", queryParameters);
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

  // update bookmark with user_id & news_id -> bookmark 삭제
  Future<dynamic> deleteBookmark(
      dynamic user_id, dynamic news_id, Bookmark bookmark) async {
    final queryParameters = {
      'user_id': user_id,
      'news_id': news_id,
    };
    final url = Uri.http(_apiURI, "bookmarks", queryParameters);
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

  // post keyword
  Future<http.Response> postKeyword(Keyword keyword) async {
    final url = Uri.http(_apiURI, "keywords");
    http.Response response = await http.post(
      url,
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(keyword.toJson()),
    );
    if (response.statusCode == 200) {
      print(response.body);
    }
    return response;
  }

  // get keyword with user_id
  Future<dynamic> getKeyword(dynamic user_id) async {
    List<dynamic> keyword = [];
    final queryParameters = {
      'user_id': user_id,
    };
    final url = Uri.http(_apiURI, "keywords", queryParameters);
    http.Response response = await http.get(url, headers: {
      "Content-type": "application/json",
    });
    if (response.statusCode == 200) {
      print(response.body);
    }
    var decodedData = jsonDecode(response.body);
    for (dynamic k in decodedData) {
      keyword.add(k);
    }
    return keyword;
  }

  // update keyword with user_id -> keyword 추가
  Future<dynamic> updateKeyword(dynamic user_id, Keyword keyword) async {
    final queryParameters = {
      'user_id': user_id,
      'keyword': keyword,
    };
    final url = Uri.http(_apiURI, "keywords", queryParameters);
    http.Response response = await http.put(
      url,
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(keyword.toJson()),
    );
    if (response.statusCode == 200) {
      print(response.body);
    }
    return response;
  }

  // update keyword with user_id & keyword -> keyword 삭제
  Future<dynamic> deleteKeyword(
      dynamic user_id, dynamic keywords, Keyword keyword) async {
    final queryParameters = {
      'user_id': user_id,
      'keyword': keywords,
    };
    final url = Uri.http(_apiURI, "keywords", queryParameters);
    http.Response response = await http.put(
      url,
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(keyword.toJson()),
    );
    if (response.statusCode == 200) {
      print(response.body);
    }
    return response;
  }
}
