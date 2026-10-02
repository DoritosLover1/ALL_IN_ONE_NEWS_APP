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
  int _displayLimit = 20;

  List<SelectableItem> get allSources => _allSources;
  Set<String> get selectedIds => _selectedIds;
  int get selectedCount => _selectedIds.length;
  bool get hasSelection => _selectedIds.isNotEmpty;
  String get searchQuery => _searchQuery;
  
  bool get hasMoreToLoad {
    final totalFiltered = _searchQuery.isEmpty 
        ? _allSources.length 
        : _allSources.where((item) => 
            item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            item.subtitle.toLowerCase().contains(_searchQuery.toLowerCase())).length;
    return _displayLimit < totalFiltered;
  }

  List<SelectableItem> get filteredSources {
    List<SelectableItem> results;
    if (_searchQuery.isEmpty) {
      results = _allSources;
    } else {
      final query = _searchQuery.toLowerCase();
      results = _allSources.where((item) {
        return item.title.toLowerCase().contains(query) ||
            item.subtitle.toLowerCase().contains(query);
      }).toList();
    }
    
    if (results.length > _displayLimit) {
      return results.sublist(0, _displayLimit);
    }
    return results;
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
    _displayLimit = 20;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _displayLimit = 20;
    notifyListeners();
  }
  
  void loadMore() {
    _displayLimit += 20;
    notifyListeners();
  }
}
