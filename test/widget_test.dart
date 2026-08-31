import 'package:flutter/material.dart';
import 'package:flutter_medic/constants/universaltheme.dart';
import 'package:flutter_medic/main.dart';
import 'package:flutter_medic/screens/live_broadcasts_screen.dart';
import 'package:flutter_medic/screens/sync_loading_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart' as provider;

void main() {
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

  testWidgets('LiveBroadcastsScreen renders embedded player and channels', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LiveBroadcastsScreen()));

    expect(find.text('Canlı Yayınlar'), findsOneWidget);
    expect(find.text('Tüm Canlı Kanallar'), findsOneWidget);
    expect(find.text('TRT Haber'), findsWidgets);
  });
}
