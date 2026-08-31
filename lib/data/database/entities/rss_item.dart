import 'package:floor/floor.dart';

@entity
class RssItem {
  @primaryKey
  final String link;

  final String sourceId;
  final String sourceTitle;
  final String title;
  final String? description;
  final String? content;
  final String? pubDate;
  final String? imageUrl;
  final String? category;
  final String? author;
  final bool isFavorite;
  final bool isRead;
  final int createdAt;

  RssItem({
    required this.link,
    required this.sourceId,
    required this.sourceTitle,
    required this.title,
    this.description,
    this.content,
    this.pubDate,
    this.imageUrl,
    this.category,
    this.author,
    this.isFavorite = false,
    this.isRead = false,
    int? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  RssItem copyWith({
    String? link,
    String? sourceId,
    String? sourceTitle,
    String? title,
    String? description,
    String? content,
    String? pubDate,
    String? imageUrl,
    String? category,
    String? author,
    bool? isFavorite,
    bool? isRead,
    int? createdAt,
  }) {
    return RssItem(
      link: link ?? this.link,
      sourceId: sourceId ?? this.sourceId,
      sourceTitle: sourceTitle ?? this.sourceTitle,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      pubDate: pubDate ?? this.pubDate,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      author: author ?? this.author,
      isFavorite: isFavorite ?? this.isFavorite,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'RssItem(link: $link, sourceId: $sourceId, title: $title, isFavorite: $isFavorite, isRead: $isRead)';
  }
}
