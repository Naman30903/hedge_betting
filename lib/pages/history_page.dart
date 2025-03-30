import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BettingHistoryPage extends StatefulWidget {
  const BettingHistoryPage({super.key});

  @override
  State<BettingHistoryPage> createState() => _BettingHistoryPageState();
}

class _BettingHistoryPageState extends State<BettingHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  final DateFormat _timeFormat = DateFormat('HH:mm');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Mock betting history data
  final List<Map<String, dynamic>> _bettingHistory = [
    {
      'id': '1',
      'match': 'Mumbai Indians vs Chennai Super Kings',
      'league': 'IPL',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'initialBet': {'team': 'Mumbai Indians', 'amount': 100.0, 'odds': 2.1},
      'hedgeBet': {'team': 'Chennai Super Kings', 'amount': 130.0, 'odds': 1.7},
      'outcome': 'hedge_success',
      'profitLoss': 21.0,
      'status': 'completed',
    },
    {
      'id': '2',
      'match': 'India vs South Africa',
      'league': 'International',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'initialBet': {'team': 'India', 'amount': 150.0, 'odds': 1.8},
      'hedgeBet': {'team': 'South Africa', 'amount': 200.0, 'odds': 1.4},
      'outcome': 'hedge_success',
      'profitLoss': 30.0,
      'status': 'completed',
    },
    {
      'id': '3',
      'match': 'Royal Challengers Bangalore vs Kolkata Knight Riders',
      'league': 'IPL',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'initialBet': {
        'team': 'Royal Challengers Bangalore',
        'amount': 120.0,
        'odds': 1.9,
      },
      'outcome': 'lost',
      'profitLoss': -120.0,
      'status': 'completed',
    },
    {
      'id': '4',
      'match': 'England vs Pakistan',
      'league': 'International',
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'initialBet': {'team': 'England', 'amount': 100.0, 'odds': 1.75},
      'outcome': 'won',
      'profitLoss': 75.0,
      'status': 'completed',
    },
    {
      'id': '5',
      'match': 'Delhi Capitals vs Rajasthan Royals',
      'league': 'IPL',
      'date': DateTime.now().subtract(const Duration(hours: 3)),
      'initialBet': {'team': 'Delhi Capitals', 'amount': 80.0, 'odds': 2.2},
      'status': 'in_progress',
    },
  ];

  List<Map<String, dynamic>> get filteredHistory {
    List<Map<String, dynamic>> result = _bettingHistory;

    // Filter by status based on tab
    if (_tabController.index == 1) {
      // Completed bets
      result = result.where((bet) => bet['status'] == 'completed').toList();
    } else if (_tabController.index == 2) {
      // Active bets
      result = result.where((bet) => bet['status'] == 'in_progress').toList();
    }

    // Further filter by league if not "All"
    if (_selectedFilter != 'All') {
      result = result.where((bet) => bet['league'] == _selectedFilter).toList();
    }

    // Sort by date, newest first
    result.sort((a, b) => b['date'].compareTo(a['date']));

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Betting History'),
        bottom: TabBar(
          controller: _tabController,
          onTap: (_) {
            setState(() {});
          },
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Completed'),
            Tab(text: 'In Progress'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child:
                filteredHistory.isEmpty
                    ? _buildEmptyState()
                    : _buildHistoryList(),
          ),
          _buildSummaryCard(),
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
            const SizedBox(width: 8),
            _buildFilterChip('Big Bash'),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 72, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No betting history found',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Your past bets will appear here',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      itemCount: filteredHistory.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        final bet = filteredHistory[index];
        return _buildBetCard(bet);
      },
    );
  }

  Widget _buildBetCard(Map<String, dynamic> bet) {
    final bool isHedged = bet.containsKey('hedgeBet');
    final bool isCompleted = bet['status'] == 'completed';
    final bool isWon =
        isCompleted &&
        (bet['outcome'] == 'won' || bet['outcome'] == 'hedge_success');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: InkWell(
        onTap: () {
          _showBetDetails(bet);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      bet['match'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(bet),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(bet['league']),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${_dateFormat.format(bet['date'])} - ${_timeFormat.format(bet['date'])}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Initial Bet',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${bet['initialBet']['team']}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '\$${bet['initialBet']['amount'].toStringAsFixed(2)} @ ${bet['initialBet']['odds'].toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  if (isHedged)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hedge Bet',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${bet['hedgeBet']['team']}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '\$${bet['hedgeBet']['amount'].toStringAsFixed(2)} @ ${bet['hedgeBet']['odds'].toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  if (isCompleted)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isWon ? Colors.green[50] : Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isWon
                            ? '+\$${bet['profitLoss'].toStringAsFixed(2)}'
                            : '-\$${bet['profitLoss'].abs().toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isWon ? Colors.green[700] : Colors.red[700],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(Map<String, dynamic> bet) {
    Color chipColor;
    String label;
    IconData icon;

    if (bet['status'] == 'in_progress') {
      chipColor = Colors.blue;
      label = 'In Progress';
      icon = Icons.timer;
    } else if (bet['outcome'] == 'won' || bet['outcome'] == 'hedge_success') {
      chipColor = Colors.green;
      label = bet['outcome'] == 'hedge_success' ? 'Hedge Success' : 'Won';
      icon = Icons.check_circle;
    } else {
      chipColor = Colors.red;
      label = 'Lost';
      icon = Icons.cancel;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: chipColor.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: chipColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: chipColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showBetDetails(Map<String, dynamic> bet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bet Details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                bet['match'],
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${bet['league']} - ${_dateFormat.format(bet['date'])}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              _buildDetailSection('Initial Bet', [
                'Team: ${bet['initialBet']['team']}',
                'Amount: \$${bet['initialBet']['amount'].toStringAsFixed(2)}',
                'Odds: ${bet['initialBet']['odds'].toStringAsFixed(2)}',
                'Potential Return: \$${(bet['initialBet']['amount'] * bet['initialBet']['odds']).toStringAsFixed(2)}',
              ]),
              if (bet.containsKey('hedgeBet')) ...[
                const SizedBox(height: 16),
                _buildDetailSection('Hedge Bet', [
                  'Team: ${bet['hedgeBet']['team']}',
                  'Amount: \$${bet['hedgeBet']['amount'].toStringAsFixed(2)}',
                  'Odds: ${bet['hedgeBet']['odds'].toStringAsFixed(2)}',
                  'Potential Return: \$${(bet['hedgeBet']['amount'] * bet['hedgeBet']['odds']).toStringAsFixed(2)}',
                ]),
              ],
              if (bet['status'] == 'completed') ...[
                const SizedBox(height: 16),
                _buildDetailSection('Outcome', [
                  'Result: ${bet['outcome'] == 'won'
                      ? 'Win'
                      : bet['outcome'] == 'hedge_success'
                      ? 'Hedge Success'
                      : 'Loss'}',
                  'Profit/Loss: ${bet['profitLoss'] >= 0 ? '+' : ''}\$${bet['profitLoss'].toStringAsFixed(2)}',
                  'ROI: ${(bet['profitLoss'] / bet['initialBet']['amount'] * 100).toStringAsFixed(2)}%',
                ]),
              ],
              const SizedBox(height: 20),
              if (bet['status'] == 'in_progress')
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/live_matches');
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Check Match Status'),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailSection(String title, List<String> details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        ...details.map(
          (detail) => Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(detail),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    // Calculate summary stats
    final completedBets =
        _bettingHistory.where((bet) => bet['status'] == 'completed').toList();
    final totalBets = completedBets.length;

    final wonBets =
        completedBets
            .where(
              (bet) =>
                  bet['outcome'] == 'won' || bet['outcome'] == 'hedge_success',
            )
            .length;

    final winRate = totalBets > 0 ? (wonBets / totalBets * 100) : 0;

    final totalProfit = completedBets.fold<double>(
      0,
      (sum, bet) => sum + (bet['profitLoss'] as double),
    );

    final totalStaked = completedBets.fold<double>(
      0,
      (sum, bet) => sum + (bet['initialBet']['amount'] as double),
    );

    final roi = totalStaked > 0 ? (totalProfit / totalStaked * 100) : 0;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Betting Summary',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildSummaryItem('Total Bets', '$totalBets', Icons.analytics),
                _buildSummaryItem(
                  'Win Rate',
                  '${winRate.toStringAsFixed(1)}%',
                  Icons.trending_up,
                ),
                _buildSummaryItem(
                  'Profit/Loss',
                  '${totalProfit >= 0 ? '+' : ''}\$${totalProfit.toStringAsFixed(2)}',
                  Icons.account_balance_wallet,
                  valueColor: totalProfit >= 0 ? Colors.green : Colors.red,
                ),
                _buildSummaryItem(
                  'ROI',
                  '${roi.toStringAsFixed(1)}%',
                  Icons.pie_chart,
                  valueColor: roi >= 0 ? Colors.green : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
