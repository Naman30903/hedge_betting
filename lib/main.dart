import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/betting_model.dart';
import 'pages/home_page.dart';
import 'pages/calculator_page.dart';
import 'pages/upcoming_matches_page.dart';
import 'pages/live_matches_page.dart';
import 'pages/profile_page.dart';
import 'pages/history_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BettingModel(),
      child: const SportsBettingApp(),
    ),
  );
}

class SportsBettingApp extends StatelessWidget {
  const SportsBettingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BetHedge Pro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
          secondary: Colors.orange,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
          secondary: Colors.orange,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
      routes: {
        '/calculator': (context) => const HedgeCalculatorPage(),
        '/matches': (context) => const UpcomingMatchesPage(),
        '/live': (context) => const LiveMatchesPage(),
        '/profile': (context) => const ProfilePage(),
        '/history': (context) => const BettingHistoryPage(),
      },
    );
  }
}
