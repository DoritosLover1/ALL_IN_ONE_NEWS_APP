import 'package:flutter/material.dart';
import 'package:flutter_medic/models/unified_news_item.dart';
import 'package:flutter_medic/services/database_service.dart';
import 'package:flutter_medic/services/news_sync_service.dart';
import 'package:flutter_medic/services/user_preferences_service.dart';

class NewsFeedController extends ChangeNotifier {
  Set<String> _selectedSourceIds = {};
  List<UnifiedNewsItem> _feedItems = [];
  List<UnifiedNewsItem> _savedItems = [];
  String _selectedCategory = 'Tümü';
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isSyncing = false;

  Set<String> get selectedSourceIds => _selectedSourceIds;
  int get selectedSourceCount => _selectedSourceIds.length;
  List<UnifiedNewsItem> get feedItems => _feedItems;
  List<UnifiedNewsItem> get savedItems => _savedItems;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  bool get isSyncing => _isSyncing;

  static const List<String> availableCategories = [
    'Tümü',
    'Gündem',
    'Ekonomi',
    'Dünya',
    'Teknoloji',
    'Spor',
    'Sağlık',
    'Ulaşım & Altyapı',
    'Enerji & Çevre',
    'Eğitim',
  ];

  NewsFeedController() {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    if (!DatabaseService.instance.isInitialized) {
      await DatabaseService.instance.initialize();
    }

    _selectedSourceIds = await UserPreferencesService.getSelectedSources();

    await _loadFeedFromDatabase();
    await _loadSavedItemsFromDatabase();

    _isLoading = false;
    notifyListeners();

    refreshFeed();
  }

  Future<void> refreshFeed() async {
    if (_isSyncing) return;
    _isSyncing = true;
    notifyListeners();

    try {
      await NewsSyncService.instance.syncSelectedSources(_selectedSourceIds);
      await _loadFeedFromDatabase();
      await _loadSavedItemsFromDatabase();
    } catch (_) {
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> updateSelectedSources(Set<String> newSourceIds) async {
    _selectedSourceIds = Set.from(newSourceIds);
    await UserPreferencesService.saveSelectedSources(_selectedSourceIds);
    notifyListeners();

    await refreshFeed();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> toggleBookmark(UnifiedNewsItem item) async {
    if (item.id == null) return;
    final newFavoriteStatus = !item.isFavorite;

    await DatabaseService.instance.toggleFavorite(
      sourceId: item.sourceId,
      itemId: item.id!,
      isFavorite: newFavoriteStatus,
    );

    _feedItems = _feedItems.map((feedItem) {
      if (feedItem.id == item.id && feedItem.sourceId == item.sourceId) {
        return feedItem.copyWith(isFavorite: newFavoriteStatus);
      }
      return feedItem;
    }).toList();

    await _loadSavedItemsFromDatabase();
    notifyListeners();
  }

  List<UnifiedNewsItem> get filteredFeedItems {
    var list = _feedItems;

    if (_selectedCategory != 'Tümü') {
      list = list.where((item) {
        return item.category.toLowerCase().contains(
              _selectedCategory.toLowerCase(),
            ) ||
            _selectedCategory.toLowerCase().contains(
              item.category.toLowerCase(),
            );
      }).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((item) {
        return item.title.toLowerCase().contains(q) ||
            (item.description?.toLowerCase().contains(q) ?? false) ||
            item.category.toLowerCase().contains(q) ||
            item.sourceTitle.toLowerCase().contains(q);
      }).toList();
    }

    return list;
  }

  UnifiedNewsItem? get breakingNewsItem {
    final list = filteredFeedItems;
    if (list.isEmpty) return null;

    return list.firstWhere((item) => item.isBreaking, orElse: () => list.first);
  }

  List<UnifiedNewsItem> get standardNewsItems {
    final list = filteredFeedItems;
    if (list.length <= 1) return [];
    return list.sublist(1);
  }

  Future<void> _loadFeedFromDatabase() async {
    _feedItems = await DatabaseService.instance.getCombinedNewsFeed(
      _selectedSourceIds,
    );

    if (_feedItems.isNotEmpty) {
      _feedItems[0] = _feedItems[0].copyWith(isBreaking: true);
    }
  }

  Future<void> _loadSavedItemsFromDatabase() async {
    _savedItems = await DatabaseService.instance.getAllFavoriteItems();
  }
}
