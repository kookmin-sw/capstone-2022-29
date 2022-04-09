import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  NewsPage({Key? key, this.query}) : super(key: key);
  String? query;

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text('${widget.query} News'),
        ),
      ),
    );
  }
}
