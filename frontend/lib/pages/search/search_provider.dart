import 'package:flutter/cupertino.dart';

class SearchProvider extends ChangeNotifier{
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  onChange(value) {
    _searchQuery = value;
    notifyListeners();
  }
}