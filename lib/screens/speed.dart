// ignore_for_file: prefer_const_constructors, sort_child_properties_last

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
  String downloadspeed = '';
  String uploadspeed = '';
  var d;
  var dr;
  var u;
  var ur;

  @override
  void initState() {
    super.initState();
    fetchSpeedTestStatus();
  }

  Future<void> fetchSpeedTestStatus() async {
    final response = await http.get(
      Uri.parse('http://${widget.ipAddress}/rest/interface/ethernet'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        downloadspeed = jsonResponse[0]['rx-bytes'] ?? 'N/A';
        uploadspeed = jsonResponse[0]['tx-bytes'] ?? 'N/A';
        d = int.tryParse(downloadspeed);
        dr = d ~/ 1000;
        u = int.tryParse(uploadspeed);
        ur = u ~/ 1000;
      });
    } else {
      final snackBar = SnackBar(
          content: Text('Error: ${response.statusCode}  ${response.body}'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  int parseSpeedString(String speedString) {
    int speed = 0;
    try {
      speed = int.tryParse(speedString) ?? 0;
    } catch (e) {
      print('Error parsing speed string: $e');
    }
    return speed ~/ 1000000; // Divide by 1000000 to get the speed in Mbps
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
                'Current Speed:\n$dr Mbps - $ur Mbps',
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
