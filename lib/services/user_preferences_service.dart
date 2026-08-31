import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesService {
  static const String _keySelectedSources = 'selected_source_ids';
  static const String _keyOnboardingDone = 'onboarding_completed';
  static const String _keyLastSync = 'last_sync_timestamp';

  static const List<String> defaultSources = [
    'haberturk',
    'trt',
    'ntv',
    'sozcu',
    'cnnturk',
    'ahaber',
  ];

  static Future<Set<String>> getSelectedSources() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keySelectedSources);
    if (list == null || list.isEmpty) {
      return Set.from(defaultSources);
    }
    return list.toSet();
  }

  static Future<void> saveSelectedSources(Set<String> sourceIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keySelectedSources, sourceIds.toList());
  }

  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingDone) ?? false;
  }

  static Future<void> setOnboardingCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingDone, value);
  }

  static Future<int> getLastSyncTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyLastSync) ?? 0;
  }

  static Future<void> setLastSyncTimestamp(int timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLastSync, timestamp);
  }
}
