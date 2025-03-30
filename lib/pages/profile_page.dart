import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // User profile data
  String _username = '';
  String _email = '';
  double _totalBalance = 0.0;
  List<String> _favoriteLeagues = ['IPL', 'International'];
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    // In a real app, this would load from a database or API
    // For demo purposes, we're using shared preferences
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _username = prefs.getString('username') ?? 'BetHedger123';
      _email = prefs.getString('email') ?? 'user@example.com';
      _totalBalance = prefs.getDouble('balance') ?? 1000.0;
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _darkModeEnabled = prefs.getBool('darkMode') ?? false;

      _usernameController.text = _username;
      _emailController.text = _email;
      _balanceController.text = _totalBalance.toString();
    });
  }

  Future<void> _saveUserProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _username = _usernameController.text;
      _email = _emailController.text;
      _totalBalance = double.tryParse(_balanceController.text) ?? _totalBalance;
    });

    await prefs.setString('username', _username);
    await prefs.setString('email', _email);
    await prefs.setDouble('balance', _totalBalance);
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setBool('darkMode', _darkModeEnabled);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveUserProfile,
            tooltip: 'Save changes',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _buildPersonalInfoSection(),
              const SizedBox(height: 24),
              _buildPreferencesSection(),
              const SizedBox(height: 24),
              _buildBettingStatsSection(),
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              _username.isNotEmpty ? _username[0].toUpperCase() : 'U',
              style: const TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(_username, style: Theme.of(context).textTheme.headlineSmall),
          Text(
            'Balance: \$${_totalBalance.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _balanceController,
              decoration: const InputDecoration(
                labelText: 'Balance',
                prefixIcon: Icon(Icons.account_balance_wallet),
                border: OutlineInputBorder(),
                prefixText: '\$ ',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a balance amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Preferences', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: const Text(
                'Get alerts for match updates and odds changes',
              ),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Toggle between light and dark theme'),
              value: _darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Favorite Leagues',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildLeagueChip('IPL'),
                _buildLeagueChip('International'),
                _buildLeagueChip('Big Bash'),
                _buildLeagueChip('T20 Blast'),
                _buildAddLeagueChip(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeagueChip(String league) {
    final isSelected = _favoriteLeagues.contains(league);

    return FilterChip(
      label: Text(league),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _favoriteLeagues.add(league);
          } else {
            _favoriteLeagues.remove(league);
          }
        });
      },
    );
  }

  Widget _buildAddLeagueChip() {
    return ActionChip(
      avatar: const Icon(Icons.add),
      label: const Text('Add League'),
      onPressed: () {
        // Show dialog to add custom league
        showDialog(
          context: context,
          builder: (context) => _buildAddLeagueDialog(),
        );
      },
    );
  }

  Widget _buildAddLeagueDialog() {
    final textController = TextEditingController();

    return AlertDialog(
      title: const Text('Add Custom League'),
      content: TextField(
        controller: textController,
        decoration: const InputDecoration(
          labelText: 'League Name',
          hintText: 'Enter league name',
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            final leagueName = textController.text.trim();
            if (leagueName.isNotEmpty) {
              setState(() {
                _favoriteLeagues.add(leagueName);
              });
            }
            Navigator.pop(context);
          },
          child: const Text('ADD'),
        ),
      ],
    );
  }

  Widget _buildBettingStatsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Betting Statistics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildStatRow('Total Bets Placed', '42'),
            _buildStatRow('Successful Hedges', '28'),
            _buildStatRow('Win Rate', '66.7%'),
            _buildStatRow('Profit/Loss', '+\$287.50'),
            _buildStatRow('ROI', '+14.4%'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: value.contains('+') ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.history),
          label: const Text('View Betting History'),
          onPressed: () {
            Navigator.pushNamed(context, '/history');
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          onPressed: () {
            // Show confirmation dialog
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text('Logout Confirmation'),
                    content: const Text(
                      'Are you sure you want to log out of your account?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CANCEL'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Implement logout functionality
                          Navigator.pop(context);
                          // In a real app, this would clear session data and navigate to login
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Logged out successfully'),
                            ),
                          );
                        },
                        child: const Text('LOGOUT'),
                      ),
                    ],
                  ),
            );
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}
