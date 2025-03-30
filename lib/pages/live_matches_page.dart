import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/betting_model.dart';
import '../widgets/match_card.dart';

class LiveMatchesPage extends StatefulWidget {
  const LiveMatchesPage({Key? key}) : super(key: key);

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
      'score1': '275/