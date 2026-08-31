import 'package:floor/floor.dart';

@entity
class RssItem {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String sourceId;
  final String sourceTitle;
  final String title;
  final String? description;
  final String? content;
  final String link;
  final String? pubDate;
  final String? imageUrl;
  final String? category;
  final String? author;
  final bool isFavorite;
  final bool isRead;
  final int createdAt;

  RssItem({
    this.id,
    required this.sourceId,
    required this.sourceTitle,
    required this.title,
    this.description,
    this.content,
    required this.link,
    this.pubDate,
    this.imageUrl,
    this.category,
    this.author,
    this.isFavorite = false,
    this.isRead = false,
    int? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  RssItem copyWith({
    int? id,
    String? sourceId,
    String? sourceTitle,
    String? title,
    String? description,
    String? content,
    String? link,
    String? pubDate,
    String? imageUrl,
    String? category,
    String? author,
    bool? isFavorite,
    bool? isRead,
    int? createdAt,
  }) {
    return RssItem(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      sourceTitle: sourceTitle ?? this.sourceTitle,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      link: link ?? this.link,
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
    return 'RssItem(id: $id, sourceId: $sourceId, title: $title, link: $link, isFavorite: $isFavorite, isRead: $isRead)';
  }
}
