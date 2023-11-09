// ignore_for_file: prefer_const_literals_to_create_immutables, unused_import, unused_label

import 'dart:convert';

import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mynetwork/db/DataTableDemo.dart';
import 'package:mynetwork/reuseable_widget/drawer.dart';
import 'package:mynetwork/reuseable_widget/notiffication.dart';
import 'package:mynetwork/screens/activytysql.dart';
import 'package:mynetwork/screens/auth.dart';
import 'package:mynetwork/screens/network.dart';
import 'package:mynetwork/screens/settings.dart';
import 'package:mynetwork/screens/dashview.dart';
import 'package:mynetwork/screens/support2.dart';
import 'package:mynetwork/test/deviceinfo.dart';
import 'package:mynetwork/test/view.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class Dash extends StatefulWidget {
  final String ipUsername;
  final String ipPassword;
  final String ipAddresses;
  final String username;
  final String password;

  const Dash({
    Key? key,
    required this.ipUsername,
    required this.ipPassword,
    required this.ipAddresses,
    required this.username,
    required this.password,
  }) : super(key: key);

  @override
  State<Dash> createState() => _DashState();
}

class _DashState extends State<Dash> {
  final AuthProvider _authProvider = AuthProvider();
  final Color textPrimaryColor = Color(0xFF212121);
  final Color backgroundColor = Colors.white;
  String routerBrand = '';
  String mode = '';
  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    // getWlanMode();
    fetchData();
    screens = [
      Dashview(
        ipAddresses: widget.ipAddresses,
        ipUsername: widget.ipUsername,
        ipPassword: widget.ipPassword,
        username: widget.username,
        password: widget.password,
      ),
      Network(
        ipAddresses: widget.ipAddresses,
        ipUsername: widget.ipUsername,
        ipPassword: widget.ipPassword,
        username: widget.username,
        password: widget.password,
      ),
      Settings(
        ipAddresses: widget.ipAddresses,
        ipUsername: widget.ipUsername,
        ipPassword: widget.ipPassword,
        password: widget.username,
        username: widget.password,
      ),
    ];
  }

  // Future<void> getWlanMode() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('http://${widget.ipAddresses}/rest/interface/wireless/wlan1'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization':
  //             'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);

  //       if (data is Map && data.containsKey('mode')) {
  //         setState(() {
  //           mode = data['mode'];
  //         });
  //         print('WLAN Mode: $mode');
  //       } else {
  //         print('Response body does not contain the expected "mode" property.');
  //         // Handle the case where the response is not in the expected format.
  //       }
  //     } else {
  //       print('Failed to get WLAN mode: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //       // Handle HTTP error responses here.
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     // Handle any exceptions that might occur during the request.
  //   }
  // }

  Future<void> fetchData() async {
    try {
      final response1 = await http.get(
        Uri.parse('http://${widget.ipAddresses}/rest/system/resource'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
        },
      );

      final response2 = await http.get(
        Uri.parse('http://${widget.ipAddresses}/rest/interface/wireless/wlan1'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
        },
      );

      if (response1.statusCode == 200 && response2.statusCode == 200) {
        final data1 = jsonDecode(response1.body);
        final data2 = jsonDecode(response2.body);

        setState(() {
          routerBrand = data1['platform'];
        });

        if (data2 is Map && data2.containsKey('mode')) {
          setState(() {
            mode = data2['mode'];
          });
        }

        if (routerBrand == "MikroTik" && mode == "ap-bridge" ||
            mode == "bridge") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(
                  child: Text('Login Successful'),
                ),
                content: Text('Device is a Mikrotik Product'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          _authProvider.logout();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RouterConnectionPage()), // Navigate to LoginPage
            (route) => false, // Remove all previous routes from the stack
          );
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(
                  child: Text('Login Failed'),
                ),
                content: Text('Device is Not Mikrotik Product'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Handle HTTP error status codes and response body
        print('Failed to fetch data. Status code 1: ${response1.statusCode}');
        print('Response body 1: ${response1.body}');
        print('Failed to fetch data. Status code 2: ${response2.statusCode}');
        print('Response body 2: ${response2.body}');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  Future<void> rebootRouter() async {
    // Make an HTTP request to reboot router
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
          ),
        ),
      );
    } else {
      print('Failed to send reboot request');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    // Add any additional logic or error handling here
  }

  int _currentIndex = 0;
  void _launchWhatsApp() async {
    final link = 'whatsapp://send?phone=255767205251';
    if (await launchUrlString('$link')) {
      await launchUrlString('$link');
    } else {
      print('Could not launch WhatsApp');
      throw 'Could not launch WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!AuthProvider().isLoggedIn) {
          // Prevent back navigation after logout
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 110,
          backgroundColor: const Color.fromARGB(255, 218, 32, 40),
          leadingWidth: 100,
          leading: Padding(
            padding: EdgeInsets.only(left: 0),
            child: GestureDetector(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        color: Colors
                            .white, // Set the background color of the container
                        shape: BoxShape.circle, // Make the container circular
                      ),
                      width: 70,
                      height: 70,
                      child: Center(
                        child: Text(
                          widget.username.isNotEmpty ? widget.username[0] : '',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                  ]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => drawp(
                            ipAddresses: widget.ipAddresses,
                            ipUsername: widget.ipUsername,
                            ipPassword: widget.ipPassword,
                            username: widget.username,
                            password: widget.password,
                          )),
                );
              },
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 35),
              child: IconButton(
                icon: const Icon(
                  Icons.menu_open_rounded,
                  color: Colors.white,
                  size: 60,
                ),
                onPressed: () {
                  showPopupMenu(context);
                },
              ),
            )
          ],
        ),
        body: screens[_currentIndex],
        bottomNavigationBar: Container(
          // Adjust the height as needed
          child: FloatingNavbar(
            currentIndex: _currentIndex,
            backgroundColor: const Color.fromARGB(255, 218, 32, 40),
            items: [
              FloatingNavbarItem(
                icon: Icons.home,
                title: 'Home',
              ),
              FloatingNavbarItem(
                icon: Icons.network_wifi_3_bar,
                title: 'Network',
              ),
            ],
            iconSize: 30,
            onTap: ((int index) {
              setState(() {
                _currentIndex = index;
              });
            }),
          ),
        ),
      ),
    );
  }

  void showPopupMenu(BuildContext context) {
    showMenu(
        context: context,
        position: RelativeRect.fill,
        items: <PopupMenuEntry>[
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.replay_30_sharp),
              title: Text('Reboot'),
              onTap: () {
                rebootRouter();
              },
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.arrow_circle_up_rounded),
              title: Text('$mode'),
              onTap: () {
                // Handle Option 2
              },
            ),
          ),
        ]);
  }
}

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    checkLoginStatus();
  }
  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  Future<void> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    _isLoggedIn = false;
    notifyListeners();
  }
}




// Future<void> fetchData() async {
//     final response = await http.get(
//       Uri.parse('http://${widget.ipAddresses}/rest/system/resource'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization':
//             'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);

//       setState(() {
//         routerBrand = data['platform'];
//         if (routerBrand == "MikroTik") {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Center(
//                   child: Text('Login Succesfull'),
//                 ),
//                 content: Text(
//                   'Device is a Mikrotik Product',
//                 ),
//                 actions: [
//                   TextButton(
//                     child: Text('OK'),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               );
//             },
//           );
//         } else {
//           _authProvider.logout();
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(
//                 builder: (context) =>
//                     RouterConnectionPage()), // Navigate to LoginPage
//             (route) => false, // Remove all previous routes from the stack
//           );
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Center(
//                   child: Text('Login Failed'),
//                 ),
//                 content: Text(
//                   'Device is Not Mikrotik Product',
//                 ),
//                 actions: [
//                   TextButton(
//                     child: Text('OK'),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               );
//             },
//           );
//         }
//       });
//     } else {
//       // Print the response status code and body in case of an error
//       print('Failed to fetch data. Status code: ${response.statusCode}');
//       print('Response body: ${response.body}');
//     }
//   }