import 'package:flutter/material.dart';
import 'package:mynetwork/screens/fix.dart';
import 'package:mynetwork/screens/wifi.dart';

import 'speed.dart';

class InternetPage extends StatelessWidget {
  final String ipAddress;
  final String username;
  final String password;

  const InternetPage({
    Key? key,
    required this.ipAddress,
    required this.username,
    required this.password,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          width: 320,
          height: 700,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularContainer(
                  buttonText: 'My Wifi',
                  buttonIcon: Icons.wifi,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyWifiWidget(
                                ipAddress: ipAddress,
                                username: username,
                                password: password,
                              )),
                    );
                  },
                ),
                SizedBox(height: 20),
                CircularContainer(
                  buttonText: 'Speed Test',
                  buttonIcon: Icons.speed,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SpeedTestPage(
                                ipAddress: ipAddress,
                                username: username,
                                password: password,
                              )),
                    );
                  },
                ),
                SizedBox(height: 20),
                CircularContainer(
                  buttonText: 'Fix',
                  buttonIcon: Icons.build,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TroubleshootingPage(
                                ipAddress: ipAddress,
                                username: username,
                                password: password,
                              )),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CircularContainer extends StatelessWidget {
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback onTap;

  const CircularContainer({
    required this.buttonText,
    required this.buttonIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              buttonIcon,
              color: Colors.white,
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              buttonText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
