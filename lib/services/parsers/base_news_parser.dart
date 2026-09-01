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
    final sId = sourceId.toLowerCase();
    switch (sId) {
      case 'haberturk':
        return 'assets/logos/haberturk.jpg';
      case 'trt':
        return 'assets/logos/trt.jpg';
      case 'ntv':
        return 'assets/logos/ntv.jpg';
      case 'sozcu':
        return 'assets/logos/sozcu.jpg';
      case 'ahaber':
        return 'assets/logos/ahaber.jpg';
      case 'cnnturk':
        return 'assets/logos/cnnturk.jpg';
      case 'haberglobal':
        return 'assets/logos/haberglobal.jpg';
      case 'yenisafak':
        return 'assets/logos/yenisafak.jpg';
      case 'takvim':
        return 'assets/logos/takvim.jpg';
      case 'turkiyegazetesi':
        return 'assets/logos/turkiyegazetesi.jpg';
      case 'aksamhaberleri':
        return 'assets/logos/aksamhaberleri.jpg';
      case 'sabah':
        return 'assets/logos/sabah.jpg';
      default:
        return 'assets/logos/trt.jpg';
    }
  }
}
