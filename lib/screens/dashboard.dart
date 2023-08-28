// ignore_for_file: prefer_const_literals_to_create_immutables, unused_import

import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:mynetwork/db/DataTableDemo.dart';
import 'package:mynetwork/reuseable_widget/notiffication.dart';
import 'package:mynetwork/screens/Subscription.dart';
import 'package:mynetwork/screens/activytysql.dart';
import 'package:mynetwork/screens/auth.dart';
import 'package:mynetwork/screens/network.dart';
import 'package:mynetwork/screens/settings.dart';
import 'package:mynetwork/screens/speed2.dart';
// import 'package:mynetwork/screens/support.dart';
import 'package:mynetwork/screens/support2.dart';
import 'package:mynetwork/test/deviceinfo.dart';
// import 'package:mynetwork/testSql.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dashview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

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
  final AuthProvider _authProvider = AuthProvider();
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
  void _launchWhatsApp() async {
    final link = 'whatsapp://send?phone=255767205251';

    // WhatsAppUnilink(
    //   phoneNumber: '+255767205251',
    //   text: "Hello, I'm reaching out to you.",
    // );

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
                      padding: EdgeInsets.zero,
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
                                    accountEmail:
                                        Text('    ' + widget.username),
                                    accountName: Text(widget.ipAddress),
                                    currentAccountPicture: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Text(
                                        "A",
                                        style: TextStyle(
                                            fontSize: 40.0,
                                            color: Colors.black),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 218, 32, 40),

                                      // Set the background color of the drawer header to black
                                    ),
                                  ),

                                  Container(
                                    // padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                    ),
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.supervised_user_circle,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                      title: Align(
                                        child: Text(
                                          "Users",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    // padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                    ),
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.payment,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                      title: Align(
                                        child: Text(
                                          "Subscription Plan",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DemoChoosePlanScreen3(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    // padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                    ),
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.settings,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                      title: Align(
                                        child: Text(
                                          "Settings",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                      onTap: () {
                                        // Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Settings(
                                              ipAddress: widget.ipAddress,
                                              username: widget.username,
                                              password: widget.password,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    // padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                    ),
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.help_center,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                      title: Align(
                                        child: Text(
                                          "Get Help",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                'HELP & SUPPORT',
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                textAlign: TextAlign.center,
                                              ),
                                              content: Text(
                                                'You Can Contact Us for Support Or Make A Request For Your Internet Services!',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.w300),
                                                textAlign: TextAlign.center,
                                              ),
                                              actions: [
                                                Center(
                                                  child: TextButton(
                                                    child: const Text(
                                                      'MAKE REQUEST',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    onPressed: () {
                                                      // Navigator.of(context).pop();
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SupportM(),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 35,
                                                ),
                                                Center(
                                                  child: TextButton(
                                                    child: const Text(
                                                      'CONTACT US',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    onPressed: _launchWhatsApp,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  // Container(
                                  //   // padding: EdgeInsets.all(10),
                                  //   decoration: BoxDecoration(
                                  //     border: Border.all(width: 1),
                                  //   ),
                                  //   child: ListTile(
                                  //     leading: Icon(
                                  //       Icons.feedback_outlined,
                                  //       color: Colors.black,
                                  //       size: 40,
                                  //     ),
                                  //     title: Align(
                                  //         alignment: Alignment.center,
                                  //         child: Align(
                                  //           alignment: Alignment.center,
                                  //           child: Text(
                                  //             "leave Feedback",
                                  //             style: TextStyle(
                                  //                 fontSize: 20,
                                  //                 color: Colors.black,
                                  //                 fontWeight: FontWeight.w600),
                                  //           ),
                                  //         )),
                                  //     trailing: Icon(
                                  //       Icons.arrow_forward,
                                  //       color: Colors.black,
                                  //       size: 40,
                                  //     ),
                                  //     onTap: () {
                                  //       Navigator.push(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //           builder: (context) => Speed(),
                                  //         ),
                                  //       );
                                  //     },
                                  //   ),
                                  // ),
                                  SizedBox(
                                    height: 200,
                                  ),
                                  Expanded(
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            width: 200,
                                            height: 70,
                                            child: FloatingActionButton(
                                              backgroundColor: Colors.black,
                                              onPressed: () async {
                                                await _authProvider.logout();
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          RouterConnectionPage()), // Navigate to LoginPage
                                                  (route) =>
                                                      false, // Remove all previous routes from the stack
                                                );
                                              },
                                              child: Text('LOGOUT'),
                                              shape:
                                                  ContinuousRectangleBorder(),
                                            ),
                                          )
                                        ]),
                                  )
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
                                ipAddress: widget.ipAddress,
                                username: widget.username,
                                password: widget.password,
                              ),
                            ),
                          );
                        },
                      ),
                    )),
              ],
            ),
          ],
        ),
        body: screens[_currentIndex],
        bottomNavigationBar: FlashyTabBar(
          backgroundColor: const Color.fromARGB(255, 218, 32, 40),
          items: [
            FlashyTabBarItem(
              activeColor: Colors.white,
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
              activeColor: Colors.white,
              icon: Icon(
                Icons.network_wifi_3_bar,
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
            // FlashyTabBarItem(
            //   icon: Icon(
            //     Icons.settings,
            //     color: Colors.white,
            //     size: 55,
            //   ),
            //   title: Text(
            //     'settings',
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 25,
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            // ),
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
