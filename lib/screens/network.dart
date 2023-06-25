import 'package:flutter/material.dart';
import 'package:mynetwork/screens/cdevices.dart';
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Network Configuration',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            NetworkOption(
              icon: Icons.signal_cellular_alt,
              title: 'Internet',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InternetPage(
                      ipAddress: widget.ipAddress,
                      username: widget.username,
                      password: widget.password,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8.0),
            NetworkOption(
              icon: Icons.router,
              title: 'Network Hardware',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RouterPage(
                      ipAddress: widget.ipAddress,
                      username: widget.username,
                      password: widget.password,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8.0),
            NetworkOption(
              icon: Icons.devices,
              title: 'Connected Devices',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConnectedDevicesPage(
                      ipAddress: widget.ipAddress,
                      username: widget.username,
                      password: widget.password,
                    ),
                  ),
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
