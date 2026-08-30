import 'package:flutter/material.dart';
import 'package:flutter_medic/constants/universaltheme.dart';
import 'package:flutter_medic/screens/firstpage.dart';
import 'package:flutter_medic/screens/homepage.dart';
import 'package:provider/provider.dart' as provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider(create: (context) => ThemeProvider()),
          provider.ChangeNotifierProvider(
            create: (context) => BottomTabState(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return provider.Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          home: Firstpage(),
        );
      },
    );
  }
}
