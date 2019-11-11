import 'package:disposable_provider/disposable_provider.dart';
import 'package:flutter/material.dart';
import 'package:q_mark_reader/bloc/url_entry_bloc.dart';
import 'package:q_mark_reader/db/url_entry_helper.dart';
import 'package:q_mark_reader/parts/url_entry_bottom_sheet.dart';

class BookmarkListIconButton extends StatelessWidget {
  const BookmarkListIconButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = DisposableProvider.of<UrlEntryBloc>(context);

    return StreamBuilder<List<UrlEntry>>(
        stream: bloc.entryList,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData &&
              snapshot.data.isNotEmpty) {
            return IconButton(
                icon: const Icon(Icons.list),
                tooltip: "show a list of searched URLs",
                onPressed: () async {
                  await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => DisposableProvider.value(
                          value: bloc, child: const UrlEntryBottomSheet()));
                });
          }

          return const Spacer();
        });
  }
}
