import 'package:flutter/material.dart';
import 'package:mynetwork/screens/account.dart';
import 'package:mynetwork/screens/apppreference.dart';
import 'package:mynetwork/screens/legal.dart';

class Settings extends StatefulWidget {
  final String ipAddress;
  final String username;
  final String password;
  const Settings({
    Key? key,
    required this.ipAddress,
    required this.username,
    required this.password,
  });

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Settings',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          SettingsOption(
            icon: Icons.settings,
            title: 'App Preferences',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PreferencePage(),
                ),
              );
            },
          ),
          SizedBox(height: 16.0),
          SettingsOption(
            icon: Icons.account_circle,
            title: 'Account',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountSettingsPage(),
                ),
              );
            },
          ),
          SizedBox(height: 16.0),
          SettingsOption(
            icon: Icons.gavel,
            title: 'Legal',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LegalPage(),
                ),
              );
            },
          ),
          SizedBox(height: 16.0),
          SettingsOption(
            icon: Icons.feedback,
            title: 'Leave Us Feedback',
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => FeedbackPage(),
              //   ),
              // );
            },
          ),
        ],
      ),
    );
  }
}

class SettingsOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon),
              SizedBox(width: 16.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
