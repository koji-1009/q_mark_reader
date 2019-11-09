import 'package:flutter/material.dart';
import 'package:q_mark_reader/bloc/HatenaBookmarkBloc.dart';
import 'package:q_mark_reader/entity/UrlBookmark.dart';
import 'package:q_mark_reader/parts/UrlBottomSheet.dart';

void main() => runApp(App(bloc: HatenaBookmarkBloc()));

class App extends StatelessWidget {
  final HatenaBookmarkBloc bloc;

  const App({@required this.bloc});

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
        bloc: bloc,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final HatenaBookmarkBloc bloc;

  const HomePage({@required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: StreamBuilder<BookmarkResponse>(
              stream: bloc.response,
              initialData: null,
              builder: (context, snapShot) =>
                  Text(snapShot.hasData ? snapShot.data.count.toString() : "未選択")),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final url = await showModalBottomSheet<String>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                builder: (context) => UrlBottomSheet());

            bloc.url.add(url);
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
              IconButton(
                icon: Icon(Icons.list),
                onPressed: () {},
              ),
            ],
          ),
        ));
  }
}
