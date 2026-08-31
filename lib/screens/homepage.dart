import 'package:flutter/material.dart';
import 'package:flutter_medic/controllers/news_feed_controller.dart';
import 'package:flutter_medic/screens/live_broadcasts_screen.dart';
import 'package:flutter_medic/screens/news_feed_view.dart';
import 'package:flutter_medic/screens/saved_news_screen.dart';
import 'package:flutter_medic/widgets/home/custom_bottom_navbar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final NewsFeedController _feedController = NewsFeedController();
  int _currentTabIndex = 0;

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
