import 'package:intl/intl.dart';

abstract class BaseNewsParser {
  static String cleanHtml(String? text) {
    if (text == null || text.isEmpty) return '';
    return text
        .replaceAll(RegExp(r'<style[^>]*>[\s\S]*?<\/style>'), '')
        .replaceAll(RegExp(r'<script[^>]*>[\s\S]*?<\/script>'), '')
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&#39;', "'")
        .replaceAll('&#x27;', "'")
        .replaceAll('&#x2B;', '+')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static String? extractImageFromHtml(String? html) {
    if (html == null || html.isEmpty) return null;

    final regex = RegExp(
      r'<img[^>]+src=["'
      "'"
      r']([^"'
      "'"
      r'\s>]+)["'
      "'"
      r']',
      caseSensitive: false,
    );
    final match = regex.firstMatch(html);
    if (match != null) {
      final url = match.group(1);
      if (url != null && _isValidImageUrl(url)) return url;
    }

    final regexUnquoted = RegExp(
      r'<img[^>]+src=([^\s>]+)',
      caseSensitive: false,
    );
    final matchUnquoted = regexUnquoted.firstMatch(html);
    if (matchUnquoted != null) {
      final url = matchUnquoted.group(1);
      if (url != null && _isValidImageUrl(url)) return url;
    }

    final regexEncoded = RegExp(
      r'&lt;img[^&]+src=(?:&quot;|&#39;|")([^&"\s>]+)',
      caseSensitive: false,
    );
    final matchEncoded = regexEncoded.firstMatch(html);
    if (matchEncoded != null) {
      final url = matchEncoded.group(1);
      if (url != null && _isValidImageUrl(url)) return url;
    }

    return null;
  }

  static bool _isValidImageUrl(String url) {
    final clean = url.trim().toLowerCase();
    return clean.startsWith('http://') || clean.startsWith('https://');
  }

  static int parseDateToTimestamp(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return DateTime.now().millisecondsSinceEpoch;
    }

    try {
      final iso = DateTime.tryParse(dateStr);
      if (iso != null) return iso.millisecondsSinceEpoch;

      final cleanDate = dateStr
          .replaceAll('GMT', '+0000')
          .replaceAll('&#x2B;', '+')
          .replaceAll('UTC', '+0000')
          .trim();

      final formats = [
        'EEE, dd MMM yyyy HH:mm:ss Z',
        'EEE, dd MMM yyyy HH:mm:ss',
        'dd MMM yyyy HH:mm:ss Z',
        'yyyy-MM-dd HH:mm:ss',
      ];

      for (final format in formats) {
        try {
          final dt = DateFormat(format, 'en_US').parse(cleanDate);
          return dt.millisecondsSinceEpoch;
        } catch (_) {}
      }
    } catch (_) {}

    return DateTime.now().millisecondsSinceEpoch;
  }

  static String getFallbackImageForSource(String sourceId, [String? category]) {
    final cat = (category ?? '').toLowerCase();
    if (cat.contains('ekonomi') ||
        cat.contains('para') ||
        cat.contains('finans')) {
      return 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=800&q=80';
    }
    if (cat.contains('spor') ||
        cat.contains('futbol') ||
        cat.contains('basketbol')) {
      return 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?w=800&q=80';
    }
    if (cat.contains('teknoloji') ||
        cat.contains('bilim') ||
        cat.contains('yazılım')) {
      return 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=800&q=80';
    }
    if (cat.contains('dünya') ||
        cat.contains('dunya') ||
        cat.contains('küresel')) {
      return 'https://images.unsplash.com/photo-1526470608268-f674ce90ebd4?w=800&q=80';
    }

    switch (sourceId.toLowerCase()) {
      case 'trt':
        return 'https://images.unsplash.com/photo-1585829365295-ab7cd400c167?w=800&q=80';
      case 'ntv':
        return 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=800&q=80';
      case 'haberturk':
        return 'https://images.unsplash.com/photo-1495020689067-958852a7765e?w=800&q=80';
      case 'sozcu':
        return 'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=800&q=80';
      case 'cnnturk':
        return 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800&q=80';
      default:
        return 'https://images.unsplash.com/photo-1585829365295-ab7cd400c167?w=800&q=80';
    }
  }
}
