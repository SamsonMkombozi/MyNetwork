// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:mynetwork/screens/cdevices.dart';
// import 'package:mynetwork/screens/cdevices.dart';
import 'package:mynetwork/screens/conndevices.dart';
import 'package:mynetwork/screens/internet.dart';
import 'package:mynetwork/screens/router.dart';

class Network extends StatefulWidget {
  final String ipAddress;
  final String username;
  final String password;
  const Network({
    Key? key,
    required this.ipAddress,
    required this.username,
    required this.password,
  }) : super(key: key);

  @override
  State<Network> createState() => _NetworkState();
}

class _NetworkState extends State<Network> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Center(
          child: Container(
            width: 320,
            height: 600,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 3),
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularContainer(
                    buttonText: 'Internet',
                    buttonIcon: Icons.signal_cellular_alt,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InternetPage(
                                  ipAddress: widget.ipAddress,
                                  username: widget.username,
                                  password: widget.password,
                                )),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  CircularContainer(
                    buttonText: 'Hardware',
                    buttonIcon: Icons.router,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RouterPage(
                                  ipAddress: widget.ipAddress,
                                  username: widget.username,
                                  password: widget.password,
                                )),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  CircularContainer(
                    buttonText: 'Devices',
                    buttonIcon: Icons.devices,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConDevices(
                                  ipAddress: widget.ipAddress,
                                  username: widget.username,
                                  password: widget.password,
                                )),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
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



// Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Network Configuration',
//               style: TextStyle(
//                 fontSize: 24.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             NetworkOption(
//               icon: Icons.signal_cellular_alt,
//               title: 'Internet',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => InternetPage(
//                       ipAddress: widget.ipAddress,
//                       username: widget.username,
//                       password: widget.password,
//                     ),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 8.0),
//             NetworkOption(
//               icon: Icons.router,
//               title: 'Network Hardware',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => RouterPage(
//                       ipAddress: widget.ipAddress,
//                       username: widget.username,
//                       password: widget.password,
//                     ),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 8.0),
//             NetworkOption(
//               icon: Icons.devices,
//               title: 'Connected Devices',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ConDevices(
//                       ipAddress: widget.ipAddress,
//                       username: widget.username,
//                       password: widget.password,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),