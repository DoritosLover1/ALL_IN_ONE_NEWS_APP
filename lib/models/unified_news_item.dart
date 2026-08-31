import 'package:flutter/material.dart';
import 'package:flutter_medic/constants/news_sources.dart';
import 'package:flutter_medic/data/database/entities/ntv_feed_item.dart';
import 'package:flutter_medic/data/database/entities/rss_item.dart';
import 'package:flutter_medic/services/parsers/base_news_parser.dart';

class UnifiedNewsItem {
  final int? id;
  final String sourceId;
  final String sourceTitle;
  final String sourceBadgeText;
  final Color sourceBadgeColor;
  final String title;
  final String? spot;
  final String? description;
  final String? content;
  final String link;
  final String? imageUrl;
  final String? pubDate;
  final String category;
  final String readCount;
  final String timeAgo;
  final bool isBreaking;
  final bool isFavorite;
  final bool isRead;
  final bool isNtvFeed;
  final int createdAt;

  UnifiedNewsItem({
    this.id,
    required this.sourceId,
    required this.sourceTitle,
    required this.sourceBadgeText,
    required this.sourceBadgeColor,
    required this.title,
    this.spot,
    this.description,
    this.content,
    required this.link,
    this.imageUrl,
    this.pubDate,
    this.category = 'Gündem',
    this.readCount = '12.4k okuma',
    this.timeAgo = 'Yeni',
    this.isBreaking = false,
    this.isFavorite = false,
    this.isRead = false,
    this.isNtvFeed = false,
    int? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  factory UnifiedNewsItem.fromRss(RssItem item, {bool isBreaking = false}) {
    final meta = _getSourceMeta(item.sourceId);
    final validImage = (item.imageUrl != null && item.imageUrl!.isNotEmpty)
        ? item.imageUrl
        : BaseNewsParser.getFallbackImageForSource(
            item.sourceId,
            item.category,
          );

    return UnifiedNewsItem(
      id: item.id,
      sourceId: item.sourceId,
      sourceTitle: item.sourceTitle.isNotEmpty ? item.sourceTitle : meta.title,
      sourceBadgeText: meta.badgeText,
      sourceBadgeColor: meta.badgeColor,
      title: item.title,
      spot: item.description,
      description: item.description,
      content: item.content,
      link: item.link,
      imageUrl: validImage,
      pubDate: item.pubDate,
      category: item.category ?? 'Gündem',
      timeAgo: _calculateTimeAgo(item.createdAt),
      readCount: _generateReadCount(item.title),
      isBreaking: isBreaking,
      isFavorite: item.isFavorite,
      isRead: item.isRead,
      isNtvFeed: false,
      createdAt: item.createdAt,
    );
  }

  factory UnifiedNewsItem.fromNtv(NtvFeedItem item, {bool isBreaking = false}) {
    final meta = _getSourceMeta('ntv');
    final validImage = (item.imageUrl != null && item.imageUrl!.isNotEmpty)
        ? item.imageUrl
        : BaseNewsParser.getFallbackImageForSource('ntv', item.category);

    return UnifiedNewsItem(
      id: item.id,
      sourceId: 'ntv',
      sourceTitle: 'NTV',
      sourceBadgeText: meta.badgeText,
      sourceBadgeColor: meta.badgeColor,
      title: item.title,
      spot: item.spot ?? item.description,
      description: item.description,
      content: item.content,
      link: item.link,
      imageUrl: validImage,
      pubDate: item.pubDate,
      category: item.category ?? 'Gündem',
      timeAgo: _calculateTimeAgo(item.createdAt),
      readCount: _generateReadCount(item.title),
      isBreaking: isBreaking,
      isFavorite: item.isFavorite,
      isRead: item.isRead,
      isNtvFeed: true,
      createdAt: item.createdAt,
    );
  }

  UnifiedNewsItem copyWith({
    int? id,
    String? sourceId,
    String? sourceTitle,
    String? sourceBadgeText,
    Color? sourceBadgeColor,
    String? title,
    String? spot,
    String? description,
    String? content,
    String? link,
    String? imageUrl,
    String? pubDate,
    String? category,
    String? readCount,
    String? timeAgo,
    bool? isBreaking,
    bool? isFavorite,
    bool? isRead,
    bool? isNtvFeed,
    int? createdAt,
  }) {
    return UnifiedNewsItem(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      sourceTitle: sourceTitle ?? this.sourceTitle,
      sourceBadgeText: sourceBadgeText ?? this.sourceBadgeText,
      sourceBadgeColor: sourceBadgeColor ?? this.sourceBadgeColor,
      title: title ?? this.title,
      spot: spot ?? this.spot,
      description: description ?? this.description,
      content: content ?? this.content,
      link: link ?? this.link,
      imageUrl: imageUrl ?? this.imageUrl,
      pubDate: pubDate ?? this.pubDate,
      category: category ?? this.category,
      readCount: readCount ?? this.readCount,
      timeAgo: timeAgo ?? this.timeAgo,
      isBreaking: isBreaking ?? this.isBreaking,
      isFavorite: isFavorite ?? this.isFavorite,
      isRead: isRead ?? this.isRead,
      isNtvFeed: isNtvFeed ?? this.isNtvFeed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static _SourceMeta _getSourceMeta(String sourceId) {
    final found = findNewsSourceById(sourceId);
    if (found != null) {
      return _SourceMeta(
        title: found.title,
        badgeText: found.badgeText,
        badgeColor: found.badgeColor,
      );
    }
    return _SourceMeta(
      title: sourceId.toUpperCase(),
      badgeText: sourceId.length > 3
          ? sourceId.substring(0, 3).toUpperCase()
          : sourceId.toUpperCase(),
      badgeColor: const Color(0xFF1D4ED8),
    );
  }

  static String _calculateTimeAgo(int timestamp) {
    final now = DateTime.now();
    final itemTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final diff = now.difference(itemTime);

    if (diff.inMinutes < 1) {
      return 'Az önce';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} dk önce';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} saat önce';
    } else {
      return '${diff.inDays} gün önce';
    }
  }

  static String _generateReadCount(String title) {
    final hash = title.hashCode.abs();
    final count = ((hash % 180) + 20) / 10.0;
    return '${count.toStringAsFixed(1)}k okuma';
  }
}

class _SourceMeta {
  final String title;
  final String badgeText;
  final Color badgeColor;

  _SourceMeta({
    required this.title,
    required this.badgeText,
    required this.badgeColor,
  });
}
