import 'package:flutter_medic/data/database/entities/ntv_feed_item.dart';
import 'package:flutter_medic/services/parsers/base_news_parser.dart';
import 'package:xml/xml.dart';

class NtvAtomFeedParser {
  static List<NtvFeedItem> parse(String xmlContent) {
    final List<NtvFeedItem> feedItems = [];

    try {
      final document = XmlDocument.parse(xmlContent);

      final entries = document.findAllElements('entry');
      if (entries.isNotEmpty) {
        for (final entry in entries) {
          final title =
              entry.findElements('title').firstOrNull?.innerText.trim() ?? '';
          final summary = entry
              .findElements('summary')
              .firstOrNull
              ?.innerText
              .trim();
          final content = entry
              .findElements('content')
              .firstOrNull
              ?.innerText
              .trim();

          String link = '';
          final linkEl = entry.findElements('link').firstOrNull;
          if (linkEl != null) {
            link = linkEl.getAttribute('href') ?? linkEl.innerText.trim();
          }
          if (link.isEmpty) {
            link = entry.findElements('id').firstOrNull?.innerText.trim() ?? '';
          }

          final published =
              entry.findElements('published').firstOrNull?.innerText.trim() ??
              entry.findElements('updated').firstOrNull?.innerText.trim();

          final category =
              entry
                  .findElements('category')
                  .firstOrNull
                  ?.getAttribute('term') ??
              'Türkiye';

          String? imageUrl;
          final enclosure = entry.findElements('enclosure').firstOrNull;
          if (enclosure != null) {
            imageUrl = enclosure.getAttribute('url');
          }
          if (imageUrl == null || imageUrl.isEmpty) {
            imageUrl = BaseNewsParser.extractImageFromHtml(content);
          }
          if (imageUrl == null || imageUrl.isEmpty) {
            final media = entry.findElements('media:content').firstOrNull;
            imageUrl = media?.getAttribute('url');
          }
          imageUrl ??= BaseNewsParser.getFallbackImageForSource(
            'ntv',
            category,
          );

          if (title.isNotEmpty && link.isNotEmpty) {
            feedItems.add(
              NtvFeedItem(
                title: BaseNewsParser.cleanHtml(title),
                spot: BaseNewsParser.cleanHtml(summary ?? content),
                description: BaseNewsParser.cleanHtml(summary ?? content),
                content: content,
                link: link,
                pubDate: published,
                imageUrl: imageUrl,
                category: category,
                createdAt: BaseNewsParser.parseDateToTimestamp(published),
              ),
            );
          }
        }
      }

      if (feedItems.isEmpty) {
        final items = document.findAllElements('item');
        for (final item in items) {
          final title =
              item.findElements('title').firstOrNull?.innerText.trim() ?? '';
          final description = item
              .findElements('description')
              .firstOrNull
              ?.innerText
              .trim();
          final link =
              item.findElements('link').firstOrNull?.innerText.trim() ??
              item.findElements('guid').firstOrNull?.innerText.trim() ??
              '';
          final pubDate = item
              .findElements('pubDate')
              .firstOrNull
              ?.innerText
              .trim();
          final category =
              item.findElements('category').firstOrNull?.innerText.trim() ??
              'Türkiye';

          String? imageUrl =
              item.findElements('enclosure').firstOrNull?.getAttribute('url') ??
              item
                  .findElements('media:content')
                  .firstOrNull
                  ?.getAttribute('url') ??
              BaseNewsParser.extractImageFromHtml(description);

          if (title.isNotEmpty && link.isNotEmpty) {
            feedItems.add(
              NtvFeedItem(
                title: BaseNewsParser.cleanHtml(title),
                spot: BaseNewsParser.cleanHtml(description),
                description: BaseNewsParser.cleanHtml(description),
                link: link,
                pubDate: pubDate,
                imageUrl: imageUrl,
                category: category,
                createdAt: BaseNewsParser.parseDateToTimestamp(pubDate),
              ),
            );
          }
        }
      }
    } catch (_) {}

    return feedItems;
  }
}
