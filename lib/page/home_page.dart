import 'package:disposable_provider/disposable_provider.dart';
import 'package:flutter/material.dart';
import 'package:q_mark_reader/bloc/url_entry_bloc.dart';
import 'package:q_mark_reader/parts/bookmark_list_icon_button.dart';
import 'package:q_mark_reader/parts/bookmark_search_icon_button.dart';
import 'package:q_mark_reader/parts/main_stream_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => DisposableProvider(
        builder: (context) => UrlEntryBloc(),
        child: Scaffold(
          body: SafeArea(child: const MainStream()),
          bottomNavigationBar: BottomAppBar(
            elevation: 2,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  BookmarkListIconButton(),
                  BookmarkSearchIconButton()
                ]),
          ),
        ),
      );
}
