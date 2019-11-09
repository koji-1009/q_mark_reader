// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UrlBookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookmarkResponse _$BookmarkResponseFromJson(Map<String, dynamic> json) {
  return BookmarkResponse(
    json['eid'] as String,
    json['title'] as String,
    json['screenshot'] as String,
    json['requested_url'] as String,
    json['entry_url'] as String,
    json['count'] as int,
    json['url'] as String,
    (json['bookmarks'] as List)
        ?.map((e) =>
            e == null ? null : Bookmark.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$BookmarkResponseToJson(BookmarkResponse instance) =>
    <String, dynamic>{
      'eid': instance.eid,
      'title': instance.title,
      'screenshot': instance.screenshot,
      'requested_url': instance.requested_url,
      'entry_url': instance.entry_url,
      'count': instance.count,
      'url': instance.url,
      'bookmarks': instance.bookmarks,
    };

Bookmark _$BookmarkFromJson(Map<String, dynamic> json) {
  return Bookmark(
    json['comment'] as String,
    json['timestamp'] as String,
    json['user'] as String,
    (json['tags'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$BookmarkToJson(Bookmark instance) => <String, dynamic>{
      'comment': instance.comment,
      'timestamp': instance.timestamp,
      'user': instance.user,
      'tags': instance.tags,
    };
