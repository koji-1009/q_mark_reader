import 'package:cached_network_image/cached_network_image.dart';
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
        Center(
          child: CachedNetworkImage(
            placeholder: (context, url) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: const CircularProgressIndicator(),
            ),
            errorWidget: (context, str, obj) => const Text("sorry error"),
            imageUrl: response.screenshot,
          ),
        ),
        Row(
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  response.url,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.link),
                tooltip: "Hatena Link",
                onPressed: () async {
                  _launchURL(response.entry_url);
                },
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.bookmark,
                color: Colors.blue,
              ),
              Text(response.count.toString()),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              var comment = "-";
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
