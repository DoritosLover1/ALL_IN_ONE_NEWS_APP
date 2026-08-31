import 'package:flutter_medic/data/database/entities/rss_item.dart';
import 'package:flutter_medic/services/parsers/base_news_parser.dart';
import 'package:xml/xml.dart';

class RssNewsParser {
  static List<RssItem> parse({
    required String sourceId,
    required String sourceTitle,
    required String xmlContent,
  }) {
    final List<RssItem> items = [];

    try {
      final document = XmlDocument.parse(xmlContent);

      final itemElements = document.findAllElements('item');
      if (itemElements.isNotEmpty) {
        for (final item in itemElements) {
          final title =
              item.findElements('title').firstOrNull?.innerText.trim() ?? '';
          final description = item
              .findElements('description')
              .firstOrNull
              ?.innerText
              .trim();

          String? content;
          for (final child in item.children.whereType<XmlElement>()) {
            if (child.name.local == 'encoded' ||
                child.name.local == 'content') {
              content = child.innerText.trim();
              break;
            }
          }

          String link =
              item.findElements('link').firstOrNull?.innerText.trim() ?? '';
          if (link.isEmpty) {
            link =
                item.findElements('guid').firstOrNull?.innerText.trim() ?? '';
          }

          final pubDate =
              item.findElements('pubDate').firstOrNull?.innerText.trim() ??
              item.findElements('dc:date').firstOrNull?.innerText.trim();

          final category =
              item.findElements('category').firstOrNull?.innerText.trim() ??
              _getDefaultCategoryForSource(sourceId);

          final author =
              item.findElements('author').firstOrNull?.innerText.trim() ??
              item.findElements('dc:creator').firstOrNull?.innerText.trim();

          String? imageUrl = _extractImageUrlFromElement(
            item,
            description,
            content,
          );

          imageUrl ??= BaseNewsParser.getFallbackImageForSource(
            sourceId,
            category,
          );

          if (title.isNotEmpty && link.isNotEmpty) {
            items.add(
              RssItem(
                sourceId: sourceId,
                sourceTitle: sourceTitle,
                title: BaseNewsParser.cleanHtml(title),
                description: BaseNewsParser.cleanHtml(description ?? content),
                content: content,
                link: link,
                pubDate: pubDate,
                imageUrl: imageUrl,
                category: BaseNewsParser.cleanHtml(category),
                author: author,
                createdAt: BaseNewsParser.parseDateToTimestamp(pubDate),
              ),
            );
          }
        }
      }

      if (items.isEmpty) {
        final entries = document.findAllElements('entry');
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

          String link =
              entry.findElements('link').firstOrNull?.getAttribute('href') ??
              entry.findElements('id').firstOrNull?.innerText.trim() ??
              '';

          final published =
              entry.findElements('published').firstOrNull?.innerText.trim() ??
              entry.findElements('updated').firstOrNull?.innerText.trim();

          final category =
              entry
                  .findElements('category')
                  .firstOrNull
                  ?.getAttribute('term') ??
              _getDefaultCategoryForSource(sourceId);

          String? imageUrl = _extractImageUrlFromElement(
            entry,
            summary,
            content,
          );
          imageUrl ??= BaseNewsParser.getFallbackImageForSource(
            sourceId,
            category,
          );

          if (title.isNotEmpty && link.isNotEmpty) {
            items.add(
              RssItem(
                sourceId: sourceId,
                sourceTitle: sourceTitle,
                title: BaseNewsParser.cleanHtml(title),
                description: BaseNewsParser.cleanHtml(summary ?? content),
                content: content,
                link: link,
                pubDate: published,
                imageUrl: imageUrl,
                category: BaseNewsParser.cleanHtml(category),
                createdAt: BaseNewsParser.parseDateToTimestamp(published),
              ),
            );
          }
        }
      }
    } catch (_) {}

    return items;
  }

  static String? _extractImageUrlFromElement(
    XmlElement element,
    String? description,
    String? content,
  ) {
    for (final child in element.children.whereType<XmlElement>()) {
      final local = child.name.local.toLowerCase();
      final qualified = child.name.qualified.toLowerCase();

      if (local == 'enclosure') {
        final url = child.getAttribute('url') ?? child.getAttribute('src');
        if (_isValidUrl(url)) return url;
      }

      if (local == 'content' || qualified.contains('content')) {
        final url = child.getAttribute('url') ?? child.getAttribute('src');
        if (_isValidUrl(url)) return url;
      }

      if (local == 'thumbnail' || qualified.contains('thumbnail')) {
        final url = child.getAttribute('url') ?? child.getAttribute('src');
        if (_isValidUrl(url)) return url;
      }

      if (local == 'image' || qualified.contains('image')) {
        final innerUrl = child
            .findElements('url')
            .firstOrNull
            ?.innerText
            .trim();
        if (_isValidUrl(innerUrl)) return innerUrl;

        final textUrl = child.innerText.trim();
        if (_isValidUrl(textUrl)) return textUrl;
      }

      if (local.contains('resim') ||
          local.contains('foto') ||
          local.contains('gorsel')) {
        final textUrl = child.innerText.trim();
        if (_isValidUrl(textUrl)) return textUrl;
      }
    }

    final imgFromDesc = BaseNewsParser.extractImageFromHtml(description);
    if (_isValidUrl(imgFromDesc)) return imgFromDesc;

    final imgFromContent = BaseNewsParser.extractImageFromHtml(content);
    if (_isValidUrl(imgFromContent)) return imgFromContent;

    return null;
  }

  static bool _isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    final clean = url.trim().toLowerCase();
    return clean.startsWith('http://') || clean.startsWith('https://');
  }

  static String _getDefaultCategoryForSource(String sourceId) {
    switch (sourceId.toLowerCase()) {
      case 'trt':
      case 'haberturk':
      case 'ahaber':
      case 'aksamhaberleri':
        return 'Gündem';
      case 'sozcu':
      case 'yenisafak':
      case 'takvim':
      case 'turkiyegazetesi':
      case 'sabah':
        return 'Türkiye';
      case 'cnnturk':
      case 'haberglobal':
        return 'Haber';
      default:
        return 'Gündem';
    }
  }
}
