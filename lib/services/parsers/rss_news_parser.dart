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
    // 1. <image> child tag (CNN Türk tarzı — plain text URL)
    for (final child in element.childElements) {
      if (child.name.local.toLowerCase() == 'image') {
        final u = child.innerText.trim();
        if (_looksLikeImage(u)) return u;
      }
    }

    // 2. enclosure / media:content / media:thumbnail — attribute'lardan url al
    for (final child in element.descendantElements) {
      final local = child.name.local.toLowerCase();
      final qualified = child.name.qualified.toLowerCase();

      final isMediaTag = local == 'enclosure' ||
          local == 'thumbnail' ||
          qualified.contains('media:content') ||
          qualified.contains('media:thumbnail');

      if (!isMediaTag) continue;

      final urlAttr = child.getAttribute('url') ?? '';
      final typeAttr = child.getAttribute('type') ?? '';
      final mediumAttr = child.getAttribute('medium') ?? '';

      // type="image/..." veya medium="image" → güvenle al
      if (typeAttr.startsWith('image') || mediumAttr == 'image') {
        if (_isValidUrl(urlAttr)) return urlAttr;
      }

      // type yoksa URL'nin kendisi görsel dosyasına işaret ediyor mu?
      if (_looksLikeImage(urlAttr)) return urlAttr;
    }

    // 3. Diğer elementlerin src/href attribute'larına bak
    for (final child in element.descendantElements) {
      for (final attr in child.attributes) {
        final attrName = attr.name.local.toLowerCase();
        if (attrName == 'src' || attrName == 'href') {
          final u = attr.value.trim();
          if (_looksLikeImage(u)) return u;
        }
      }
    }

    // 4. description / content HTML'inden <img src> çek
    final imgFromDesc = BaseNewsParser.extractImageFromHtml(description);
    if (_isValidUrl(imgFromDesc)) return imgFromDesc;

    final imgFromContent = BaseNewsParser.extractImageFromHtml(content);
    if (_isValidUrl(imgFromContent)) return imgFromContent;

    return null;
  }

  /// URL'nin içeriğini parse etmeden sadece yapısından görsel olduğuna karar verir.
  /// Proxy URL'leri (?u=...jpeg) ve bilinen CDN host'larını da kabul eder.
  static bool _looksLikeImage(String? url) {
    if (!_isValidUrl(url)) return false;
    final lower = url!.toLowerCase();

    // Uzantı (query string dahil aranır — ?u=...jpeg gibi proxy URL'leri yakalar)
    if (lower.contains('.jpg') ||
        lower.contains('.jpeg') ||
        lower.contains('.png') ||
        lower.contains('.webp') ||
        lower.contains('.gif') ||
        lower.contains('.avif')) {
      return true;
    }

    // Bilinen görsel path segmentleri
    final path = Uri.tryParse(url)?.path.toLowerCase() ?? '';
    if (path.contains('/image') ||
        path.contains('/img') ||
        path.contains('/photo') ||
        path.contains('/resim') ||
        path.contains('/foto')) {
      return true;
    }

    // Bilinen görsel CDN host'ları
    final host = Uri.tryParse(url)?.host.toLowerCase() ?? '';
    return host.contains('im.haberturk') ||
        host.contains('image.cnnturk') ||
        host.contains('trthaberstatic') ||
        host.contains('iaahbr.tmgrup') ||
        host.contains('img.piri.net') ||
        host.contains('cdn.sabah') ||
        host.contains('cdn.takvim') ||
        host.contains('medya.sozcu') ||
        host.contains('i.sabah') ||
        host.contains('haberglobal') ||
        host.contains('turkiyegazetesi') ||
        host.contains('cdn.aksamhaberleri');
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
