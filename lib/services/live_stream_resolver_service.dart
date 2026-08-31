import 'package:http/http.dart' as http;

class LiveStreamResolverService {
  static final Map<String, String> _cache = {};

  static Future<String> resolveLiveVideoId({
    required String handle,
    required String fallbackVideoId,
  }) async {
    if (_cache.containsKey(handle)) {
      return _cache[handle]!;
    }

    try {
      final response = await http
          .get(
            Uri.parse('https://www.youtube.com/$handle/live'),
            headers: {
              'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
              'Accept-Language': 'tr-TR,tr;q=0.9,en-US;q=0.8,en;q=0.7',
            },
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final match = RegExp(r'"videoId":"([a-zA-Z0-9_-]{11})"')
            .firstMatch(response.body);
        if (match != null && match.group(1) != null) {
          final resolvedId = match.group(1)!;
          _cache[handle] = resolvedId;
          return resolvedId;
        }
      }
    } catch (_) {}

    return fallbackVideoId;
  }
}
