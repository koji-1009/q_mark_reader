import 'package:flutter/material.dart';
import 'package:q_mark_reader/db/UrlEntryHelper.dart';

class UrlEntryBottomSheet extends StatelessWidget {
  final List<UrlEntry> _UrlList;

  UrlEntryBottomSheet(this._UrlList);

  @override
  Widget build(BuildContext context) {
    var count;
    if (_UrlList.isEmpty) {
      count = 1;
    } else {
      count = _UrlList.length;
    }
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (_UrlList.isEmpty) {
            return const Text("no entries");
          }

          final entry = _UrlList[index];
          return ListTile(
            title: Text(entry.url),
            onTap: () {
              Navigator.of(context).pop(entry.url);
            },
          );
        },
        itemCount: count,
      ),
    );
  }
}
