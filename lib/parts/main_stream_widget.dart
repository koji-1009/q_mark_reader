import 'package:disposable_provider/disposable_provider.dart';
import 'package:flutter/material.dart';
import 'package:q_mark_reader/bloc/url_entry_bloc.dart';
import 'package:q_mark_reader/entity/network_status.dart';

import 'bookmark_widget.dart';

class MainStream extends StatelessWidget {
  const MainStream({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = DisposableProvider.of<UrlEntryBloc>(context);

    return StreamBuilder<NetworkStatus>(
      stream: bloc.status,
      initialData: NetworkStatus.NONE,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Sorry, somthing wrong!");
        }

        switch (snapshot.data) {
          case NetworkStatus.NONE:
            return const Center(child: Text("Please Input new URL"));
          case NetworkStatus.SUCCESS:
            return DisposableProvider.value(
                value: bloc, child: const BookmarkWidget());
          case NetworkStatus.ERROR:
            return const Text("Sorry, somthing wrong!");
          case NetworkStatus.LOADING:
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
