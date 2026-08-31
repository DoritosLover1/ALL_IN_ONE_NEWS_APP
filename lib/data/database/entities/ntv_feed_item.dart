import 'package:floor/floor.dart';

@entity
class NtvFeedItem {
  @primaryKey
  final String link;

  final String title;
  final String? spot;
  final String? description;
  final String? content;
  final String? pubDate;
  final String? imageUrl;
  final String? category;
  final bool isFavorite;
  final bool isRead;
  final int createdAt;

  NtvFeedItem({
    required this.link,
    required this.title,
    this.spot,
    this.description,
    this.content,
    this.pubDate,
    this.imageUrl,
    this.category,
    this.isFavorite = false,
    this.isRead = false,
    int? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  NtvFeedItem copyWith({
    String? link,
    String? title,
    String? spot,
    String? description,
    String? content,
    String? pubDate,
    String? imageUrl,
    String? category,
    bool? isFavorite,
    bool? isRead,
    int? createdAt,
  }) {
    return NtvFeedItem(
      link: link ?? this.link,
      title: title ?? this.title,
      spot: spot ?? this.spot,
      description: description ?? this.description,
      content: content ?? this.content,
      pubDate: pubDate ?? this.pubDate,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'NtvFeedItem(link: $link, title: $title, category: $category, isFavorite: $isFavorite, isRead: $isRead)';
  }
}
