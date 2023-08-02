// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:mynetwork/reuseable_widget/notiffication.dart';
import 'package:mynetwork/screens/auth.dart';
import 'package:mynetwork/screens/network.dart';
import 'package:mynetwork/screens/settings.dart';
import 'package:mynetwork/test/deviceinfo.dart';
import 'dashview.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class Dash extends StatefulWidget {
  final String ipAddress;
  final String username;
  final String password;

  const Dash({
    Key? key,
    required this.ipAddress,
    required this.username,
    required this.password,
  }) : super(key: key);

  @override
  State<Dash> createState() => _DashState();
}

class _DashState extends State<Dash> {
  final Color textPrimaryColor = Color(0xFF212121);
  final Color backgroundColor = Colors.white;
  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      Dashview(
        ipAddress: widget.ipAddress,
        username: widget.username,
        password: widget.password,
      ),
      Network(
        ipAddress: widget.ipAddress,
        username: widget.username,
        password: widget.password,
      ),
      Settings(
        ipAddress: widget.ipAddress,
        username: widget.username,
        password: widget.password,
      ),
    ];
  }

  Future<void> logout() async {
    // Make HTTP request to upgrade router OS
    final response = await http.get(
      Uri.parse('http://${widget.ipAddress}/rest/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        final snackBar = SnackBar(content: Text('logout Success'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } else {
      final snackBar = SnackBar(
          content: Text('Error: ${response.statusCode}  ${response.body}'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    // Add any additional logic or error handling here
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 170,

        backgroundColor: const Color.fromARGB(255, 218, 32, 40),
        actions: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 2),
                              color: Colors
                                  .white, // Set the background color of the container
                              shape: BoxShape
                                  .circle, // Make the container circular
                            ),
                            width: 100,
                            height: 100,
                            child: Center(
                              child: Text(
                                'A',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 45,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Admin',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ]),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Drawer(
                          child: Container(
                            color: Colors
                                .white, // Set the background color of the drawer body to white
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: <Widget>[
                                UserAccountsDrawerHeader(
                                  accountEmail: Text('    ' + widget.username),
                                  accountName: Text(widget.ipAddress),
                                  currentAccountPicture: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Text(
                                      "A",
                                      style: TextStyle(
                                          fontSize: 40.0, color: Colors.black),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 218, 32, 40),

                                    // Set the background color of the drawer header to black
                                  ),
                                ),
                                ListTile(
                                  leading: Icon(Icons.add),
                                  title: Text("Users"),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.control_point),
                                  title: Text("Change Password"),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.network_cell),
                                  title: Text("Device Info"),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => deviceInfo(),
                                      ),
                                    );
                                  },
                                ),
                                ListTile(
                                    leading: Icon(Icons.logout_outlined),
                                    title: Text("Log Out"),
                                    onTap: () {
                                      logout;
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RouterConnectionPage()),
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: 180,
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 40),
                    child: IconButton(
                      icon: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 70,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Notiffication(
                                // ipAddress: widget.ipAddress,
                                // username: widget.username,
                                // password: widget.password,
                                ),
                          ),
                        );
                      },
                    ),
                  ))
            ],
          ),
        ],
        // title: Center(
        //   child: Text(
        //     'MyNetwork',
        //     style: TextStyle(color: textPrimaryColor),
        //   ),
        // ),
        // actions: [
        //   Padding(
        //     padding: EdgeInsetsDirectional.only(end: 10),
        //     child: IconButton(
        //       icon: const Icon(
        //         Icons.notifications,
        //         color: Colors.white,
        //         size: 40,
        //       ),
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => NotificationCenterPage(
        //               ipAddress: widget.ipAddress,
        //               username: widget.username,
        //               password: widget.password,
        //             ),
        //           ),
        //         );
        //       },
        //     ),
        //   )
        // ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: FlashyTabBar(
        backgroundColor: const Color.fromARGB(255, 218, 32, 40),
        items: [
          FlashyTabBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
              size: 55,
            ),
            title: Text(
              'Home',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          FlashyTabBarItem(
            icon: Icon(
              Icons.network_check_sharp,
              color: Colors.white,
              size: 55,
            ),
            title: Text(
              'Network',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          FlashyTabBarItem(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
              size: 55,
            ),
            title: Text(
              'settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        height: 70,
        showElevation: false,
        selectedIndex: _currentIndex,
        animationCurve: Curves.linear,
        iconSize: 30,
        onItemSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
