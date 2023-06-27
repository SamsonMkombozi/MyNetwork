// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RouterPage extends StatefulWidget {
  final String ipAddress;
  final String username;
  final String password;
  const RouterPage({
    Key? key,
    required this.ipAddress,
    required this.username,
    required this.password,
  }) : super(key: key);
  @override
  _RouterPageState createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {
  String routerName = '';
  String routerOsVersion = '';
  String uploadSpeed = '';
  String downloadSpeed = '';

  @override
  void initState() {
    super.initState();
    fetchData();
    upgradeRouterOs();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('http://${widget.ipAddress}/rest/system/resource'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        routerName = data['architecture-name'];
        routerOsVersion = data['version'];
      });
    } else {
      print('failed');
    }
  }

  Future<void> upgradeRouterOs() async {
    // Make HTTP request to upgrade router OS
    final response = await http.get(
      Uri.parse('http://${widget.ipAddress}/rest/interface/ethernet'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        downloadSpeed = data[0]['rx-bytes'] ?? 'N/A';
        uploadSpeed = data[0]['tx-bytes'] ?? 'N/A';
      });
    } else {
      final snackBar = SnackBar(
          content: Text('Error: ${response.statusCode}  ${response.body}'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    // Add any additional logic or error handling here
  }

  Future<void> rebootRouter() async {
    // Make HTTP request to reboot router
    // Replace <API_ENDPOINT> with your Mikrotik API endpoint
    final response = await http.post(
      Uri.parse('http://${widget.ipAddress}/rest/system/reboot'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
      },
    );

    if (response.statusCode == 200) {
      print('Reboot request successful');
    } else {
      print('Failed to send reboot request');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    // Add any additional logic or error handling here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Container(
          width: 300.0,
          height: 300.0,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Mikrotik Router "$routerName"',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'RouterOS Version $routerOsVersion',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 23,
              ),
              SizedBox(
                child: Row(children: [
                  const SizedBox(
                    width: 30,
                  ),
                  Text('Upload Speed\n $uploadSpeed'),
                  const SizedBox(
                    width: 40,
                  ),
                  Text('Download Speed\n $downloadSpeed'),
                ]),
              ),
              const SizedBox(
                height: 63,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.upgrade,
                      size: 73,
                      weight: 600,
                    ),
                    onPressed: upgradeRouterOs,
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.restart_alt,
                      size: 73,
                      weight: 600,
                    ),
                    onPressed: rebootRouter,
                  ),
                  SizedBox(
                    width: 50,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
