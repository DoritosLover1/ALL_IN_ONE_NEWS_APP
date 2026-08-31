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
    youtubeVideoId: '8_B0hQf5Zf4',
    liveStreamUrl: 'https://www.youtube.com/watch?v=8_B0hQf5Zf4',
    embedUrl: 'https://www.youtube.com/embed/8_B0hQf5Zf4?autoplay=1&playsinline=1&rel=0&modestbranding=1',
    thumbnailUrl: 'https://images.unsplash.com/photo-1585829365295-ab7cd400c167?w=800&q=80',
    programTitle: 'TRT Haber Canlı Yayın',
  ),
  SourceChannel(
    id: 'ntv',
    name: 'NTV Canlı',
    category: 'Ekonomi & Gündem',
    badgeText: 'NTV',
    badgeColor: Color(0xFF008751),
    youtubeVideoId: 'XEJM4Hcgd3M',
    liveStreamUrl: 'https://www.youtube.com/watch?v=XEJM4Hcgd3M',
    embedUrl: 'https://www.youtube.com/embed/XEJM4Hcgd3M?autoplay=1&playsinline=1&rel=0&modestbranding=1',
    thumbnailUrl: 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=800&q=80',
    programTitle: 'NTV Canlı Yayın & Gündem',
  ),
  SourceChannel(
    id: 'haberturk',
    name: 'Habertürk TV',
    category: 'Gündem & Tartışma',
    badgeText: 'HT',
    badgeColor: Color(0xFFE50014),
    youtubeVideoId: 'p9j8uS8N5_k',
    liveStreamUrl: 'https://www.youtube.com/watch?v=p9j8uS8N5_k',
    embedUrl: 'https://www.youtube.com/embed/p9j8uS8N5_k?autoplay=1&playsinline=1&rel=0&modestbranding=1',
    thumbnailUrl: 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=800&q=80',
    programTitle: 'Habertürk TV Canlı',
  ),
  SourceChannel(
    id: 'sozcu',
    name: 'Sözcü TV',
    category: 'Haber & Gündem',
    badgeText: 'SZC',
    badgeColor: Color(0xFFD6181F),
    youtubeVideoId: '1B6GZ2q3j9k',
    liveStreamUrl: 'https://www.youtube.com/watch?v=1B6GZ2q3j9k',
    embedUrl: 'https://www.youtube.com/embed/1B6GZ2q3j9k?autoplay=1&playsinline=1&rel=0&modestbranding=1',
    thumbnailUrl: 'https://images.unsplash.com/photo-1495020689067-958852a7765e?w=800&q=80',
    programTitle: 'Sözcü TV Canlı Yayın',
  ),
  SourceChannel(
    id: 'cnnturk',
    name: 'CNN Türk',
    category: 'Haber & Dünya',
    badgeText: 'CNN',
    badgeColor: Color(0xFFCC0000),
    youtubeVideoId: 'V6W32aQ_m5U',
    liveStreamUrl: 'https://www.youtube.com/watch?v=V6W32aQ_m5U',
    embedUrl: 'https://www.youtube.com/embed/V6W32aQ_m5U?autoplay=1&playsinline=1&rel=0&modestbranding=1',
    thumbnailUrl: 'https://images.unsplash.com/photo-1526470608268-f674ce90ebd4?w=800&q=80',
    programTitle: 'CNN Türk Canlı',
  ),
  SourceChannel(
    id: 'ahaber',
    name: 'A Haber',
    category: 'Haber & Politika',
    badgeText: 'AH',
    badgeColor: Color(0xFF0A2B66),
    youtubeVideoId: '8v_s7e9U3X4',
    liveStreamUrl: 'https://www.youtube.com/watch?v=8v_s7e9U3X4',
    embedUrl: 'https://www.youtube.com/embed/8v_s7e9U3X4?autoplay=1&playsinline=1&rel=0&modestbranding=1',
    thumbnailUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800&q=80',
    programTitle: 'A Haber Canlı Yayın',
  ),
  SourceChannel(
    id: 'haberglobal',
    name: 'Haber Global',
    category: 'Haber & Analiz',
    badgeText: 'HG',
    badgeColor: Color(0xFF2C3E50),
    youtubeVideoId: 'v9E7eN-9y8w',
    liveStreamUrl: 'https://www.youtube.com/watch?v=v9E7eN-9y8w',
    embedUrl: 'https://www.youtube.com/embed/v9E7eN-9y8w?autoplay=1&playsinline=1&rel=0&modestbranding=1',
    thumbnailUrl:
        'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=800&q=80',
    programTitle: 'Haber Global Canlı',
  ),
];
