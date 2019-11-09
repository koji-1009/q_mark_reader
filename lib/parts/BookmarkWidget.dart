import 'package:flutter/material.dart';
import 'package:q_mark_reader/entity/UrlBookmark.dart';
import 'package:url_launcher/url_launcher.dart';

class BookmarkWidget extends StatelessWidget {
  final BookmarkResponse response;

  BookmarkWidget({this.response});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Image.network(response.screenshot),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                response.url,
                style: Theme
                    .of(context)
                    .textTheme
                    .title,
              ),
            ),
            FlatButton(
              child: const Icon(Icons.link),
              onPressed: () async {
                _launchURL(response.entry_url);
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Bookmark count : " + response.count.toString(),
              style: Theme
                  .of(context)
                  .textTheme
                  .body1),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              var comment = "no comment";
              if (response.bookmarks[index].comment.isNotEmpty) {
                comment = response.bookmarks[index].comment;
              }
              return Card(
                  child: ListTile(
                    title: Text(comment),
                    subtitle: Text(response.bookmarks[index].tags.toString()),
                  ));
            },
            itemCount: response.bookmarks.length,
            shrinkWrap: true,
          ),
        ),
      ],
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
