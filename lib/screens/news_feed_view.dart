import 'package:flutter/material.dart';
import 'package:flutter_medic/controllers/news_feed_controller.dart';
import 'package:flutter_medic/models/unified_news_item.dart';
import 'package:flutter_medic/services/share_service.dart';
import 'package:flutter_medic/widgets/home/breaking_news_card.dart';
import 'package:flutter_medic/widgets/home/category_chips_bar.dart';
import 'package:flutter_medic/widgets/home/empty_news_view.dart';
import 'package:flutter_medic/widgets/home/home_header.dart';
import 'package:flutter_medic/widgets/home/home_search_bar.dart';
import 'package:flutter_medic/widgets/home/news_card_item.dart';
import 'package:flutter_medic/widgets/home/source_filter_bottom_sheet.dart';
import 'package:flutter_medic/widgets/news_detail_modal.dart';

class NewsFeedView extends StatefulWidget {
  final NewsFeedController controller;

  const NewsFeedView({super.key, required this.controller});

  @override
  State<NewsFeedView> createState() => _NewsFeedViewState();
}

class _NewsFeedViewState extends State<NewsFeedView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openSourceFilter() {
    SourceFilterBottomSheet.show(
      context: context,
      currentSelectedIds: widget.controller.selectedSourceIds,
      onApply: widget.controller.updateSelectedSources,
    );
  }

  void _openNewsDetail(UnifiedNewsItem item) {
    NewsDetailModal.show(
      context: context,
      newsItem: item,
      onFavoriteToggle: () => widget.controller.toggleBookmark(item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final controller = widget.controller;
        final breakingItem = controller.breakingNewsItem;
        final standardItems = controller.standardNewsItems;
        final isEmpty = controller.filteredFeedItems.isEmpty;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: controller.refreshFeed,
                  color: primaryColor,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: ClampingScrollPhysics(),
                    ),
                    slivers: [
                      SliverToBoxAdapter(
                        child: HomeHeader(
                          selectedSourceCount: controller.selectedSourceCount,
                          onFilterTap: _openSourceFilter,
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: HomeSearchBar(
                          controller: _searchController,
                          onChanged: controller.setSearchQuery,
                          onClear: () => controller.setSearchQuery(''),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 14)),

                      SliverToBoxAdapter(
                        child: CategoryChipsBar(
                          categories: NewsFeedController.availableCategories,
                          selectedCategory: controller.selectedCategory,
                          onCategorySelected: controller.setCategory,
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 16)),

                      if (controller.isLoading)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          ),
                        )
                      else if (isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: EmptyNewsView(
                            title: 'Haber Bulunamadı',
                            subtitle: 'Seçtiğiniz kaynaklara veya arama kriterine uygun haber bulunamadı.',
                            buttonText: 'Kaynakları Düzenle',
                            onAction: _openSourceFilter,
                          ),
                        )
                      else ...[
                        if (breakingItem != null)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: BreakingNewsCard(
                                item: breakingItem,
                                onTap: () => _openNewsDetail(breakingItem),
                                onBookmarkTap: () =>
                                    controller.toggleBookmark(breakingItem),
                                onShareTap: () => ShareService.shareNewsItem(
                                  breakingItem,
                                  context: context,
                                ),
                              ),
                            ),
                          ),

                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final item = standardItems[index];
                            return NewsCardItem(
                              item: item,
                              onTap: () => _openNewsDetail(item),
                              onBookmarkTap: () =>
                                  controller.toggleBookmark(item),
                              onShareTap: () => ShareService.shareNewsItem(
                                item,
                                context: context,
                              ),
                            );
                          }, childCount: standardItems.length),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 24)),
                      ],
                    ],
                  ),
                ),

                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 16,
                  child: AnimatedSlide(
                    offset: controller.isSyncing
                        ? Offset.zero
                        : const Offset(0, 2),
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutBack,
                    child: AnimatedOpacity(
                      opacity: controller.isSyncing ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 250),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Kaynaklar ayarlanıyor, lütfen bekleyiniz...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
