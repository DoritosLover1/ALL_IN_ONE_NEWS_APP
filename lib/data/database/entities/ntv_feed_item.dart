import 'package:floor/floor.dart';

@entity
class NtvFeedItem {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String title;
  final String? spot;
  final String? description;
  final String? content;
  final String link;
  final String? pubDate;
  final String? imageUrl;
  final String? category;
  final bool isFavorite;
  final bool isRead;
  final int createdAt;

  NtvFeedItem({
    this.id,
    required this.title,
    this.spot,
    this.description,
    this.content,
    required this.link,
    this.pubDate,
    this.imageUrl,
    this.category,
    this.isFavorite = false,
    this.isRead = false,
    int? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  NtvFeedItem copyWith({
    int? id,
    String? title,
    String? spot,
    String? description,
    String? content,
    String? link,
    String? pubDate,
    String? imageUrl,
    String? category,
    bool? isFavorite,
    bool? isRead,
    int? createdAt,
  }) {
    return NtvFeedItem(
      id: id ?? this.id,
      title: title ?? this.title,
      spot: spot ?? this.spot,
      description: description ?? this.description,
      content: content ?? this.content,
      link: link ?? this.link,
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
    return 'NtvFeedItem(id: $id, title: $title, category: $category, link: $link, isFavorite: $isFavorite, isRead: $isRead)';
  }
}
