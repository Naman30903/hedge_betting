import 'package:flutter/material.dart';
import '../models/betting_model.dart';

class MatchCard extends StatelessWidget {
  final Map<String, dynamic> match;
  final BettingModel bettingModel;
  final bool isLive;

  const MatchCard({
    super.key,
    required this.match,
    required this.bettingModel,
    this.isLive = false,
    required Map<String, dynamic> matchData,
    required Null Function() onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    match['league'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isLive && match['inPlay'] == true) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                if (isLive)
                  Text(
                    match['overs'],
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                else
                  Text(
                    '${_formatDate(match['time'])} | ${_formatTime(match['time'])}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        match['team1'],
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (isLive) ...[
                        const SizedBox(height: 4),
                        Text(
                          match['score1'],
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed:
                            isLive && match['inPlay'] != true
                                ? null
                                : () => _selectTeam(
                                  context,
                                  match['team1'],
                                  match['odds1'],
                                ),
                        child: Text('${match['odds1']}'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'VS',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        match['team2'],
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.right,
                      ),
                      if (isLive) ...[
                        const SizedBox(height: 4),
                        Text(
                          match['score2'],
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.right,
                        ),
                      ],
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed:
                            isLive && match['inPlay'] != true
                                ? null
                                : () => _selectTeam(
                                  context,
                                  match['team2'],
                                  match['odds2'],
                                ),
                        child: Text('${match['odds2']}'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isLive) ...[
              const SizedBox(height: 8),
              Text(
                match['status'],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: match['inPlay'] ? Colors.green : Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _selectTeam(BuildContext context, String team, double odds) {
    if (isLive) {
      // If user selects the opposite team from their pre-match bet, this is a hedge
      if (team != bettingModel.selectedTeam) {
        bettingModel.setLiveOdds(odds);
        Navigator.pushNamed(context, '/calculator');
      } else {
        // If user selects the same team, show an explanation
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Hedging Requires Opposite Outcome'),
              content: Text(
                'For hedging to work, you need to bet on the opposite outcome of your pre-match bet. '
                'You previously bet on $team in this match.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Understood'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Pre-match selection
      bettingModel.setSelectedMatch('${match['team1']} vs ${match['team2']}');
      bettingModel.setSelectedTeam(team);
      bettingModel.setInitialOdds(odds);
      Navigator.pushNamed(context, '/calculator');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
