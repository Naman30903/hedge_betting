import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/betting_model.dart';
import '../widgets/match_card.dart';

class LiveMatchesPage extends StatefulWidget {
  const LiveMatchesPage({super.key});

  @override
  State<LiveMatchesPage> createState() => _LiveMatchesPageState();
}

class _LiveMatchesPageState extends State<LiveMatchesPage> {
  final List<Map<String, dynamic>> _mockLiveMatches = [
    {
      'id': '1',
      'league': 'IPL',
      'team1': 'Mumbai Indians',
      'team2': 'Chennai Super Kings',
      'score1': '120/3',
      'score2': '0/0',
      'overs': '15.2/20',
      'status': 'Mumbai Indians batting',
      'odds1': 1.65,
      'odds2': 2.35,
      'inPlay': true,
    },
    {
      'id': '2',
      'league': 'International',
      'team1': 'India',
      'team2': 'South Africa',
      'score1': '275/8',
      'score2': '112/3',
      'overs': '42.3/50',
      'status': 'South Africa batting',
      'odds1': 1.35,
      'odds2': 3.25,
      'inPlay': true,
    },
    {
      'id': '3',
      'league': 'Big Bash',
      'team1': 'Sydney Sixers',
      'team2': 'Melbourne Stars',
      'score1': '182/6',
      'score2': '0/0',
      'overs': '20/20',
      'status': 'Innings break',
      'odds1': 1.45,
      'odds2': 2.75,
      'inPlay': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Matches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh live match data
              setState(() {
                // In a real app, this would fetch updated data
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simulating network delay
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            // In a real app, this would fetch updated data
          });
        },
        child:
            _mockLiveMatches.isEmpty
                ? const Center(child: Text('No live matches available'))
                : ListView.builder(
                  itemCount: _mockLiveMatches.length,
                  itemBuilder: (context, index) {
                    final match = _mockLiveMatches[index];
                    return MatchCard(
                      matchData: match,
                      bettingModel: Provider.of<BettingModel>(context),
                      onTap: () {
                        // Navigate to match detail page
                        Navigator.pushNamed(
                          context,
                          '/match_details',
                          arguments: match['id'],
                        );
                      },
                      match: {},
                    );
                  },
                ),
      ),
    );
  }
}
