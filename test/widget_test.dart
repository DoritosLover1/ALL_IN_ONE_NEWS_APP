import 'package:flutter/material.dart';
import 'package:flutter_medic/constants/universaltheme.dart';
import 'package:flutter_medic/main.dart';
import 'package:flutter_medic/models/unified_news_item.dart';
import 'package:flutter_medic/screens/live_broadcasts_screen.dart';
import 'package:flutter_medic/screens/sync_loading_screen.dart';
import 'package:flutter_medic/widgets/news_detail_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart' as provider;
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class MockWebViewPlatform extends WebViewPlatform {
  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    return MockPlatformWebViewController(params);
  }

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) {
    return MockPlatformWebViewWidget(params);
  }

  @override
  PlatformWebViewCookieManager createPlatformCookieManager(
    PlatformWebViewCookieManagerCreationParams params,
  ) {
    return MockPlatformWebViewCookieManager(params);
  }

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) {
    return MockPlatformNavigationDelegate(params);
  }
}

class MockPlatformWebViewController extends PlatformWebViewController {
  MockPlatformWebViewController(super.params) : super.implementation();

  @override
  Future<void> loadRequest(LoadRequestParams params) async {}

  @override
  Future<void> loadHtmlString(String html, {String? baseUrl}) async {}

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> setBackgroundColor(Color color) async {}

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {}

  @override
  Future<void> setUserAgent(String? userAgent) async {}
}

class MockPlatformWebViewWidget extends PlatformWebViewWidget {
  MockPlatformWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(key: Key('mock_webview'));
  }
}

class MockPlatformWebViewCookieManager extends PlatformWebViewCookieManager {
  MockPlatformWebViewCookieManager(super.params) : super.implementation();
}

class MockPlatformNavigationDelegate extends PlatformNavigationDelegate {
  MockPlatformNavigationDelegate(super.params) : super.implementation();

  @override
  Future<void> setOnPageFinished(PageEventCallback onPageFinished) async {}

  @override
  Future<void> setOnPageStarted(PageEventCallback onPageStarted) async {}

  @override
  Future<void> setOnProgress(ProgressCallback onProgress) async {}

  @override
  Future<void> setOnWebResourceError(
    WebResourceErrorCallback onWebResourceError,
  ) async {}
}

void main() {
  setUpAll(() {
    WebViewPlatform.instance = MockWebViewPlatform();
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: provider.MultiProvider(
          providers: [
            provider.ChangeNotifierProvider(
              create: (context) => ThemeProvider(),
            ),
            provider.ChangeNotifierProvider(
              create: (context) => BottomTabState(),
            ),
          ],
          child: const MyApp(),
        ),
      ),
    );

    expect(find.text('SENİN HABERLERİN'), findsOneWidget);
  });

  testWidgets('SyncLoadingScreen renders progress and title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SyncLoadingScreen(
          selectedSourceIds: {'trt', 'ntv'},
          autoNavigate: false,
        ),
      ),
    );

    expect(find.text('Akışınız Kişiselleştiriliyor'), findsOneWidget);
    await tester.pumpWidget(Container());
  });

  testWidgets(
    'LiveBroadcastsScreen renders real embedded player and channels',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LiveBroadcastsScreen()));

      expect(find.text('Canlı Yayınlar'), findsOneWidget);
      expect(find.text('Tüm Canlı Kanallar'), findsOneWidget);
      expect(find.text('TRT Haber'), findsWidgets);
    },
  );

  testWidgets('NewsDetailModal renders header and source information', (
    WidgetTester tester,
  ) async {
    final sampleNews = UnifiedNewsItem(
      sourceId: 'trt',
      sourceTitle: 'TRT Haber',
      sourceBadgeText: 'TRT',
      sourceBadgeColor: Colors.blue,
      title: 'Örnek Haber Başlığı Testi',
      link: 'https://www.trthaber.com/haber/1',
      description: 'Haber açıklaması detay metni',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: NewsDetailModal(newsItem: sampleNews)),
      ),
    );

    expect(find.text('TRT Haber'), findsOneWidget);
    expect(find.text('https://www.trthaber.com/haber/1'), findsOneWidget);
  });
}
