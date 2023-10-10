// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:mynetwork/screens/dashboard.dart';
import 'dart:convert';

import 'package:mynetwork/screens/dashview.dart';

class RouterPage extends StatefulWidget {
  final String ipAddresses;
  final String ipUsername;
  final String ipPassword;
  final String username;
  final String password;

  const RouterPage({
    Key? key,
    required this.ipAddresses,
    required this.ipUsername,
    required this.ipPassword,
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

  double _parseSpeed(String speed) {
    double bytes = double.tryParse(speed) ?? 0.0;
    double megabits = bytes / (1024 * 1024); // Convert bytes to megabits
    return megabits;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    upgradeRouterOs();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('http://${widget.ipAddresses}/rest/system/resource'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
      },
    );

    final response2 = await http.get(
      Uri.parse('http://${widget.ipAddresses}/rest/interface/ethernet'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
      },
    );

    if (response.statusCode == 200 && response2.statusCode == 200) {
      final data = jsonDecode(response.body);
      final data2 = jsonDecode(response2.body);
      setState(() {
        routerName = data['architecture-name'];
        routerOsVersion = data['version'];
        downloadSpeed = _parseSpeed(data2[0]['rx-bytes']).toStringAsFixed(2);
        uploadSpeed = _parseSpeed(data2[0]['tx-bytes']).toStringAsFixed(2);
      });
    } else {
      print('failed');
    }
  }

  Future<void> upgradeRouterOs() async {
    // Make HTTP request to upgrade router OS
    final response = await http.get(
      Uri.parse(
          'http://${widget.ipAddresses}/rest/system/package/update/install'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        final snackBar = SnackBar(content: Text('Router upgrade Success'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } else {
      // final snackBar = SnackBar(
      //     content: Text('Error: ${response.statusCode}  ${response.body}'));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    // Add any additional logic or error handling here
  }

  Future<void> rebootRouter() async {
    // Make HTTP request to reboot router
    // Replace <API_ENDPOINT> with your Mikrotik API endpoint
    final response = await http.post(
      Uri.parse('http://${widget.ipAddresses}/rest/system/reboot'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
      },
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Dashview(
                  ipAddresses: widget.ipAddresses,
                  ipUsername: widget.ipUsername,
                  ipPassword: widget.ipPassword,
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
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        toolbarHeight: 130,
        backgroundColor: Color.fromARGB(255, 218, 32, 40),
        centerTitle: true,
        leading: Transform.scale(
          scale: 2.5, // Adjust this value to increase or decrease the icon size
          child: Padding(
            padding: EdgeInsets.only(left: 13),
            child: IconButton(
              onPressed: () {
                // Handle back button press here
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
        ),
        title: Icon(
          Icons.router_rounded,
          size: 90,
          color: Colors.white,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 350.0,
            height: 366.0,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 3),
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
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 240, 240, 240),
                      shape: BoxShape
                          .rectangle, // Set the shape to circle for IconButton with circular border
                      border: Border.all(
                        color: Colors.black,
                        width: 3,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 9),
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  ' $uploadSpeed Mbps',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '$downloadSpeed Mbps',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ]),
                    )),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
          height: 150,
          color: Color.fromARGB(255, 218, 32, 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            'Update',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          content: Text(
                            'Do You Want To update RouterOs?',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w300),
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            TextButton(
                              child: const Text(
                                'Yes',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                              onPressed: () {
                                upgradeRouterOs();
                                Navigator.of(context).pop();
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => Dash(
                                //       ipAddress: widget.ipAddress,
                                //       username: widget.username,
                                //       password: widget.password,
                                //     ),
                                //   ),
                                // );
                              },
                            ),
                            SizedBox(
                              width: 140,
                            ),
                            TextButton(
                              child: const Text(
                                'No',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // Set your desired button color here
                    onPrimary:
                        Colors.black, // Set your desired text/icon color here
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upgrade_rounded,
                        size: 60,
                      ),
                      SizedBox(
                          height:
                              5), // You can adjust this value to control the spacing between icon and text
                      Text(
                        'Upgrade',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 55,
              ),
              SizedBox(
                height: 100,
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            'Reboot',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          content: Text(
                            'Do You Want To Reboot Router?',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w300),
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            TextButton(
                              child: const Text(
                                'Yes',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                              onPressed: () {
                                rebootRouter();
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(
                              width: 140,
                            ),
                            TextButton(
                              child: const Text(
                                'No',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // Set your desired button color here
                    onPrimary:
                        Colors.black, // Set your desired text/icon color here
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.restart_alt,
                        size: 65,
                      ),
                      SizedBox(
                          height:
                              5), // You can adjust this value to control the spacing between icon and text
                      Text(
                        'Reboot',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
