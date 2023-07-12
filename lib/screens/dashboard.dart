// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mynetwork/reuseable_widget/notiffication.dart';
import 'package:mynetwork/screens/dicoveryscreen.dart';
// import 'package:mynetwork/screens/netscreen.dart';
import 'package:mynetwork/screens/network.dart';
import 'package:mynetwork/screens/settings.dart';
import 'package:mynetwork/test/deviceinfo.dart';
import 'package:mynetwork/testSql.dart';
import 'dashview.dart';

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

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.account_box,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () {
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
                            color: Colors
                                .black, // Set the background color of the drawer header to black
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.add),
                          title: Text("Create Profiles"),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.control_point),
                          title: Text("Parental Control"),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.network_cell),
                          title: Text("DeviceInfo"),
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
                          leading: Icon(Icons.data_object_outlined),
                          title: Text("Database"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => sql(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.device_hub_rounded),
                          title: Text("Discovery Screen(test)"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SliderViewPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.logout_outlined),
                          title: Text("Log Out"),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        // title: Center(
        //   child: Text(
        //     'MyNetwork',
        //     style: TextStyle(color: textPrimaryColor),
        //   ),
        // ),
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 10),
            child: IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationCenterPage(
                      ipAddress: widget.ipAddress,
                      username: widget.username,
                      password: widget.password,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
              size: 35,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.network_cell_rounded,
              color: Colors.white,
              size: 35,
            ),
            label: 'Network',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
              size: 35,
            ),
            label: 'Settings',
          ),
        ],
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: textPrimaryColor,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
