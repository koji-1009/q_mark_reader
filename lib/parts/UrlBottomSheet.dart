import 'package:flutter/material.dart';

class UrlBottomSheet extends StatefulWidget {
  @override
  _UrlBottomSheetState createState() => _UrlBottomSheetState();
}

class _UrlBottomSheetState extends State<UrlBottomSheet> {
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);

    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.only(
              top: 4,
              left: 8,
              right: 8,
              bottom: MediaQuery.of(context).viewInsets.bottom + 4),
          child: TextField(
            focusNode: _focusNode,
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              labelText: "URL",
            ),
            onSubmitted: (value) => {Navigator.of(context).pop(value)},
          )),
    );
  }
}
