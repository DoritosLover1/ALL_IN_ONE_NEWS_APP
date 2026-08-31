import 'package:flutter_medic/services/parsers/base_news_parser.dart';
import 'package:flutter_medic/services/parsers/ntv_atom_feed_parser.dart';
import 'package:flutter_medic/services/parsers/rss_news_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NtvAtomFeedParser Tests', () {
    const sampleNtvAtomXml = '''<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title type="text">ntv.com.tr</title>
  <entry>
    <id>https://www.ntv.com.tr/turkiye/ornek-haber-1</id>
    <title type="text">NTV Örnek Başlık</title>
    <summary type="text">NTV Özet Metni</summary>
    <published>2026-08-31T23:02:17+03:00</published>
    <category term="Türkiye" />
    <link rel="alternate" href="https://www.ntv.com.tr/turkiye/ornek-haber-1" />
    <content type="html"><![CDATA[<p>Detaylı haber içeriği</p>]]></content>
    <enclosure type="image/jpeg" url="https://images.ntv.com.tr/images/test.png" />
  </entry>
</feed>''';

    test('NTV Atom Feed XML başarıyla ayrıştırılmalı', () {
      final items = NtvAtomFeedParser.parse(sampleNtvAtomXml);
      expect(items.length, equals(1));
      final item = items.first;
      expect(item.title, equals('NTV Örnek Başlık'));
      expect(item.spot, equals('NTV Özet Metni'));
      expect(item.link, equals('https://www.ntv.com.tr/turkiye/ornek-haber-1'));
      expect(item.category, equals('Türkiye'));
      expect(
        item.imageUrl,
        equals('https://images.ntv.com.tr/images/test.png'),
      );
      expect(item.createdAt, isPositive);
    });
  });

  group('RssNewsParser Tests', () {
    const sampleTrtRssXml = '''<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:media="http://search.yahoo.com/mrss/">
<channel>
<item>
<guid>https://www.trthaber.com/haber/1</guid>
<pubDate>Mon, 31 Aug 2026 21:34:00 +0300</pubDate>
<title>TRT Haber Örnek Başlık</title>
<description><![CDATA[<img src="https://trthaberstatic.cdn.wp.trt.com.tr/resimler/test.jpg"/>Örnek TRT Haber Açıklaması]]></description>
<enclosure url="https://trthaberstatic.cdn.wp.trt.com.tr/resimler/test.jpg" type="image/jpeg"/>
<link>https://www.trthaber.com/haber/1</link>
<category>Gündem</category>
</item>
</channel>
</rss>''';

    test('TRT RSS 2.0 XML başarıyla ayrıştırılmalı', () {
      final items = RssNewsParser.parse(
        sourceId: 'trt',
        sourceTitle: 'TRT Haber',
        xmlContent: sampleTrtRssXml,
      );

      expect(items.length, equals(1));
      final item = items.first;
      expect(item.sourceId, equals('trt'));
      expect(item.title, equals('TRT Haber Örnek Başlık'));
      expect(item.link, equals('https://www.trthaber.com/haber/1'));
      expect(
        item.imageUrl,
        equals('https://trthaberstatic.cdn.wp.trt.com.tr/resimler/test.jpg'),
      );
      expect(item.category, equals('Gündem'));
    });

    const sampleAhaberXml = '''<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
<channel>
<item>
<title><![CDATA[A Haber CDATA Başlık]]></title>
<link>https://www.ahaber.com.tr/haber/1</link>
<description><![CDATA[A Haber Açıklama Metni]]></description>
<category><![CDATA[Dünya]]></category>
<enclosure url="https://iaahbr.tmgrup.com.tr/test.jpeg" type="image/jpeg" />
<pubDate>Mon, 31 Aug 2026 23:00:24 +0300</pubDate>
</item>
</channel>
</rss>''';

    test('A Haber CDATA içeren XML başarıyla ayrıştırılmalı', () {
      final items = RssNewsParser.parse(
        sourceId: 'ahaber',
        sourceTitle: 'A Haber',
        xmlContent: sampleAhaberXml,
      );

      expect(items.length, equals(1));
      final item = items.first;
      expect(item.title, equals('A Haber CDATA Başlık'));
      expect(item.category, equals('Dünya'));
      expect(item.imageUrl, equals('https://iaahbr.tmgrup.com.tr/test.jpeg'));
    });

    const sampleCnnturkXml = '''<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
<channel>
<item>
<guid isPermaLink="true">6a95e733a8669cff9e1f8ae5</guid>
<link>https://www.cnnturk.com/turkiye/test-haber</link>
<title><![CDATA[CNN Türk Başlık]]></title>
<description><![CDATA[CNN Türk Açıklama]]></description>
<pubDate>Mon, 31 Aug 2026 23:43:20 GMT</pubDate>
<image>https://image.cnnturk.com/i/cnnturk/75/720x490/test.jpg</image>
</item>
</channel>
</rss>''';

    test('CNN Türk image etiketi başarıyla ayrıştırılmalı', () {
      final items = RssNewsParser.parse(
        sourceId: 'cnnturk',
        sourceTitle: 'CNN Türk',
        xmlContent: sampleCnnturkXml,
      );

      expect(items.length, equals(1));
      final item = items.first;
      expect(item.title, equals('CNN Türk Başlık'));
      expect(
        item.imageUrl,
        equals('https://image.cnnturk.com/i/cnnturk/75/720x490/test.jpg'),
      );
    });
  });

  group('BaseNewsParser Helper Tests', () {
    test('cleanHtml HTML etiketlerini ve özel karakterleri temizlemeli', () {
      const html = '<p>Örnek &quot;haber&quot; <b>metni</b> &amp; fazlası.</p>';
      final clean = BaseNewsParser.cleanHtml(html);
      expect(clean, equals('Örnek "haber" metni & fazlası.'));
    });

    test('extractImageFromHtml img etiketinden src çıkarmalı', () {
      const html =
          '<p>Metin <img src="https://example.com/photo.jpg" alt="test"/> devamı</p>';
      final src = BaseNewsParser.extractImageFromHtml(html);
      expect(src, equals('https://example.com/photo.jpg'));
    });
  });
}
