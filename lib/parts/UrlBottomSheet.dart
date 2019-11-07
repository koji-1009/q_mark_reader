import 'package:flutter/material.dart';

class UrlBottomSheet extends StatefulWidget {
  @override
  _UrlBottomSheetState createState() => _UrlBottomSheetState();
}

class _UrlBottomSheetState extends State<UrlBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.only(
              top: 4,
              left: 8,
              right: 8,
              bottom: MediaQuery.of(context).viewInsets.bottom + 4),
          child: TextField(
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              labelText: "URL",
            ),
            onSubmitted: (value) => {Navigator.of(context).pop(value)},
          )),
    );
  }
}
