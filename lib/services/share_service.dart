import 'package:flutter/material.dart';
import 'package:flutter_medic/models/unified_news_item.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<void> shareNewsItem(
    UnifiedNewsItem item, {
    BuildContext? context,
  }) async {
    final title = item.title.trim();
    final url = item.link.trim();
    final source = item.sourceTitle.trim();

    final String shareText;
    if (url.isNotEmpty && !title.contains(url)) {
      shareText = '$title\n\nKaynak: $source\n$url';
    } else {
      shareText = title.isNotEmpty ? title : url;
    }

    Rect? sharePositionOrigin;
    if (context != null && context.mounted) {
      try {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null && box.hasSize && box.size.width > 0 && box.size.height > 0) {
          final pos = box.localToGlobal(Offset.zero);
          sharePositionOrigin = Rect.fromLTWH(
            pos.dx,
            pos.dy,
            box.size.width,
            box.size.height,
          );
        }
      } catch (_) {}
    }

    try {
      await SharePlus.instance.share(
        ShareParams(
          text: shareText,
          subject: title.isNotEmpty ? title : null,
          sharePositionOrigin: sharePositionOrigin,
        ),
      );
    } catch (_) {
      try {
        await SharePlus.instance.share(
          ShareParams(
            text: shareText,
            subject: title.isNotEmpty ? title : null,
          ),
        );
      } catch (_) {}
    }
  }
}
