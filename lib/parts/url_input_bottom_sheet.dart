import 'package:disposable_provider/disposable_provider.dart';
import 'package:flutter/material.dart';
import 'package:q_mark_reader/bloc/url_entry_bloc.dart';

class UrlBottomSheet extends StatelessWidget {
  const UrlBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = DisposableProvider.of<UrlEntryBloc>(context);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
            top: 4,
            left: 8,
            right: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 4),
        child: TextField(
            autofocus: true,
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              labelText: "URL",
            ),
            onSubmitted: (value) {
              bloc.url.add(value);
              Navigator.pop(context);
            }),
      ),
    );
  }
}
