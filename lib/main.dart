import 'package:flutter/material.dart';
import 'package:flutter_medic/constants/universaltheme.dart';
import 'package:flutter_medic/screens/firstpage.dart';
import 'package:flutter_medic/screens/homepage.dart';
import 'package:flutter_medic/services/user_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isOnboardingDone = await UserPreferencesService.isOnboardingCompleted();

  runApp(
    ProviderScope(
      child: provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider(create: (context) => ThemeProvider()),
          provider.ChangeNotifierProvider(
            create: (context) => BottomTabState(),
          ),
        ],
        child: MyApp(isOnboardingDone: isOnboardingDone),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isOnboardingDone;
  const MyApp({super.key, this.isOnboardingDone = false});

  @override
  Widget build(BuildContext context) {
    return provider.Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          home: isOnboardingDone ? const Homepage() : const Firstpage(),
        );
      },
    );
  }
}
