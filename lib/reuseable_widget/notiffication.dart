import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Device {
  final String name;
  final String ipAddress;

  Device({required this.name, required this.ipAddress});
}

class NotificationCenterPage extends StatefulWidget {
  final String ipAddress;
  final String username;
  final String password;

  const NotificationCenterPage({
    Key? key,
    required this.ipAddress,
    required this.username,
    required this.password,
  }) : super(key: key);
  @override
  _NotificationCenterPageState createState() => _NotificationCenterPageState();
}

class _NotificationCenterPageState extends State<NotificationCenterPage> {
  @override
  void initState() {
    super.initState();
    fetchAndSetDevices();
  }

  Future<void> fetchAndSetDevices() async {
    final devices = await fetchDevices();
    final deviceProvider = Provider.of<DeviceProvider>(context, listen: false);
    deviceProvider.clearDevices();
    devices.forEach(deviceProvider.addDevice);
  }

  Future<List<Device>> fetchDevices() async {
    final response = await http.get(
      Uri.parse(
          'http://${widget.ipAddress}/rest/interface/wireless/registration-table'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
      },
    );

    if (response.statusCode == 200) {
      // Parse the response JSON and create a list of devices
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => Device(
                name: json['name'],
                ipAddress: json['ipAddress'],
              ))
          .toList();
    } else {
      throw Exception('Failed to fetch devices');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Notification Center',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<DeviceProvider>(
        builder: (context, deviceProvider, child) {
          final devices = deviceProvider.devices;

          if (devices.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              return ListTile(
                title: Text(device.name),
                subtitle: Text(device.ipAddress),
              );
            },
          );
        },
      ),
    );
  }
}

class DeviceProvider extends ChangeNotifier {
  List<Device> _devices = [];

  List<Device> get devices => _devices;

  void addDevice(Device device) {
    _devices.add(device);
    notifyListeners();
  }

  void clearDevices() {
    _devices.clear();
    notifyListeners();
  }
}
