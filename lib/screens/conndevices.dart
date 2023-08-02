import 'package:flutter/material.dart';
import 'package:mynetwork/screens/cdevices.dart';
import 'package:mynetwork/test/accesslist.dart';

class ConDevices extends StatefulWidget {
  final String ipAddress;
  final String username;
  final String password;

  const ConDevices({
    Key? key,
    required this.ipAddress,
    required this.username,
    required this.password,
  }) : super(key: key);

  @override
  State<ConDevices> createState() => _ConDevicesState();
}

class _ConDevicesState extends State<ConDevices> {
  PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                icon: Icon(Icons.arrow_back),
              ),
            )),
        toolbarHeight: 130,
        backgroundColor: Color.fromARGB(255, 218, 32, 40),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: [
          ConnectedDevicesPage(
            ipAddress: widget.ipAddress,
            username: widget.username,
            password: widget.password,
          ),
          AccessListPage(
            ipAddress: widget.ipAddress,
            username: widget.username,
            password: widget.password,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 100, // Set your desired height here
        decoration: BoxDecoration(
          color: Colors.grey,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 218, 32, 40),
          currentIndex: _currentPageIndex,
          fixedColor: Colors.white,
          onTap: (int index) {
            setState(() {
              _currentPageIndex = index;
              _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 10),
                curve: Curves.easeInOut,
              );
            });
          },
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.devices_outlined,
                size: 50,
              ),
              label: 'Connected Devices',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.block_outlined,
                size: 50,
              ),
              label: 'Blocked Devices',
            ),
          ],
        ),
      ),
    );
  }
}
