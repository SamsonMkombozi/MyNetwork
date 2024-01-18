import 'package:flutter/material.dart';
import 'package:mynetwork/screens/Activity.dart';
import 'package:mynetwork/screens/blockedSites.dart';
import 'package:mynetwork/screens/wifiList.dart';
// import 'package:mynetwork/test/activity.dart';
import 'speed.dart';

class InternetPage extends StatelessWidget {
  final String ipAddresses;
  final String ipUsername;
  final String ipPassword;
  final String username;
  final String password;

  const InternetPage({
    Key? key,
    required this.ipAddresses,
    required this.ipUsername,
    required this.ipPassword,
    required this.username,
    required this.password,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        leading: Transform.scale(
            scale:
                2.5, // Adjust this value to increase or decrease the icon size
            child: Padding(
              padding: EdgeInsets.only(left: 13),
              child: IconButton(
                onPressed: () {
                  // Handle back button press here
                  Navigator.of(context).pop();
                },
                color: Colors.white,
                icon: Icon(Icons.arrow_back),
              ),
            )),
        toolbarHeight: 130,
        backgroundColor: Color.fromARGB(255, 218, 32, 40),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          width: _mediaQuery.size.width * 1,
          height: _mediaQuery.size.height * 1,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 3),
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Internet Services',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: 180,
                  height: 2,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
                SizedBox(height: 20),
                RectangularContainer(
                  buttonText: 'My Wifi',
                  buttonIcon: Icons.wifi,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WiFiListPage(
                          ipAddresses: ipAddresses,
                          ipUsername: ipUsername,
                          ipPassword: ipPassword,
                          username: username,
                          password: password,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                RectangularContainer(
                  buttonText: 'Speed Test',
                  buttonIcon: Icons.speed,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SpeedTestPage(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                RectangularContainer(
                  buttonText: 'Block Sites',
                  buttonIcon: Icons.web_stories,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => bsites(
                          ipAddresses: ipAddresses,
                          ipUsername: ipUsername,
                          ipPassword: ipPassword,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                RectangularContainer(
                  buttonText: 'Activity',
                  buttonIcon: Icons.bar_chart_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApiDataAndGraph(
                          ipAddresses: ipAddresses,
                          ipUsername: ipUsername,
                          ipPassword: ipPassword,
                          username: username,
                          password: password,
                        ),
                      ),
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

class RectangularContainer extends StatelessWidget {
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback onTap;

  const RectangularContainer({
    required this.buttonText,
    required this.buttonIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 80,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  buttonIcon,
                  color: Colors.white,
                  size: 40,
                ),
                SizedBox(width: 16),
                Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
