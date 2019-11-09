import 'package:flutter/material.dart';
import 'package:q_mark_reader/bloc/HatenaBookmarkBloc.dart';
import 'package:q_mark_reader/entity/UrlBookmark.dart';
import 'package:q_mark_reader/parts/BookmarkWidget.dart';
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
            child: Center(
          child: StreamBuilder<BookmarkResponse>(
            stream: bloc.response,
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
