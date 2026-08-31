import 'package:flutter/material.dart';
import 'package:flutter_medic/constants/universaltheme.dart';
import 'package:flutter_medic/controllers/news_feed_controller.dart';
import 'package:flutter_medic/models/unified_news_item.dart';
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
          appBar: AppBar(
            backgroundColor: const Color(0xFFF8FAFC),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kaydedilenler',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.black,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Ömür boyu saklanan haberleriniz',
                  style: TextStyle(
                    color: AppColors.gray,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          body: savedItems.isEmpty
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
                    );
                  },
                ),
        );
      },
    );
  }
}
