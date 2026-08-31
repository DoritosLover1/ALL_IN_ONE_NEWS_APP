import 'package:flutter/material.dart';
import 'package:flutter_medic/models/unified_news_item.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<void> shareNewsItem(
    UnifiedNewsItem item, {
    BuildContext? context,
  }) async {
    final title = item.title;
    final url = item.link;
    final source = item.sourceTitle;
    final shareText = '$title\n\nKaynak: $source\n$url';

    Rect? sharePositionOrigin;
    if (context != null && context.mounted) {
      final box = context.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        sharePositionOrigin = box.localToGlobal(Offset.zero) & box.size;
      }
    }

    try {
      await SharePlus.instance.share(
        ShareParams(
          text: shareText,
          subject: title,
          sharePositionOrigin: sharePositionOrigin,
        ),
      );
    } catch (_) {
      try {
        await SharePlus.instance.share(
          ShareParams(
            uri: Uri.parse(url),
            subject: title,
            sharePositionOrigin: sharePositionOrigin,
          ),
        );
      } catch (_) {}
    }
  }
}
