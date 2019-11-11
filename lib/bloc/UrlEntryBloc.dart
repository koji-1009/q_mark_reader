import 'package:q_mark_reader/db/UrlEntryHelper.dart';
import 'package:rxdart/rxdart.dart';

class UrlEntryBloc {
  final helper = UrlEntryHelper();

  final _urlController = PublishSubject<String>();
  final _entryController = BehaviorSubject<List<UrlEntry>>();

  Sink<String> get url => _urlController.sink;

  ValueObservable<List<UrlEntry>> get entryList => _entryController;

  UrlEntryBloc() {
    updateEntryController();

    _urlController.stream.listen(_handle);
  }

  void _handle(String url) async {
    if (!Uri.parse(url).isAbsolute) {
      return;
    }

    await helper.insert(url);

    updateEntryController();
  }

  void updateEntryController() async {
    final list = await helper.getUrlEntryList();

    _entryController.add(list);
  }

  void dispose() async {
    await _urlController.close();
    await _entryController.close();
  }
}
