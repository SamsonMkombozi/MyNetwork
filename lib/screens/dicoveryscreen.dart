// ignore_for_file: use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slider View Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SliderViewPage(),
    );
  }
}

class SliderViewPage extends StatefulWidget {
  @override
  _SliderViewPageState createState() => _SliderViewPageState();
}

class _SliderViewPageState extends State<SliderViewPage> {
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
        title: Text('Slider View Demo'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: [
          LoginScreen(),
          DeviceDiscoveryScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (int index) {
          setState(() {
            _currentPageIndex = index;
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Device Discovery',
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _adminController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final ip = _ipController.text;
    final admin = _adminController.text;
    final password = _passwordController.text;

    try {
      // Make a POST request to login using MikroTik REST API
      final response = await http.post(
        Uri.http(ip, '/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'username': admin, 'password': password},
      );

      if (response.statusCode == 200) {
        // Login successful, proceed to next screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NetworkDetailsScreen(
              ip: ip,
              admin: admin,
            ),
          ),
        );
      } else {
        setState(() {
          _errorMessage =
              'Error ${response.statusCode}: ${response.reasonPhrase}';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error: $error';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login Screen',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _ipController,
              decoration: InputDecoration(
                labelText: 'MikroTik IP',
              ),
            ),
            TextFormField(
              controller: _adminController,
              decoration: InputDecoration(
                labelText: 'Admin',
              ),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading ? CircularProgressIndicator() : Text('Login'),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class Device {
  final String ip;
  final String macAddress;
  final String uptime;

  Device({
    required this.ip,
    required this.macAddress,
    required this.uptime,
  });
}

class DeviceDiscoveryScreen extends StatefulWidget {
  @override
  _DeviceDiscoveryScreenState createState() => _DeviceDiscoveryScreenState();
}

class _DeviceDiscoveryScreenState extends State<DeviceDiscoveryScreen> {
  List<Device> _devices = [];
  bool _isLoading = false;

  Future<void> _discoverDevices() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Make a GET request to fetch device discovery data using MikroTik REST API
      final response = await http.get(Uri.https('10.188.18.43', '/devices'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;

        // Map the JSON data to Device objects
        final devices = jsonData
            .map((item) => Device(
                  ip: item['ip'],
                  macAddress: item['mac_address'],
                  uptime: item['uptime'],
                ))
            .toList();

        setState(() {
          _devices = devices;
        });
      } else {
        print('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error: $error');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Device Discovery Screen',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _discoverDevices,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Discover Devices'),
            ),
            if (_devices.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _devices.length,
                  itemBuilder: (context, index) {
                    final device = _devices[index];
                    return ListTile(
                      title: Text(device.ip),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('MAC Address: ${device.macAddress}'),
                          Text('Uptime: ${device.uptime}'),
                        ],
                      ),
                      onTap: () {
                        // Select the device to use for login
                        // Update the login screen with the selected device's IP address
                        Navigator.of(context).pop(device.ip);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class NetworkDetailsScreen extends StatelessWidget {
  final String ip;
  final String admin;

  NetworkDetailsScreen({required this.ip, required this.admin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'IP: $ip',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Admin: $admin',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
