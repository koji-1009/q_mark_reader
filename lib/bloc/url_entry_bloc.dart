import 'dart:convert';

import 'package:disposable_provider/disposable_provider.dart';
import 'package:http/http.dart' as http;
import 'package:q_mark_reader/db/url_entry_helper.dart';
import 'package:q_mark_reader/entity/network_status.dart';
import 'package:q_mark_reader/entity/url_bookmark.dart';
import 'package:rxdart/rxdart.dart';

class UrlEntryBloc extends Disposable {
  @override
  void dispose() async {
    await _helper.close();

    await _urlController.close();
    await _entryController.close();
    await _fetchStatusController.close();
    await _responseController.close();
  }

  final _helper = UrlEntryHelper();

  final _urlController = PublishSubject<String>();
  final _entryController = BehaviorSubject<List<UrlEntry>>();
  final _fetchStatusController = BehaviorSubject<NetworkStatus>();
  final _responseController = BehaviorSubject<BookmarkResponse>();

  Sink<String> get url => _urlController.sink;

  ValueObservable<List<UrlEntry>> get entryList => _entryController;

  ValueObservable<NetworkStatus> get status => _fetchStatusController;

  ValueObservable<BookmarkResponse> get response => _responseController;

  UrlEntryBloc() {
    _updateEntryController();

    _urlController.stream.where(_isValidUrl).listen(_handle);
    _fetchStatusController.add(NetworkStatus.NONE);
  }

  bool _isValidUrl(String url) =>
      url != null && url.isNotEmpty && Uri.parse(url).isAbsolute;

  void _handle(String url) async {
    await _helper.insert(url);
    await _updateEntryController();
    await _request(url);
  }

  Future<void> _updateEntryController() async {
    final list = await _helper.getUrlEntryList();
    _entryController.add(list);
  }

  Future<void> _request(String url) async {
    _fetchStatusController.add(NetworkStatus.LOADING);

    final requestUrl = 'https://b.hatena.ne.jp/entry/jsonlite/' + url;
    final response = await http.get(requestUrl);

    final code = response.statusCode;
    if (code < 200 || code >= 300) {
      _fetchStatusController.add(NetworkStatus.ERROR);
      return;
    }

    final json = jsonDecode(response.body);
    final bookmarkResponse = BookmarkResponse.fromJson(json);

    _responseController.add(bookmarkResponse);
    _fetchStatusController.add(NetworkStatus.SUCCESS);
  }
}
