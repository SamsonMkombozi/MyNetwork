import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TroubleshootingPage extends StatefulWidget {
  final String ipAddress;
  final String username;
  final String password;

  const TroubleshootingPage({
    Key? key,
    required this.ipAddress,
    required this.username,
    required this.password,
  }) : super(key: key);

  @override
  _TroubleshootingPageState createState() => _TroubleshootingPageState();
}

class _TroubleshootingPageState extends State<TroubleshootingPage> {
  String networkStatus = '';

  Future<void> analyzeNetwork() async {
    final response =
        await http.get(Uri.parse('http://your-router-ip/api/network-analysis'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        networkStatus = jsonResponse['status'];
      });
    } else {
      setState(() {
        networkStatus = 'Error analyzing network';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network Troubleshooting'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: analyzeNetwork,
              child: Text('Analyze Network'),
            ),
            SizedBox(height: 20),
            Text(
              'Network Status: $networkStatus',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
