// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:mynetwork/screens/cdevices.dart';
// import 'package:mynetwork/screens/cdevices.dart';
import 'package:mynetwork/screens/conndevices.dart';
import 'package:mynetwork/screens/internet.dart';
import 'package:mynetwork/screens/router.dart';

import 'Connected Device/Ethernet/showdevice.dart';

class Network extends StatefulWidget {
  final String ipAddresses;
  final String ipUsername;
  final String ipPassword;
  final String username;
  final String password;
  const Network({
    Key? key,
    required this.ipAddresses,
    required this.ipUsername,
    required this.ipPassword,
    required this.username,
    required this.password,
  }) : super(key: key);

  @override
  State<Network> createState() => _NetworkState();
}

class _NetworkState extends State<Network> {
  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        width: _mediaQuery.size.width * 1,
        height: _mediaQuery.size.height * 1,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: BorderRadius.circular(10),
          shape: BoxShape.rectangle,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularContainer(
              buttonText: 'Internet',
              buttonIcon: Icons.signal_cellular_alt,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InternetPage(
                            ipAddresses: widget.ipAddresses,
                            ipUsername: widget.ipUsername,
                            ipPassword: widget.ipPassword,
                            username: widget.username,
                            password: widget.password,
                          )),
                );
              },
            ),
            CircularContainer(
              buttonText: 'Hardware',
              buttonIcon: Icons.router,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RouterPage(
                            ipAddresses: widget.ipAddresses,
                            ipUsername: widget.ipUsername,
                            ipPassword: widget.ipPassword,
                            username: widget.username,
                            password: widget.password,
                          )),
                );
              },
            ),
            CircularContainer(
              buttonText: 'Devices',
              buttonIcon: Icons.devices,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        'Connected Devices',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      content: Text(
                        'Open the devices you want to View',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        Row(
                          // smainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              child: const Text(
                                'Ethernet',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ConnectedEtherDevicesPage(
                                            ipAddresses: widget.ipAddresses,
                                            ipUsername: widget.ipUsername,
                                            ipPassword: widget.ipPassword,
                                          )),
                                );
                              },
                            ),
                            TextButton(
                              child: const Text(
                                'Wireless',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ConDevices(
                                            ipAddresses: widget.ipAddresses,
                                            ipUsername: widget.ipUsername,
                                            ipPassword: widget.ipPassword,
                                          )),
                                );
                              },
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NetworkOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const NetworkOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(
            icon,
            color: Colors.black,
          ),
          backgroundColor: Colors.grey[300],
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        onTap: onTap,
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
