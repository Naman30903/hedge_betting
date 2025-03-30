import 'package:flutter/material.dart';
import '../widgets/feature_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BetHedge Pro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Welcome to BetHedge Pro',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Secure guaranteed profits by hedging your pre-match bets with live bets',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 30),
            FeatureCard(
              title: 'Hedge Calculator',
              description:
                  'Calculate the perfect hedge bet amount to guarantee profit',
              icon: Icons.calculate,
              onTap: () => Navigator.pushNamed(context, '/calculator'),
            ),
            const SizedBox(height: 16),
            FeatureCard(
              title: 'Upcoming Matches',
              description: 'Browse upcoming matches with competitive odds',
              icon: Icons.sports_cricket,
              onTap: () => Navigator.pushNamed(context, '/matches'),
            ),
            const SizedBox(height: 16),
            FeatureCard(
              title: 'Live Betting',
              description: 'Place live bets to hedge your pre-match positions',
              icon: Icons.timer,
              onTap: () => Navigator.pushNamed(context, '/live'),
            ),
            const SizedBox(height: 16),
            FeatureCard(
              title: 'Betting History',
              description: 'View your past hedging strategies and profits',
              icon: Icons.history,
              onTap: () => Navigator.pushNamed(context, '/history'),
            ),
          ],
        ),
      ),
    );
  }
}
