import 'package:flutter_medic/data/database/daos/ntv_feed_dao.dart';
import 'package:flutter_medic/data/database/daos/rss_dao.dart';
import 'package:flutter_medic/data/database/ntv_feed_database.dart';
import 'package:flutter_medic/data/database/rss_database.dart';
import 'package:flutter_medic/models/unified_news_item.dart';

class DatabaseService {
  DatabaseService._internal();
  static final DatabaseService _instance = DatabaseService._internal();
  static DatabaseService get instance => _instance;

  static const List<String> rssSourceIds = [
    'haberturk',
    'trt',
    'sozcu',
    'ahaber',
    'cnnturk',
    'haberglobal',
    'yenisafak',
    'takvim',
    'turkiyegazetesi',
    'aksamhaberleri',
    'sabah',
  ];

  final Map<String, RssDatabase> _rssDatabases = {};
  NtvFeedDatabase? _ntvFeedDatabase;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _ntvFeedDatabase = await $FloorNtvFeedDatabase
        .databaseBuilder('ntv_feed.db')
        .build();

    for (final sourceId in rssSourceIds) {
      final dbName = '${sourceId}_rss.db';
      final db = await $FloorRssDatabase.databaseBuilder(dbName).build();
      _rssDatabases[sourceId] = db;
    }

    _isInitialized = true;
  }

  NtvFeedDao get ntvFeedDao {
    if (_ntvFeedDatabase == null) {
      throw StateError(
        'DatabaseService henüz initialize edilmedi. Önce initialize() çağırınız.',
      );
    }
    return _ntvFeedDatabase!.ntvFeedDao;
  }

  NtvFeedDatabase get ntvFeedDatabase {
    if (_ntvFeedDatabase == null) {
      throw StateError(
        'DatabaseService henüz initialize edilmedi. Önce initialize() çağırınız.',
      );
    }
    return _ntvFeedDatabase!;
  }

  RssDao getRssDao(String sourceId) {
    final db = _rssDatabases[sourceId.toLowerCase()];
    if (db == null) {
      throw ArgumentError(
        'Geçersiz veya başlatılmamış RSS kaynak ID: $sourceId. Mevcut kaynaklar: $rssSourceIds',
      );
    }
    return db.rssDao;
  }

  RssDatabase getRssDatabase(String sourceId) {
    final db = _rssDatabases[sourceId.toLowerCase()];
    if (db == null) {
      throw ArgumentError(
        'Geçersiz veya başlatılmamış RSS kaynak ID: $sourceId. Mevcut kaynaklar: $rssSourceIds',
      );
    }
    return db;
  }

  Future<RssDatabase> openCustomRssDatabase(String sourceId) async {
    final key = sourceId.toLowerCase();
    if (_rssDatabases.containsKey(key)) {
      return _rssDatabases[key]!;
    }
    final db = await $FloorRssDatabase.databaseBuilder('${key}_rss.db').build();
    _rssDatabases[key] = db;
    return db;
  }

  RssDao get haberturkDao => getRssDao('haberturk');
  RssDao get trtDao => getRssDao('trt');
  RssDao get sozcuDao => getRssDao('sozcu');
  RssDao get ahaberDao => getRssDao('ahaber');
  RssDao get cnnturkDao => getRssDao('cnnturk');
  RssDao get haberglobalDao => getRssDao('haberglobal');
  RssDao get yenisafakDao => getRssDao('yenisafak');
  RssDao get takvimDao => getRssDao('takvim');
  RssDao get turkiyegazetesiDao => getRssDao('turkiyegazetesi');
  RssDao get aksamhaberleriDao => getRssDao('aksamhaberleri');
  RssDao get sabahDao => getRssDao('sabah');

  List<RssDao> getAllRssDaos() {
    return _rssDatabases.values.map((db) => db.rssDao).toList();
  }

  Future<void> cleanupOldNews({
    Duration olderThan = const Duration(hours: 24),
  }) async {
    final cutoffTimestamp = DateTime.now()
        .subtract(olderThan)
        .millisecondsSinceEpoch;

    if (_ntvFeedDatabase != null) {
      await _ntvFeedDatabase!.ntvFeedDao.deleteOldUnsavedItems(cutoffTimestamp);
    }

    for (final db in _rssDatabases.values) {
      await db.rssDao.deleteOldUnsavedItems(cutoffTimestamp);
    }
  }

  Future<List<UnifiedNewsItem>> getCombinedNewsFeed(
    Set<String> activeSourceIds,
  ) async {
    final List<UnifiedNewsItem> combined = [];

    if (activeSourceIds.contains('ntv') && _ntvFeedDatabase != null) {
      final ntvItems = await _ntvFeedDatabase!.ntvFeedDao.findAllNtvFeedItems();
      combined.addAll(ntvItems.map((e) => UnifiedNewsItem.fromNtv(e)));
    }

    for (final sourceId in activeSourceIds) {
      if (sourceId.toLowerCase() == 'ntv') continue;
      final db = _rssDatabases[sourceId.toLowerCase()];
      if (db != null) {
        final rssItems = await db.rssDao.findAllRssItems();
        combined.addAll(rssItems.map((e) => UnifiedNewsItem.fromRss(e)));
      }
    }

    combined.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return combined;
  }

  Future<List<UnifiedNewsItem>> getAllFavoriteItems() async {
    final List<UnifiedNewsItem> favorites = [];

    if (_ntvFeedDatabase != null) {
      final ntvFavs = await _ntvFeedDatabase!.ntvFeedDao
          .findFavoriteNtvFeedItems();
      favorites.addAll(ntvFavs.map((e) => UnifiedNewsItem.fromNtv(e)));
    }

    for (final db in _rssDatabases.values) {
      final rssFavs = await db.rssDao.findFavoriteRssItems();
      favorites.addAll(rssFavs.map((e) => UnifiedNewsItem.fromRss(e)));
    }

    favorites.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return favorites;
  }

  Future<void> toggleFavorite({
    required String sourceId,
    required int itemId,
    required bool isFavorite,
  }) async {
    if (sourceId.toLowerCase() == 'ntv' && _ntvFeedDatabase != null) {
      final item = await _ntvFeedDatabase!.ntvFeedDao.findNtvFeedItemById(
        itemId,
      );
      if (item != null) {
        await _ntvFeedDatabase!.ntvFeedDao.updateNtvFeedItem(
          item.copyWith(isFavorite: isFavorite),
        );
      }
    } else {
      final db = _rssDatabases[sourceId.toLowerCase()];
      if (db != null) {
        final item = await db.rssDao.findRssItemById(itemId);
        if (item != null) {
          await db.rssDao.updateRssItem(item.copyWith(isFavorite: isFavorite));
        }
      }
    }
  }

  Future<void> clearAllDatabases() async {
    if (_ntvFeedDatabase != null) {
      await _ntvFeedDatabase!.ntvFeedDao.deleteAllNtvFeedItems();
    }
    for (final db in _rssDatabases.values) {
      await db.rssDao.deleteAllRssItems();
    }
  }

  Future<void> closeAll() async {
    await _ntvFeedDatabase?.close();
    _ntvFeedDatabase = null;
    for (final db in _rssDatabases.values) {
      await db.close();
    }
    _rssDatabases.clear();
    _isInitialized = false;
  }
}
