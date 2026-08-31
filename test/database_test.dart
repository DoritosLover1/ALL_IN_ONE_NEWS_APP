import 'package:flutter_medic/data/database/entities/ntv_feed_item.dart';
import 'package:flutter_medic/data/database/entities/rss_item.dart';
import 'package:flutter_medic/data/database/ntv_feed_database.dart';
import 'package:flutter_medic/data/database/rss_database.dart';
import 'package:flutter_medic/services/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('NTV Feed Database Tests', () {
    late NtvFeedDatabase ntvDb;

    setUp(() async {
      ntvDb = await $FloorNtvFeedDatabase.inMemoryDatabaseBuilder().build();
    });

    tearDown(() async {
      await ntvDb.close();
    });

    test('NTV Feed öğesi ekleme, getirme ve güncelleme testi', () async {
      final dao = ntvDb.ntvFeedDao;

      final item = NtvFeedItem(
        title: 'NTV Son Dakika Gelişmesi',
        spot: 'Ekonomi piyasalarında hareketlilik.',
        description: 'Detaylı haber içeriği...',
        link: 'https://www.ntv.com.tr/haber/1',
        category: 'Ekonomi',
      );

      await dao.insertNtvFeedItem(item);

      final items = await dao.findAllNtvFeedItems();
      expect(items.length, equals(1));
      expect(items.first.title, equals('NTV Son Dakika Gelişmesi'));
      expect(items.first.category, equals('Ekonomi'));

      await dao.insertNtvFeedItem(item);
      final afterDuplicate = await dao.findAllNtvFeedItems();
      expect(afterDuplicate.length, equals(1));

      final updated = items.first.copyWith(isFavorite: true);
      await dao.updateNtvFeedItem(updated);

      final favorites = await dao.findFavoriteNtvFeedItems();
      expect(favorites.length, equals(1));
      expect(favorites.first.isFavorite, isTrue);

      final searchResult = await dao.searchNtvFeedItems('%Dakika%');
      expect(searchResult.length, equals(1));
    });
  });

  group('Ayrı RSS Veritabanları Testleri', () {
    late RssDatabase haberturkDb;
    late RssDatabase trtDb;
    late RssDatabase sozcuDb;

    setUp(() async {
      haberturkDb = await $FloorRssDatabase
          .databaseBuilder('haberturk_test.db')
          .build();
      trtDb = await $FloorRssDatabase.databaseBuilder('trt_test.db').build();
      sozcuDb = await $FloorRssDatabase
          .databaseBuilder('sozcu_test.db')
          .build();
      await haberturkDb.rssDao.deleteAllRssItems();
      await trtDb.rssDao.deleteAllRssItems();
      await sozcuDb.rssDao.deleteAllRssItems();
    });

    tearDown(() async {
      await haberturkDb.close();
      await trtDb.close();
      await sozcuDb.close();
    });

    test(
      'Her RSS kaynağının kendi bağımsız veritabanında çalışması testi',
      () async {
        final htItem = RssItem(
          sourceId: 'haberturk',
          sourceTitle: 'Habertürk',
          title: 'Habertürk Gündem Başlığı',
          link: 'https://www.haberturk.com/haber-1',
        );
        await haberturkDb.rssDao.insertRssItem(htItem);

        final trtItem = RssItem(
          sourceId: 'trt',
          sourceTitle: 'TRT Haber',
          title: 'TRT Haber Spor Gelişmesi',
          link: 'https://www.trthaber.com/haber-1',
        );
        await trtDb.rssDao.insertRssItem(trtItem);

        final sozcuItem = RssItem(
          sourceId: 'sozcu',
          sourceTitle: 'Sözcü',
          title: 'Sözcü Ekonomi Manşeti',
          link: 'https://www.sozcu.com.tr/haber-1',
        );
        await sozcuDb.rssDao.insertRssItem(sozcuItem);

        final htItems = await haberturkDb.rssDao.findAllRssItems();
        expect(htItems.length, equals(1));
        expect(htItems.first.sourceId, equals('haberturk'));
        expect(htItems.first.title, equals('Habertürk Gündem Başlığı'));

        final trtItems = await trtDb.rssDao.findAllRssItems();
        expect(trtItems.length, equals(1));
        expect(trtItems.first.sourceId, equals('trt'));

        final sozcuItems = await sozcuDb.rssDao.findAllRssItems();
        expect(sozcuItems.length, equals(1));
        expect(sozcuItems.first.sourceId, equals('sozcu'));

        await sozcuDb.rssDao.deleteAllRssItems();
        expect((await sozcuDb.rssDao.findAllRssItems()).isEmpty, isTrue);
        expect((await haberturkDb.rssDao.findAllRssItems()).length, equals(1));
        expect((await trtDb.rssDao.findAllRssItems()).length, equals(1));
      },
    );
  });

  group('24 Saatlik Temizleme ve Kalıcı Kayıt Politikası Testleri', () {
    late RssDatabase rssDb;

    setUp(() async {
      rssDb = await $FloorRssDatabase
          .databaseBuilder('retention_test.db')
          .build();
      await rssDb.rssDao.deleteAllRssItems();
    });

    tearDown(() async {
      await rssDb.close();
    });

    test(
      '24 saatten eski kaydedilmemiş haberler silinmeli, favoriler kalmalı',
      () async {
        final now = DateTime.now().millisecondsSinceEpoch;
        final twoDaysAgo = now - const Duration(days: 2).inMilliseconds;

        final oldUnsaved = RssItem(
          sourceId: 'trt',
          sourceTitle: 'TRT Haber',
          title: 'Eski ve Kaydedilmemiş Haber',
          link: 'https://trt.com/old',
          isFavorite: false,
          createdAt: twoDaysAgo,
        );

        final oldSaved = RssItem(
          sourceId: 'trt',
          sourceTitle: 'TRT Haber',
          title: 'Eski ama Kaydedilmiş Haber (Ömür boyu saklanır)',
          link: 'https://trt.com/saved',
          isFavorite: true,
          createdAt: twoDaysAgo,
        );

        final freshItem = RssItem(
          sourceId: 'trt',
          sourceTitle: 'TRT Haber',
          title: 'Bugünün Yeni Haberi',
          link: 'https://trt.com/new',
          isFavorite: false,
          createdAt: now,
        );

        await rssDb.rssDao.insertRssItems([oldUnsaved, oldSaved, freshItem]);
        expect((await rssDb.rssDao.findAllRssItems()).length, equals(3));

        final cutoff = DateTime.now()
            .subtract(const Duration(hours: 24))
            .millisecondsSinceEpoch;
        await rssDb.rssDao.deleteOldUnsavedItems(cutoff);

        final remaining = await rssDb.rssDao.findAllRssItems();
        expect(remaining.length, equals(2));

        final titles = remaining.map((e) => e.title).toList();
        expect(
          titles.contains('Eski ama Kaydedilmiş Haber (Ömür boyu saklanır)'),
          isTrue,
        );
        expect(titles.contains('Bugünün Yeni Haberi'), isTrue);
        expect(titles.contains('Eski ve Kaydedilmemiş Haber'), isFalse);
      },
    );
  });

  group('DatabaseService Tests', () {
    test('DatabaseService başlatma ve DAO erişimleri testi', () async {
      final dbService = DatabaseService.instance;
      await dbService.initialize();

      expect(dbService.isInitialized, isTrue);
      expect(dbService.ntvFeedDao, isNotNull);
      expect(dbService.haberturkDao, isNotNull);
      expect(dbService.trtDao, isNotNull);
      expect(dbService.sozcuDao, isNotNull);
      expect(dbService.ahaberDao, isNotNull);
      expect(dbService.cnnturkDao, isNotNull);
      expect(dbService.haberglobalDao, isNotNull);
      expect(dbService.yenisafakDao, isNotNull);
      expect(dbService.takvimDao, isNotNull);
      expect(dbService.turkiyegazetesiDao, isNotNull);
      expect(dbService.aksamhaberleriDao, isNotNull);
      expect(dbService.sabahDao, isNotNull);

      expect(dbService.getAllRssDaos().length, equals(11));

      await dbService.clearAllDatabases();
      await dbService.closeAll();
      expect(dbService.isInitialized, isFalse);
    });
  });
}
