import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_medic/constants/universaltheme.dart';
import 'package:flutter_medic/controllers/news_feed_controller.dart';
import 'package:flutter_medic/screens/firstpage.dart';
import 'package:flutter_medic/screens/homepage.dart';
import 'package:flutter_medic/services/database_service.dart';
import 'package:flutter_medic/services/news_sync_service.dart';
import 'package:flutter_medic/services/user_preferences_service.dart';

const _panelAssets = [
  'assets/logos/haberturk.png',
  'assets/logos/cnnturk.png',
  'assets/logos/trt.png',
  'assets/logos/ntv.jpg',
  'assets/logos/ahaber.jpeg',
  'assets/logos/sozcu.png',
];

class SplashScreen extends StatefulWidget {
  final bool autoNavigate;
  const SplashScreen({super.key, this.autoNavigate = true});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  late AnimationController _progressCtrl;

  bool _isOnboardingDone = false;
  NewsFeedController? _preloadedController;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fadeCtrl.forward();

    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _progressCtrl.forward();

    if (widget.autoNavigate) _initializeAndNavigate();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  Future<void> _initializeAndNavigate() async {
    final sw = Stopwatch()..start();

    try {
      if (!DatabaseService.instance.isInitialized) {
        await DatabaseService.instance.initialize();
      }

      _isOnboardingDone = await UserPreferencesService.isOnboardingCompleted();

      if (_isOnboardingDone) {
        final sources = await UserPreferencesService.getSelectedSources();
        if (sources.isNotEmpty) {
          await NewsSyncService.instance
              .syncSelectedSources(sources)
              .timeout(const Duration(seconds: 5), onTimeout: () {});

          final feedItems =
              await DatabaseService.instance.getCombinedNewsFeed(sources);
          final savedItems =
              await DatabaseService.instance.getAllFavoriteItems();

          _preloadedController = NewsFeedController.preloaded(
            feedItems: feedItems.isNotEmpty
                ? [
                    feedItems[0].copyWith(isBreaking: true),
                    ...feedItems.sublist(1),
                  ]
                : feedItems,
            savedItems: savedItems,
            selectedSourceIds: sources,
          );
        }
      }

      // En az 2.5 sn göster
      final elapsed = sw.elapsedMilliseconds;
      if (elapsed < 2500) {
        await Future.delayed(Duration(milliseconds: 2500 - elapsed));
      }
    } catch (e) {
      debugPrint('Splash Screen Error: $e');
      // Do NOT reset _isOnboardingDone here, otherwise offline users or minor errors
      // will force them to re-select sources!
    }

    if (!mounted) return;
    _navigate();
  }

  void _navigate() {
    final target = _isOnboardingDone
        ? Homepage(preloadedController: _preloadedController)
        : const Firstpage();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1200),
        pageBuilder: (_, _, _) => target,
        transitionsBuilder: (_, anim, _, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Arka plan: 2×3 görsel kolaj ──────────────────
            _buildCollage(),

            // ── Koyu gradyan overlay ──────────────────────────
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.55),
                    Colors.black.withValues(alpha: 0.82),
                    Colors.black.withValues(alpha: 0.92),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // ── Ortadaki içerik ───────────────────────────────
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Başlık
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.darkRed,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'HABER MERKEZİ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Yükleme metni
                  const Text(
                    'Haberler yükleniyor...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      height: 1.6,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Spinner -> Bar
                  SizedBox(
                    width: 200,
                    height: 6,
                    child: AnimatedBuilder(
                      animation: _progressCtrl,
                      builder: (context, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: _progressCtrl.value,
                            backgroundColor: Colors.white.withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary.withValues(alpha: 0.85),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ── Sürüm numarası ────────────────────────────────
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'v1.0.0',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.25),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollage() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              _panelTile(_panelAssets[0]),
              _panelTile(_panelAssets[1]),
              _panelTile(_panelAssets[2]),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _panelTile(_panelAssets[3]),
              _panelTile(_panelAssets[4]),
              _panelTile(_panelAssets[5]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _panelTile(String asset) {
    return Expanded(
      child: Image.asset(
        asset,
        fit: BoxFit.cover,
        height: double.infinity,
      ),
    );
  }
}
