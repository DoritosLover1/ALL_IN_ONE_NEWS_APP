import 'package:flutter/material.dart';
import 'package:flutter_medic/controllers/news_feed_controller.dart';
import 'package:flutter_medic/screens/live_broadcasts_screen.dart';
import 'package:flutter_medic/screens/news_feed_view.dart';
import 'package:flutter_medic/screens/saved_news_screen.dart';
import 'package:flutter_medic/widgets/home/custom_bottom_navbar.dart';

class Homepage extends StatefulWidget {
  /// Splash ekranından önceden hazırlanmış controller.
  /// Verilmezse Homepage kendi controller'ını oluşturur.
  final NewsFeedController? preloadedController;

  const Homepage({super.key, this.preloadedController});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late final NewsFeedController _feedController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    // Splash'tan gelen hazır controller varsa kullan, yoksa sıfırdan başlat
    _feedController = widget.preloadedController ?? NewsFeedController();
  }

  @override
  void dispose() {
    _feedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _feedController,
      builder: (context, child) {
        return Scaffold(
          body: IndexedStack(
            index: _currentTabIndex,
            children: [
              NewsFeedView(controller: _feedController),
              LiveBroadcastsScreen(
                isTabActive: _currentTabIndex == 1,
                selectedSourceIds: _feedController.selectedSourceIds,
              ),
              SavedNewsScreen(controller: _feedController),
            ],
          ),
          bottomNavigationBar: CustomBottomNavbar(
            currentIndex: _currentTabIndex,
            onTap: (index) {
              setState(() {
                _currentTabIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}
