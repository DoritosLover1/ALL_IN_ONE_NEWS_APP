import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_medic/constants/universaltheme.dart';
import 'package:flutter_medic/screens/firstpage.dart';
import 'package:flutter_medic/screens/homepage.dart';
import 'package:flutter_medic/services/database_service.dart';
import 'package:flutter_medic/services/news_sync_service.dart';
import 'package:flutter_medic/services/user_preferences_service.dart';

class SplashScreen extends StatefulWidget {
  final bool autoNavigate;

  const SplashScreen({super.key, this.autoNavigate = true});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  String _statusText = 'Haber akışınız hazırlanıyor...';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeIn));

    _animController.forward();
    if (widget.autoNavigate) {
      _initializeAndPreload();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _initializeAndPreload() async {
    final stopwatch = Stopwatch()..start();

    try {
      if (!DatabaseService.instance.isInitialized) {
        await DatabaseService.instance.initialize();
      }

      final isOnboardingDone =
          await UserPreferencesService.isOnboardingCompleted();

      if (isOnboardingDone) {
        final selectedSources =
            await UserPreferencesService.getSelectedSources();
        if (selectedSources.isNotEmpty) {
          if (mounted) {
            setState(() {
              _statusText = 'Son dakika haberleri yükleniyor...';
            });
          }
          await NewsSyncService.instance
              .syncSelectedSources(selectedSources)
              .timeout(const Duration(seconds: 4), onTimeout: () {});
        }
      }

      final elapsed = stopwatch.elapsedMilliseconds;
      const minDisplayMs = 1500;
      if (elapsed < minDisplayMs) {
        await Future.delayed(Duration(milliseconds: minDisplayMs - elapsed));
      }

      if (!mounted) return;

      final targetScreen = isOnboardingDone
          ? const Homepage()
          : const Firstpage();

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Firstpage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.darkRed.withValues(alpha: 0.12),
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.darkRed],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withValues(alpha: 0.35),
                                blurRadius: 28,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.newspaper_rounded,
                            size: 46,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
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
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _statusText,
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 36),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'v1.0.0',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
