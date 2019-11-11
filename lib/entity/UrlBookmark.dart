import 'package:json_annotation/json_annotation.dart';

part 'UrlBookmark.g.dart';

enum NetworkStatus {
  LOADING,
  SUCCESS,
  ERROR
}

class UrlFetchState {
  final status;
  final response;

  UrlFetchState(this.status, this.response);
}

@JsonSerializable()
class BookmarkResponse {
  BookmarkResponse(this.eid, this.title, this.screenshot, this.requested_url,
      this.entry_url, this.count, this.url, this.bookmarks);

  final String eid;
  final String title;
  final String screenshot;
  final String requested_url;
  final String entry_url;
  final int count;
  final String url;
  final List<Bookmark> bookmarks;

  factory BookmarkResponse.fromJson(Map<String, dynamic> json) =>
      _$BookmarkResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BookmarkResponseToJson(this);
}

@JsonSerializable()
class Bookmark {
  Bookmark(this.comment, this.timestamp, this.user, this.tags);

  final String comment;
  final String timestamp; // 2019/10/01 01:00
  final String user;

  final List<String> tags;

  factory Bookmark.fromJson(Map<String, dynamic> json) =>
      _$BookmarkFromJson(json);

  Map<String, dynamic> toJson() => _$BookmarkToJson(this);
}
