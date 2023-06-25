import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class MyWifiWidget extends StatefulWidget {
  final String ipAddress;
  final String username;
  final String password;

  const MyWifiWidget({
    Key? key,
    required this.ipAddress,
    required this.username,
    required this.password,
  }) : super(key: key);

  @override
  _MyWifiWidgetState createState() => _MyWifiWidgetState();
}

class _MyWifiWidgetState extends State<MyWifiWidget> {
  String wifiUsername = '';
  String wifiPassword = '';
  bool isPasswordVisible = false;

  Future<void> fetchWifiDetails() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://${widget.ipAddress}/rest/interface/wireless/registration-table'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          wifiUsername = jsonResponse['username'];
          wifiPassword = jsonResponse['password'];
        });
      } else {
        setState(() {
          wifiUsername = 'Error retrieving WiFi details';
          wifiPassword = '';
        });
      }
    } catch (e) {
      print('Error: $e');
      final snackBar = SnackBar(content: Text('Error: $e'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> editWifiDetails() async {
    // Implement your logic to update the WiFi details and sync them with the router via REST API
    // You can use the http package to send a POST request with the updated WiFi details
    // Example:
    // final response = await http.post(Uri.parse('http://your-router-ip/api/update-wifi-details'), body: {...});

    // Once the update is successful, you can show a success message or perform any other actions
  }

  @override
  void initState() {
    super.initState();
    fetchWifiDetails();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            'MyWifi',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: 350,
                    height: 400,
                    padding: const EdgeInsets.symmetric(horizontal: 19),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        const Text(
                          'Main Wifi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'Username\n$wifiUsername',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Password\n${isPasswordVisible ? wifiPassword : '******************'}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: editWifiDetails,
                              icon:
                                  FaIcon(FontAwesomeIcons.solidEdit, size: 60),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: FaIcon(
                                FontAwesomeIcons.shareFromSquare,
                                size: 60,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
