import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BettingModel extends ChangeNotifier {
  double _initialStake = 1000.0;
  double _initialOdds = 2.0;
  double _liveOdds = 1.5;
  String _selectedTeam = "Team A";
  String _selectedMatch = "Team A vs Team B";
  List<Map<String, dynamic>> _bettingHistory = [];

  // Getters
  double get initialStake => _initialStake;
  double get initialOdds => _initialOdds;
  double get liveOdds => _liveOdds;
  String get selectedTeam => _selectedTeam;
  String get selectedMatch => _selectedMatch;
  List<Map<String, dynamic>> get bettingHistory => _bettingHistory;

  // Setters
  void setInitialStake(double value) {
    _initialStake = value;
    notifyListeners();
  }

  void setInitialOdds(double value) {
    _initialOdds = value;
    notifyListeners();
  }

  void setLiveOdds(double value) {
    _liveOdds = value;
    notifyListeners();
  }

  void setSelectedTeam(String team) {
    _selectedTeam = team;
    notifyListeners();
  }

  void setSelectedMatch(String match) {
    _selectedMatch = match;
    notifyListeners();
  }

  // Calculate hedge bet amount
  double calculateHedgeBet() {
    return (_initialStake * _initialOdds) / _liveOdds;
  }

  // Calculate profit
  double calculateProfit() {
    double initialPotentialWin = _initialStake * _initialOdds - _initialStake;
    double hedgeBetAmount = calculateHedgeBet();
    return (_initialStake * _initialOdds) - _initialStake - hedgeBetAmount;
  }

  // Calculate ROI percentage
  double calculateROI() {
    double totalInvestment = _initialStake + calculateHedgeBet();
    return (calculateProfit() / totalInvestment) * 100;
  }

  // Add bet to history
  void addToHistory() {
    _bettingHistory.add({
      'date': DateTime.now().toString(),
      'match': _selectedMatch,
      'team': _selectedTeam,
      'initialStake': _initialStake,
      'initialOdds': _initialOdds,
      'liveOdds': _liveOdds,
      'hedgeBet': calculateHedgeBet(),
      'profit': calculateProfit(),
      'roi': calculateROI(),
    });
    notifyListeners();
    _saveHistory();
  }

  // Save history to local storage
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = jsonEncode(_bettingHistory);
    await prefs.setString('betting_history', historyJson);
  }

  // Load history from local storage
  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('betting_history');
    if (historyJson != null) {
      final List<dynamic> decodedList = jsonDecode(historyJson);
      _bettingHistory = decodedList.cast<Map<String, dynamic>>();
      notifyListeners();
    }
  }
}
