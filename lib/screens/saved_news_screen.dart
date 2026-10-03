import 'package:flutter/material.dart';
import 'package:flutter_medic/constants/universaltheme.dart';
import 'package:flutter_medic/controllers/news_feed_controller.dart';
import 'package:flutter_medic/models/unified_news_item.dart';
import 'package:flutter_medic/services/share_service.dart';
import 'package:flutter_medic/widgets/home/news_card_item.dart';
import 'package:flutter_medic/widgets/news_detail_modal.dart';

class SavedNewsScreen extends StatelessWidget {
  final NewsFeedController controller;

  const SavedNewsScreen({super.key, required this.controller});

  void _openNewsDetail(BuildContext context, UnifiedNewsItem item) {
    NewsDetailModal.show(
      context: context,
      newsItem: item,
      onFavoriteToggle: () => controller.toggleBookmark(item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final savedItems = controller.savedItems;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'SANA ÖZEL ARŞİV',
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Kaydedilenler',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                          color: AppColors.black,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: savedItems.isEmpty
                      ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.bookmark_border_rounded,
                            size: 36,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Henüz Kaydedilen Haber Yok',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Haber akışında yer imi simgesine tıklayarak beğendiğiniz haberleri ömür boyu saklayabilirsiniz.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 30),
                  itemCount: savedItems.length,
                  itemBuilder: (context, index) {
                    final item = savedItems[index];
                    return NewsCardItem(
                      item: item,
                      onTap: () => _openNewsDetail(context, item),
                      onBookmarkTap: () => controller.toggleBookmark(item),
                      onShareTap: () =>
                          ShareService.shareNewsItem(item, context: context),
                    );
                  },
                ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
