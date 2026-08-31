import 'package:flutter/material.dart';

class SourceChannel {
  final String id;
  final String name;
  final String category;
  final String badgeText;
  final Color badgeColor;
  final String youtubeVideoId;
  final String liveStreamUrl;
  final String embedUrl;
  final String thumbnailUrl;
  final bool isLive;
  final String viewerCount;
  final String programTitle;

  const SourceChannel({
    required this.id,
    required this.name,
    required this.category,
    required this.badgeText,
    required this.badgeColor,
    required this.youtubeVideoId,
    required this.liveStreamUrl,
    required this.embedUrl,
    required this.thumbnailUrl,
    this.isLive = true,
    this.viewerCount = '14.2k',
    this.programTitle = 'Canlı Yayın & Güncel Bülten',
  });
}

const List<SourceChannel> initialLiveChannels = [
  SourceChannel(
    id: 'trt',
    name: 'TRT Haber',
    category: 'Ulusal Haber',
    badgeText: 'TRT',
    badgeColor: Color(0xFF0F52BA),
    youtubeVideoId: 's2x41d6bN48',
    liveStreamUrl: 'https://www.youtube.com/watch?v=s2x41d6bN48',
    embedUrl:
        'https://www.youtube-nocookie.com/embed/s2x41d6bN48?autoplay=1&mute=0',
    thumbnailUrl: 'https://images.unsplash.com/photo-1585829365295-ab7cd400c167?w=800&q=80',
    viewerCount: '34.8k',
    programTitle: 'Ana Haber Bülteni',
  ),
  SourceChannel(
    id: 'ntv',
    name: 'NTV Canlı',
    category: 'Ekonomi & Gündem',
    badgeText: 'NTV',
    badgeColor: Color(0xFF008751),
    youtubeVideoId: 'XDEb1s-hM_0',
    liveStreamUrl: 'https://www.youtube.com/watch?v=XDEb1s-hM_0',
    embedUrl:
        'https://www.youtube-nocookie.com/embed/XDEb1s-hM_0?autoplay=1&mute=0',
    thumbnailUrl: 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=800&q=80',
    viewerCount: '28.1k',
    programTitle: 'Piyasa Ekranı & Son Dakika',
  ),
  SourceChannel(
    id: 'haberturk',
    name: 'Habertürk TV',
    category: 'Gündem & Tartışma',
    badgeText: 'HT',
    badgeColor: Color(0xFFE50014),
    youtubeVideoId: '713pB0P3y9w',
    liveStreamUrl: 'https://www.youtube.com/watch?v=713pB0P3y9w',
    embedUrl:
        'https://www.youtube-nocookie.com/embed/713pB0P3y9w?autoplay=1&mute=0',
    thumbnailUrl: 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=800&q=80',
    viewerCount: '22.4k',
    programTitle: 'Türkiye Nabzı Özel',
  ),
  SourceChannel(
    id: 'sozcu',
    name: 'Sözcü TV',
    category: 'Haber & Gündem',
    badgeText: 'SZC',
    badgeColor: Color(0xFFD6181F),
    youtubeVideoId: 'F_fD-iF-QyE',
    liveStreamUrl: 'https://www.youtube.com/watch?v=F_fD-iF-QyE',
    embedUrl:
        'https://www.youtube-nocookie.com/embed/F_fD-iF-QyE?autoplay=1&mute=0',
    thumbnailUrl: 'https://images.unsplash.com/photo-1495020689067-958852a7765e?w=800&q=80',
    viewerCount: '41.5k',
    programTitle: 'Sözcü Ana Haber',
  ),
  SourceChannel(
    id: 'cnnturk',
    name: 'CNN Türk',
    category: 'Haber & Dünya',
    badgeText: 'CNN',
    badgeColor: Color(0xFFCC0000),
    youtubeVideoId: 'e_04hYg5h3Y',
    liveStreamUrl: 'https://www.youtube.com/watch?v=e_04hYg5h3Y',
    embedUrl:
        'https://www.youtube-nocookie.com/embed/e_04hYg5h3Y?autoplay=1&mute=0',
    thumbnailUrl: 'https://images.unsplash.com/photo-1526470608268-f674ce90ebd4?w=800&q=80',
    viewerCount: '19.3k',
    programTitle: 'Dünya Raporu & Sıcak Bölge',
  ),
  SourceChannel(
    id: 'ahaber',
    name: 'A Haber',
    category: 'Haber & Politika',
    badgeText: 'AH',
    badgeColor: Color(0xFF0A2B66),
    youtubeVideoId: 'x0x4Z0Z4x0x',
    liveStreamUrl: 'https://www.youtube.com/watch?v=x0x4Z0Z4x0x',
    embedUrl:
        'https://www.youtube-nocookie.com/embed/x0x4Z0Z4x0x?autoplay=1&mute=0',
    thumbnailUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800&q=80',
    viewerCount: '15.9k',
    programTitle: 'Ajans Gün Ortası',
  ),
  SourceChannel(
    id: 'haberglobal',
    name: 'Haber Global',
    category: 'Haber & Analiz',
    badgeText: 'HG',
    badgeColor: Color(0xFF2C3E50),
    youtubeVideoId: '9_t6w9_RkWm',
    liveStreamUrl: 'https://www.youtube.com/watch?v=9_t6w9_RkWm',
    embedUrl:
        'https://www.youtube-nocookie.com/embed/9_t6w9_RkWm?autoplay=1&mute=0',
    thumbnailUrl:
        'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=800&q=80',
    viewerCount: '11.2k',
    programTitle: 'Küresel Bakış',
  ),
];
