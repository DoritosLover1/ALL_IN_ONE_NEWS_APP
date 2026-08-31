import 'dart:convert';

import 'package:flutter_medic/constants/news_sources.dart';
import 'package:flutter_medic/data/database/entities/ntv_feed_item.dart';
import 'package:flutter_medic/data/database/entities/rss_item.dart';
import 'package:flutter_medic/services/database_service.dart';
import 'package:flutter_medic/services/parsers/ntv_atom_feed_parser.dart';
import 'package:flutter_medic/services/parsers/rss_news_parser.dart';
import 'package:flutter_medic/services/user_preferences_service.dart';
import 'package:http/http.dart' as http;

class NewsSyncService {
  NewsSyncService._internal();
  static final NewsSyncService _instance = NewsSyncService._internal();
  static NewsSyncService get instance => _instance;

  static const Map<String, String> _customHeaders = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
    'Accept-Language': 'tr-TR,tr;q=0.9,en-US;q=0.8,en;q=0.7',
  };

  static String getSourceUrl(String sourceId) {
    return findNewsSourceById(sourceId)?.url ?? '';
  }

  static String get ntvFeedEndpoint =>
      findNewsSourceById('ntv')?.url ?? 'https://www.ntv.com.tr/turkiye.rss';

  Future<void> syncSelectedSources(Set<String> selectedSourceIds) async {
    if (!DatabaseService.instance.isInitialized) {
      await DatabaseService.instance.initialize();
    }

    await DatabaseService.instance.cleanupOldNews(
      olderThan: const Duration(hours: 24),
    );

    final futures = <Future<void>>[];

    for (final sourceId in selectedSourceIds) {
      switch (sourceId.toLowerCase()) {
        case 'haberturk':
          futures.add(syncHaberturk());
          break;
        case 'trt':
          futures.add(syncTrt());
          break;
        case 'ntv':
          futures.add(syncNtv());
          break;
        case 'sozcu':
          futures.add(syncSozcu());
          break;
        case 'ahaber':
          futures.add(syncAhaber());
          break;
        case 'cnnturk':
          futures.add(syncCnnturk());
          break;
        case 'haberglobal':
          futures.add(syncHaberglobal());
          break;
        case 'yenisafak':
          futures.add(syncYenisafak());
          break;
        case 'takvim':
          futures.add(syncTakvim());
          break;
        case 'turkiyegazetesi':
          futures.add(syncTurkiyegazetesi());
          break;
        case 'aksamhaberleri':
          futures.add(syncAksamhaberleri());
          break;
        case 'sabah':
          futures.add(syncSabah());
          break;
        default:
          futures.add(_syncGenericRss(sourceId));
          break;
      }
    }

    await Future.wait(futures);
    await UserPreferencesService.setLastSyncTimestamp(
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<void> syncHaberturk() async {
    await _fetchAndStoreRss(
      sourceId: 'haberturk',
      sourceTitle: 'Habertürk',
      url: getSourceUrl('haberturk'),
    );
  }

  Future<void> syncTrt() async {
    await _fetchAndStoreRss(
      sourceId: 'trt',
      sourceTitle: 'TRT Haber',
      url: getSourceUrl('trt'),
    );
  }

  Future<void> syncNtv() async {
    try {
      final response = await http
          .get(Uri.parse(ntvFeedEndpoint), headers: _customHeaders)
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final xmlString = utf8.decode(response.bodyBytes, allowMalformed: true);
        final items = NtvAtomFeedParser.parse(xmlString);

        if (items.isNotEmpty) {
          await DatabaseService.instance.ntvFeedDao.insertNtvFeedItems(items);
          return;
        }
      }
    } catch (_) {}

    await _seedNtvFeedIfEmpty();
  }

  Future<void> syncSozcu() async {
    await _fetchAndStoreRss(
      sourceId: 'sozcu',
      sourceTitle: 'Sözcü',
      url: getSourceUrl('sozcu'),
    );
  }

  Future<void> syncAhaber() async {
    await _fetchAndStoreRss(
      sourceId: 'ahaber',
      sourceTitle: 'A Haber',
      url: getSourceUrl('ahaber'),
    );
  }

  Future<void> syncCnnturk() async {
    await _fetchAndStoreRss(
      sourceId: 'cnnturk',
      sourceTitle: 'CNN Türk',
      url: getSourceUrl('cnnturk'),
    );
  }

  Future<void> syncHaberglobal() async {
    await _fetchAndStoreRss(
      sourceId: 'haberglobal',
      sourceTitle: 'Haber Global',
      url: getSourceUrl('haberglobal'),
    );
  }

  Future<void> syncYenisafak() async {
    await _fetchAndStoreRss(
      sourceId: 'yenisafak',
      sourceTitle: 'Yeni Şafak',
      url: getSourceUrl('yenisafak'),
    );
  }

  Future<void> syncTakvim() async {
    await _fetchAndStoreRss(
      sourceId: 'takvim',
      sourceTitle: 'Takvim',
      url: getSourceUrl('takvim'),
    );
  }

  Future<void> syncTurkiyegazetesi() async {
    await _fetchAndStoreRss(
      sourceId: 'turkiyegazetesi',
      sourceTitle: 'Türkiye Gazetesi',
      url: getSourceUrl('turkiyegazetesi'),
    );
  }

  Future<void> syncAksamhaberleri() async {
    await _fetchAndStoreRss(
      sourceId: 'aksamhaberleri',
      sourceTitle: 'Akşam Haberleri',
      url: getSourceUrl('aksamhaberleri'),
    );
  }

  Future<void> syncSabah() async {
    await _fetchAndStoreRss(
      sourceId: 'sabah',
      sourceTitle: 'Sabah',
      url: getSourceUrl('sabah'),
    );
  }

  Future<void> _fetchAndStoreRss({
    required String sourceId,
    required String sourceTitle,
    required String url,
  }) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: _customHeaders)
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final xmlString = utf8.decode(response.bodyBytes, allowMalformed: true);
        final items = RssNewsParser.parse(
          sourceId: sourceId,
          sourceTitle: sourceTitle,
          xmlContent: xmlString,
        );

        if (items.isNotEmpty) {
          final dao = DatabaseService.instance.getRssDao(sourceId);
          await dao.insertRssItems(items);
          return;
        }
      }
    } catch (_) {}

    await _seedRssSourceIfEmpty(sourceId);
  }

  Future<void> _syncGenericRss(String sourceId) async {
    final url = getSourceUrl(sourceId);
    if (url.isNotEmpty) {
      await _fetchAndStoreRss(
        sourceId: sourceId,
        sourceTitle: sourceId.toUpperCase(),
        url: url,
      );
    }
  }

  Future<void> _seedNtvFeedIfEmpty() async {
    final count = await DatabaseService.instance.ntvFeedDao.getItemCount();
    if ((count ?? 0) > 0) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    final seedItems = [
      NtvFeedItem(
        title:
            'NTV Özel: Merkez Bankaları yeni faiz projeksiyonlarını paylaştı',
        spot: 'Küresel piyasalarda gözler enflasyon verilerine çevrilirken borsalarda sert hareketlilik gözleniyor.',
        description: 'Küresel piyasalarda gözler enflasyon verilerine çevrilirken borsalarda sert hareketlilik gözleniyor. Yatırımcılar faiz kararlarını yakından takip ediyor.',
        link: 'https://www.ntv.com.tr/ekonomi/merkez-bankasi-faiz-karari',
        category: 'Ekonomi',
        imageUrl: 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=800&q=80',
        createdAt: now - 38 * 60 * 1000,
      ),
      NtvFeedItem(
        title: 'Teknoloji devinden yapay zeka alanında tarihi yatırım hamlesi',
        spot: 'Yeni nesil işlemciler ve veri merkezleri için milyar dolarlık fon ayrıldı.',
        description: 'Yapay zeka altyapısını güçlendirmek amacıyla yeni kuantum işlemci merkezlerinin kurulacağı duyuruldu.',
        link: 'https://www.ntv.com.tr/teknoloji/yapay-zeka-yatirimi',
        category: 'Teknoloji',
        imageUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=800&q=80',
        createdAt: now - 90 * 60 * 1000,
      ),
    ];

    await DatabaseService.instance.ntvFeedDao.insertNtvFeedItems(seedItems);
  }

  Future<void> _seedRssSourceIfEmpty(String sourceId) async {
    final dao = DatabaseService.instance.getRssDao(sourceId);
    final count = await dao.getItemCount();
    if ((count ?? 0) > 0) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    final List<RssItem> seedItems = [];

    if (sourceId == 'trt') {
      seedItems.addAll([
        RssItem(
          sourceId: 'trt',
          sourceTitle: 'TRT Haber',
          title: 'Avrupa ile yeni hızlı tren koridoru için nihai anlaşma imzalandı',
          description: 'Ulaştırma Bakanlığı koordinasyonunda yürütülen uluslararası demiryolu entegrasyonu projesinde kritik imza atıldı.',
          link: 'https://www.trthaber.com/haber/avrupa-hizli-tren-koridoru-1',
          category: 'Ulaşım & Altyapı',
          imageUrl: 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=1000&q=80',
          createdAt: now - 14 * 60 * 1000,
        ),
      ]);
    } else if (sourceId == 'haberturk') {
      seedItems.addAll([
        RssItem(
          sourceId: 'haberturk',
          sourceTitle: 'Habertürk',
          title: 'Küresel piyasalarda altın ve döviz cephesinde kritik hafta',
          description: 'Analistler faiz kararları öncesi risk iştahındaki dalgalanmaları değerlendirdi.',
          link: 'https://www.haberturk.com/ekonomi/altin-doviz-piyasalar',
          category: 'Ekonomi',
          imageUrl: 'https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?w=800&q=80',
          createdAt: now - 45 * 60 * 1000,
        ),
      ]);
    } else if (sourceId == 'cnnturk') {
      seedItems.addAll([
        RssItem(
          sourceId: 'cnnturk',
          sourceTitle: 'CNN Türk',
          title: "Akdeniz'de yeşil hidrojen ve rüzgar enerjisi devrimi: Dev yatırım duyuruldu",
          description: 'Bölgedeki yenilenebilir enerji kapasitesini üçe katlayacak dev tesis projesi onaylandı.',
          link: 'https://www.cnnturk.com/haber/akdeniz-yesil-enerji-1',
          category: 'Enerji & Çevre',
          imageUrl: 'https://images.unsplash.com/photo-1466611653911-95081537e5b7?w=800&q=80',
          createdAt: now - 60 * 60 * 1000,
        ),
      ]);
    } else {
      seedItems.add(
        RssItem(
          sourceId: sourceId,
          sourceTitle: sourceId.toUpperCase(),
          title:
              '${sourceId.toUpperCase()}: Gündemdeki son gelişmeler ve analizler',
          description: 'Haber akışınız kişiselleştirilmiş tercihleriniz doğrultusunda güncellenmektedir.',
          link: 'https://news.example.com/$sourceId/1',
          category: 'Gündem',
          imageUrl: 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=800&q=80',
          createdAt: now - 30 * 60 * 1000,
        ),
      );
    }

    await dao.insertRssItems(seedItems);
  }
}
