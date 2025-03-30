import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/betting_model.dart';

class HedgeCalculatorPage extends StatefulWidget {
  const HedgeCalculatorPage({Key? key}) : super(key: key);

  @override
  State<HedgeCalculatorPage> createState() => _HedgeCalculatorPageState();
}

class _HedgeCalculatorPageState extends State<HedgeCalculatorPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bettingModel = Provider.of<BettingModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Hedge Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pre-Match Bet Details',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Match',
                  border: OutlineInputBorder(),
                ),
                initialValue: bettingModel.selectedMatch,
                onChanged: (value) => bettingModel.setSelectedMatch(value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Selected Team',
                  border: OutlineInputBorder(),
                ),
                initialValue: bettingModel.selectedTeam,
                onChanged: (value) => bettingModel.setSelectedTeam(value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Initial Stake (₹)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                initialValue: bettingModel.initialStake.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a stake amount';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (double.tryParse(value) != null) {
                    bettingModel.setInitialStake(double.parse(value));
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Initial Odds',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                initialValue: bettingModel.initialOdds.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter odds';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 1) {
                    return 'Odds must be greater than 1';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (double.tryParse(value) != null) {
                    bettingModel.setInitialOdds(double.parse(value));
                  }
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Live Bet Details',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Live Odds (Opposite Outcome)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                initialValue: bettingModel.liveOdds.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter live odds';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 1) {
                    return 'Odds must be greater than 1';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (double.tryParse(value) != null) {
                    bettingModel.setLiveOdds(double.parse(value));
                  }
                },
              ),
              const SizedBox(height: 32),
              _buildResultsCard(context, bettingModel),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      bettingModel.addToHistory();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Bet saved to history')),
                      );
                    }
                  },
                  child: const Text('Save This Hedge Strategy'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsCard(BuildContext context, BettingModel model) {
    final hedgeBet = model.calculateHedgeBet();
    final profit = model.calculateProfit();
    final roi = model.calculateROI();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hedging Results',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildResultRow(
              context,
              'Recommended Hedge Bet:',
              '₹${hedgeBet.toStringAsFixed(2)}',
              profit > 0 ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 8),
            _buildResultRow(
              context,
              'Guaranteed Profit:',
              '₹${profit.toStringAsFixed(2)}',
              profit > 0 ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 8),
            _buildResultRow(
              context,
              'Return on Investment:',
              '${roi.toStringAsFixed(2)}%',
              roi > 0 ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 8),
            _buildResultRow(
              context,
              'Total Investment:',
              '₹${(model.initialStake + hedgeBet).toStringAsFixed(2)}',
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(
    BuildContext context,
    String label,
    String value,
    Color valueColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
