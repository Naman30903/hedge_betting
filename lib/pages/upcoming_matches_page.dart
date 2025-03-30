import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/betting_model.dart';
import '../widgets/match_card.dart';

class UpcomingMatchesPage extends StatefulWidget {
  const UpcomingMatchesPage({Key? key}) : super(key: key);

  @override
  State<UpcomingMatchesPage> createState() => _UpcomingMatchesPageState();
}

class _UpcomingMatchesPageState extends State<UpcomingMatchesPage> {
  final List<Map<String, dynamic>> _mockMatches = [
    {
      'id': '1',
      'league': 'IPL',
      'team1': 'Mumbai Indians',
      'team2': 'Chennai Super Kings',
      'time': DateTime.now().add(const Duration(days: 1)),
      'odds1': 2.10,
      'odds2': 1.85,
    },
    {
      'id': '2',
      'league': 'IPL',
      'team1': 'Royal Challengers Bangalore',
      'team2': 'Kolkata Knight Riders',
      'time': DateTime.now().add(const Duration(days: 2)),
      'odds1': 1.95,
      'odds2': 1.95,
    },
    {
      'id': '3',
      'league': 'IPL',
      'team1': 'Delhi Capitals',
      'team2': 'Rajasthan Royals',
      'time': DateTime.now().add(const Duration(days: 3)),
      'odds1': 2.25,
      'odds2': 1.75,
    },
    {
      'id': '4',
      'league': 'International',
      'team1': 'India',
      'team2': 'Australia',
      'time': DateTime.now().add(const Duration(days: 5)),
      'odds1': 1.80,
      'odds2': 2.10,
    },
    {
      'id': '5',
      'league': 'International',
      'team1': 'England',
      'team2': 'Pakistan',
      'time': DateTime.now().add(const Duration(days: 7)),
      'odds1': 1.90,
      'odds2': 2.00,
    },
  ];

  String _selectedFilter = 'All';

  List<Map<String, dynamic>> get filteredMatches {
    if (_selectedFilter == 'All') {
      return _mockMatches;
    } else {
      return _mockMatches
          .where((match) => match['league'] == _selectedFilter)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bettingModel = Provider.of<BettingModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Upcoming Matches')),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMatches.length,
              itemBuilder: (context, index) {
                final match = filteredMatches[index];
                return MatchCard(
                  match: match,
                  bettingModel: bettingModel,
                  isLive: false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            _buildFilterChip('All'),
            const SizedBox(width: 8),
            _buildFilterChip('IPL'),
            const SizedBox(width: 8),
            _buildFilterChip('International'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(label),
      selected: _selectedFilter == label,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
    );
  }
}
