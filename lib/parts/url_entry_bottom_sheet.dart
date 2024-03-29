import 'package:disposable_provider/disposable_provider.dart';
import 'package:flutter/material.dart';
import 'package:q_mark_reader/bloc/url_entry_bloc.dart';
import 'package:q_mark_reader/db/url_entry_helper.dart';

class UrlEntryBottomSheet extends StatelessWidget {
  const UrlEntryBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = DisposableProvider.of<UrlEntryBloc>(context);

    return StreamBuilder<List<UrlEntry>>(
        stream: bloc.entryList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("error");
          }

          final list = snapshot.data;
          return Container(
            height: 200,
            child: ListView.builder(
              itemBuilder: (context, index) {
                final entry = list[index];
                return Dismissible(
                  key: ValueKey(entry.url),
                  background: Container(color: Theme.of(context).errorColor),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    if (direction != DismissDirection.endToStart) {
                      return;
                    }

                    bloc.deleteUrl.add(entry.url);
                  },
                  child: ListTile(
                    title: Text(entry.url),
                    onTap: () {
                      bloc.url.add(entry.url);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
              itemCount: list.length,
            ),
          );
        });
  }
}
