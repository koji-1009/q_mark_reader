import 'package:flutter/material.dart';
import 'package:q_mark_reader/bloc/BookmarkBloc.dart';
import 'package:q_mark_reader/bloc/UrlEntryBloc.dart';
import 'package:q_mark_reader/db/UrlEntryHelper.dart';
import 'package:q_mark_reader/entity/UrlBookmark.dart';
import 'package:q_mark_reader/parts/BookmarkWidget.dart';
import 'package:q_mark_reader/parts/UrlEntryBottomSheet.dart';
import 'package:q_mark_reader/parts/UrlInputBottomSheet.dart';

void main() {
  return runApp(App(
    bookmarkBloc: BookmarkBloc(),
    urlEntryBloc: UrlEntryBloc(),
  ));
}

class App extends StatelessWidget {
  final BookmarkBloc bookmarkBloc;
  final UrlEntryBloc urlEntryBloc;

  const App({@required this.bookmarkBloc, @required this.urlEntryBloc});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Q mark reader',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      home: HomePage(
        bookmarkBloc: bookmarkBloc,
        urlEntryBloc: urlEntryBloc,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final BookmarkBloc bookmarkBloc;
  final UrlEntryBloc urlEntryBloc;

  const HomePage({@required this.bookmarkBloc, @required this.urlEntryBloc});

  void _addUrl(String url) {
    if (url == null ||
        url.isEmpty ||
        !Uri.parse(url).isAbsolute) {
      return;
    }

    urlEntryBloc.url.add(url);
    bookmarkBloc.url.add(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: StreamBuilder<BookmarkResponse>(
          stream: bookmarkBloc.response,
          initialData: null,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Sorry, somthing wrong!");
            }

            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Text("Please Input new URL");
                break;
              case ConnectionState.active:
                if (snapshot.hasData) {
                  return BookmarkWidget(response: snapshot.data);
                } else {
                  return const CircularProgressIndicator();
                }
                break;
              case ConnectionState.done:
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final url = await showModalBottomSheet<String>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              builder: (context) => UrlBottomSheet());

          _addUrl(url);
        },
        tooltip: 'serch',
        child: Icon(Icons.search),
        elevation: 2.0,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              StreamBuilder<List<UrlEntry>>(
                  stream: urlEntryBloc.entryList,
                  initialData: [],
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active &&
                        snapshot.hasData &&
                        snapshot.data.isNotEmpty) {
                      return IconButton(
                          icon: Icon(Icons.list),
                          onPressed: () async {
                            final url = await showModalBottomSheet<String>(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                builder: (context) =>
                                    UrlEntryBottomSheet(snapshot.data));

                            if (url == null ||
                                url.isEmpty ||
                                !Uri.parse(url).isAbsolute) {
                              return;
                            }

                            _addUrl(url);
                          });
                    }

                    return const Spacer();
                  })
            ]),
      ),
    );
  }
}
