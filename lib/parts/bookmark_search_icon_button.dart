import 'package:disposable_provider/disposable_provider.dart';
import 'package:flutter/material.dart';
import 'package:q_mark_reader/bloc/url_entry_bloc.dart';
import 'package:q_mark_reader/parts/url_input_bottom_sheet.dart';

class BookmarkSearchIconButton extends StatelessWidget {
  const BookmarkSearchIconButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = DisposableProvider.of<UrlEntryBloc>(context);

    return IconButton(
      icon: const Icon(Icons.search),
      tooltip: 'search new url',
      onPressed: () async {
        await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => DisposableProvider.value(
                value: bloc, child: const UrlBottomSheet()));
      },
    );
  }
}
