import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:q_mark_reader/entity/UrlBookmark.dart';
import 'package:rxdart/rxdart.dart';

class BookmarkBloc {
  final _urlController = PublishSubject<String>();
  final _responseController = BehaviorSubject<BookmarkResponse>();

  Sink<String> get url => _urlController.sink;

  ValueObservable<BookmarkResponse> get response => _responseController;

  BookmarkBloc() {
    _urlController.stream.listen(_handle);
  }

  void _handle(String url) {
    _request(url).then((response) => _responseController.add(response));
  }

  Future<BookmarkResponse> _request(String url) async {
    if (!Uri.parse(url).isAbsolute) {
      throw("url is not absolute");
    }

    final requestUrl = 'https://b.hatena.ne.jp/entry/jsonlite/' + url;
    final response = await http.get(requestUrl);

    final code = response.statusCode;
    if (code < 200 || code >= 300) {
      throw HttpException("code < 200 or >= 300: " + code.toString());
    }

    final json = jsonDecode(response.body);
    final bookmarkResponse = BookmarkResponse.fromJson(json);

    return bookmarkResponse;
  }

  void dispose() async {
    await _urlController.close();
    await _responseController.close();
  }
}
