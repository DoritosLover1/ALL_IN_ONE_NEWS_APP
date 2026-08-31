import 'package:flutter/material.dart';
import 'package:flutter_medic/controllers/news_feed_controller.dart';
import 'package:flutter_medic/widgets/home/breaking_news_card.dart';
import 'package:flutter_medic/widgets/home/category_chips_bar.dart';
import 'package:flutter_medic/widgets/home/empty_news_view.dart';
import 'package:flutter_medic/widgets/home/home_header.dart';
import 'package:flutter_medic/widgets/home/home_search_bar.dart';
import 'package:flutter_medic/widgets/home/news_card_item.dart';
import 'package:flutter_medic/widgets/home/source_filter_bottom_sheet.dart';

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

  @override
  Widget build(BuildContext context) {
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
            child: RefreshIndicator(
              onRefresh: controller.refreshFeed,
              color: const Color(0xFFDC2626),
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
                      onFilterTap: _openSourceFilter,
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
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFDC2626),
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
                            onBookmarkTap: () =>
                                controller.toggleBookmark(breakingItem),
                          ),
                        ),
                      ),

                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = standardItems[index];
                        return NewsCardItem(
                          item: item,
                          onBookmarkTap: () => controller.toggleBookmark(item),
                        );
                      }, childCount: standardItems.length),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
