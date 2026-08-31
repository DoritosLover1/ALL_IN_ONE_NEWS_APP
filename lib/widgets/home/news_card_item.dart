import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medic/constants/universaltheme.dart';
import 'package:flutter_medic/models/unified_news_item.dart';

class NewsCardItem extends StatelessWidget {
  final UnifiedNewsItem item;
  final VoidCallback onBookmarkTap;
  final VoidCallback? onTap;
  final VoidCallback? onShareTap;

  const NewsCardItem({
    super.key,
    required this.item,
    required this.onBookmarkTap,
    this.onTap,
    this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl =
        item.imageUrl ??
        'https://images.unsplash.com/photo-1585829365295-ab7cd400c167?w=600&q=80';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: item.sourceBadgeColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          item.sourceBadgeText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 9.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        item.sourceTitle,
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '•  ${item.timeAgo}',
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: const Color(0xFF94A3B8),
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                height: 1.28,
                                letterSpacing: -0.2,
                              ),
                            ),
                            if (item.spot != null && item.spot!.isNotEmpty) ...[
                              const SizedBox(height: 5),
                              Text(
                                item.spot!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 12,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: 78,
                          height: 78,
                          color: const Color(0xFFF1F5F9),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Container(color: const Color(0xFFF1F5F9)),
                            errorWidget: (context, url, error) => Container(
                              color: const Color(0xFFE2E8F0),
                              child: const Icon(
                                Icons.image_outlined,
                                color: Color(0xFF94A3B8),
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.category,
                          style: const TextStyle(
                            color: Color(0xFFD97706),
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const Spacer(),

                      InkWell(
                        onTap: onBookmarkTap,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            item.isFavorite
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            color: item.isFavorite
                                ? theme.colorScheme.primary
                                : const Color(0xFF94A3B8),
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),

                      InkWell(
                        onTap: onShareTap,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.share_outlined,
                            color: Color(0xFF94A3B8),
                            size: 19,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
