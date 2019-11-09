import 'package:flutter/material.dart';
import 'package:q_mark_reader/entity/UrlBookmark.dart';

class BookmarkWidget extends StatelessWidget {
  final BookmarkResponse response;

  BookmarkWidget({this.response});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Image.network(response.screenshot),
      ],
    );
  }
}
