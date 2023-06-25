import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SpeedTestPage extends StatefulWidget {
  final String ipAddress;
  final String username;
  final String password;

  const SpeedTestPage({
    Key? key,
    required this.ipAddress,
    required this.username,
    required this.password,
  }) : super(key: key);

  @override
  _SpeedTestPageState createState() => _SpeedTestPageState();
}

class _SpeedTestPageState extends State<SpeedTestPage> {
  String speedTestStatus = '';

  Future<void> fetchSpeedTestStatus() async {
    final response =
        await http.get(Uri.parse('http://your-router-ip/api/speed-test'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        speedTestStatus = jsonResponse['status'];
      });
    } else {
      setState(() {
        speedTestStatus = 'Error retrieving speed test status';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSpeedTestStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Speed Test',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 350,
          height: 550,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.speed,
                size: 300,
              ),
              SizedBox(height: 2),
              Text(
                'Current Speed:\n$speedTestStatus',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: fetchSpeedTestStatus,
                child: Text('Refresh'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  fixedSize: MaterialStateProperty.all<Size>(
                    Size(200, 60), // Set the desired width and height
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
