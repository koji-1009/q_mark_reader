import 'package:cached_network_image/cached_network_image.dart';
import 'package:disposable_provider/disposable_provider.dart';
import 'package:flutter/material.dart';
import 'package:q_mark_reader/bloc/url_entry_bloc.dart';
import 'package:q_mark_reader/entity/url_bookmark.dart';
import 'package:url_launcher/url_launcher.dart';

class BookmarkWidget extends StatelessWidget {
  const BookmarkWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = DisposableProvider.of<UrlEntryBloc>(context);

    return StreamBuilder<BookmarkResponse>(
        stream: bloc.response,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final response = snapshot.data;
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
                    fit: FlexFit.tight,
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
                    final bookmark = response.bookmarks[index];
                    return Card(
                        child: ListTile(
                      title: Text(bookmark.user),
                      subtitle: Text(bookmark.comment),
                    ));
                  },
                  itemCount: response.bookmarks.length,
                  shrinkWrap: true,
                ),
              ),
            ],
          );
        });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
