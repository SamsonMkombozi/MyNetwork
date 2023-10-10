// ignore_for_file: prefer_const_literals_to_create_immutables, unused_import

import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mynetwork/db/DataTableDemo.dart';
import 'package:mynetwork/reuseable_widget/drawer.dart';
import 'package:mynetwork/reuseable_widget/notiffication.dart';
import 'package:mynetwork/screens/Subscription.dart';
import 'package:mynetwork/screens/activytysql.dart';
import 'package:mynetwork/screens/auth.dart';
import 'package:mynetwork/screens/network.dart';
import 'package:mynetwork/screens/settings.dart';
import 'package:mynetwork/screens/dashview.dart';
// import 'package:mynetwork/screens/support.dart';
import 'package:mynetwork/screens/support2.dart';
import 'package:mynetwork/test/deviceinfo.dart';
import 'package:mynetwork/test/view.dart';
// import 'package:mynetwork/testSql.dart';
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
  // final AuthProvider _authProvider = AuthProvider();
  final Color textPrimaryColor = Color(0xFF212121);
  final Color backgroundColor = Colors.white;
  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
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
                          'A',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Text(
                    //   'Admin',
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontWeight: FontWeight.w600,
                    //     fontSize: 20,
                    //   ),
                    // ),
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
                  Icons.notifications,
                  color: Colors.white,
                  size: 60,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Notiffication(
                        ipAddresses: widget.ipAddresses,
                        ipUsername: widget.ipUsername,
                        ipPassword: widget.ipPassword,
                      ),
                    ),
                  );
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
