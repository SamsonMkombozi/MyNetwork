import 'package:flutter/material.dart';
import 'package:mynetwork/screens/dicoveryscreen.dart';
import 'package:mynetwork/screens/netscreen.dart';
import 'package:mynetwork/screens/network.dart';
import 'package:mynetwork/screens/settings.dart';
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
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.account_box, color: textPrimaryColor),
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
                          accountEmail: Text(widget.ipAddress),
                          accountName: Text(widget.username),
                          currentAccountPicture: CircleAvatar(
                            backgroundColor: Colors.orange,
                            child: Text(
                              "A",
                              style: TextStyle(fontSize: 40.0),
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
                          title: Text("Network screen"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.login_outlined),
                          title: Text("Log in(test)"),
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => (),
                            //   ),
                            // );
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
        title: Center(
          child: Text(
            'MyNetwork',
            style: TextStyle(color: textPrimaryColor),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.message_outlined, color: textPrimaryColor),
            onPressed: () {
              print('Notifications');
            },
          ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.network_cell_rounded),
            label: 'Network',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
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
