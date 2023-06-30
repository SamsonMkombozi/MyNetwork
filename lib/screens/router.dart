// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mynetwork/screens/dashview.dart';

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
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Dashview(
                  ipAddress: widget.ipAddress,
                  username: widget.username,
                  password: widget.password,
                )),
      );
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
          width: 350.0,
          height: 412.0,
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
              SizedBox(
                height: 10,
              ),
              Text(
                'Mikrotik Router',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                '-$routerName-',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'RouterOS Version',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                '-$routerOsVersion-',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 23,
              ),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  shape: BoxShape
                      .rectangle, // Set the shape to circle for IconButton with circular border
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_upward,
                            size: 35,
                            weight: 600,
                          ),
                          Text(
                            'Upload Speed',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            ' $uploadSpeed',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.arrow_downward,
                            size: 35,
                            weight: 600,
                          ),
                          Text(
                            'Download Speed',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '$downloadSpeed',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ]),
              ),
              const SizedBox(
                height: 63,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 75,
                    child: ElevatedButton.icon(
                      onPressed: rebootRouter,
                      icon: Icon(
                        Icons.restart_alt,
                        size: 73,
                        weight: 600,
                      ),
                      label: Text('Reboot'),
                      style: ElevatedButton.styleFrom(
                        primary:
                            Colors.black, // Set your desired button color here
                        onPrimary: Colors
                            .white, // Set your desired text/icon color here
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
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
