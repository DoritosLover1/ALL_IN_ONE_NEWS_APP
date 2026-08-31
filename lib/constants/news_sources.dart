import 'package:flutter/material.dart';
import 'package:flutter_medic/models/selectable_item.dart';

enum NewsSourceType { rss, feed }

class NewsSourceItem extends SelectableItem {
  final NewsSourceType type;
  final String url;

  const NewsSourceItem({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.badgeText,
    required super.badgeColor,
    required this.type,
    required this.url,
  });
}

const List<NewsSourceItem> kAllNewsSources = [
  NewsSourceItem(
    id: 'haberturk',
    title: 'Habertürk',
    subtitle: 'Haber & Gündem',
    badgeText: 'HT',
    badgeColor: Color(0xFFE50014),
    type: NewsSourceType.rss,
    url: 'https://www.haberturk.com/rss',
  ),
  NewsSourceItem(
    id: 'trt',
    title: 'TRT Haber',
    subtitle: 'Türkiye & Gündem',
    badgeText: 'TRT',
    badgeColor: Color(0xFF0F52BA),
    type: NewsSourceType.rss,
    url: 'https://www.trthaber.com/gundem_articles.rss',
  ),
  NewsSourceItem(
    id: 'ntv',
    title: 'NTV',
    subtitle: 'Türkiye & Dünya',
    badgeText: 'NTV',
    badgeColor: Color(0xFF008751),
    type: NewsSourceType.feed,
    url: 'https://www.ntv.com.tr/turkiye.rss',
  ),
  NewsSourceItem(
    id: 'sozcu',
    title: 'Sözcü',
    subtitle: 'Son Dakika & Gazete',
    badgeText: 'SZC',
    badgeColor: Color(0xFFD6181F),
    type: NewsSourceType.rss,
    url: 'https://www.sozcu.com.tr/feeds-haberler',
  ),
  NewsSourceItem(
    id: 'ahaber',
    title: 'A Haber',
    subtitle: 'Gündem & Son Dakika',
    badgeText: 'AH',
    badgeColor: Color(0xFF0A2B66),
    type: NewsSourceType.rss,
    url: 'https://www.ahaber.com.tr/rss/news.xml',
  ),
  NewsSourceItem(
    id: 'cnnturk',
    title: 'CNN Türk',
    subtitle: 'Türkiye & Dünya',
    badgeText: 'CNN',
    badgeColor: Color(0xFFCC0000),
    type: NewsSourceType.rss,
    url: 'https://www.cnnturk.com/feed/rss/turkiye/news',
  ),
  NewsSourceItem(
    id: 'haberglobal',
    title: 'Haber Global',
    subtitle: 'Haber & Canlı',
    badgeText: 'HG',
    badgeColor: Color(0xFF2C3E50),
    type: NewsSourceType.rss,
    url: 'https://haberglobal.com/rss',
  ),
  NewsSourceItem(
    id: 'yenisafak',
    title: 'Yeni Şafak',
    subtitle: 'Gündem & Politika',
    badgeText: 'YŞ',
    badgeColor: Color(0xFFC0392B),
    type: NewsSourceType.rss,
    url: 'https://www.yenisafak.com/rss',
  ),
  NewsSourceItem(
    id: 'takvim',
    title: 'Takvim',
    subtitle: 'Güncel & Magazin',
    badgeText: 'TKV',
    badgeColor: Color(0xFFE67E22),
    type: NewsSourceType.rss,
    url: 'https://www.takvim.com.tr/rss/news.xml',
  ),
  NewsSourceItem(
    id: 'turkiyegazetesi',
    title: 'Türkiye Gazetesi',
    subtitle: 'Gündem & Ekonomi',
    badgeText: 'TG',
    badgeColor: Color(0xFF16A085),
    type: NewsSourceType.rss,
    url: 'https://www.turkiyegazetesi.com.tr/rss',
  ),
  NewsSourceItem(
    id: 'aksamhaberleri',
    title: 'Akşam Haberleri',
    subtitle: 'Gündem & Analiz',
    badgeText: 'AKŞ',
    badgeColor: Color(0xFF8E44AD),
    type: NewsSourceType.rss,
    url: 'https://www.aksamhaberleri.com.tr/rss.xml',
  ),
  NewsSourceItem(
    id: 'sabah',
    title: 'Sabah',
    subtitle: 'Son Dakika & Gündem',
    badgeText: 'SBH',
    badgeColor: Color(0xFFD35400),
    type: NewsSourceType.rss,
    url: 'https://www.sabah.com.tr/rss/news.xml',
  ),
];

NewsSourceItem? findNewsSourceById(String id) {
  try {
    return kAllNewsSources.firstWhere(
      (source) => source.id.toLowerCase() == id.toLowerCase(),
    );
  } catch (_) {
    return null;
  }
}
