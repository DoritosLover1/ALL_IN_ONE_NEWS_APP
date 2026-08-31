import 'package:flutter/material.dart';
import 'package:flutter_medic/constants/news_sources.dart';
import 'package:flutter_medic/models/selectable_item.dart';

class SourceSelectionController extends ChangeNotifier {
  final List<SelectableItem> _allSources = kAllNewsSources;
  final Set<String> _selectedIds = {
    'haberturk',
    'trt',
    'ntv',
    'sozcu',
    'cnnturk',
  };
  String _searchQuery = '';

  List<SelectableItem> get allSources => _allSources;
  Set<String> get selectedIds => _selectedIds;
  int get selectedCount => _selectedIds.length;
  bool get hasSelection => _selectedIds.isNotEmpty;
  String get searchQuery => _searchQuery;

  List<SelectableItem> get filteredSources {
    if (_searchQuery.isEmpty) return _allSources;
    final query = _searchQuery.toLowerCase();
    return _allSources.where((item) {
      return item.title.toLowerCase().contains(query) ||
          item.subtitle.toLowerCase().contains(query);
    }).toList();
  }

  bool isSelected(String id) => _selectedIds.contains(id);

  void toggleItem(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    notifyListeners();
  }

  void selectAll() {
    _selectedIds.addAll(_allSources.map((e) => e.id));
    notifyListeners();
  }

  void clearAll() {
    _selectedIds.clear();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
}
