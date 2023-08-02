// import 'package:device_info_plus/device_info_plus.dart';
// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mynetwork/screens/conndevices.dart';

class ConnectedDevicesPage extends StatefulWidget {
  final String ipAddress;
  final String username;
  final String password;

  const ConnectedDevicesPage({
    Key? key,
    required this.ipAddress,
    required this.username,
    required this.password,
  }) : super(key: key);

  @override
  _ConnectedDevicesPageState createState() => _ConnectedDevicesPageState();
}

class _ConnectedDevicesPageState extends State<ConnectedDevicesPage> {
  List<DeviceInfo> devices = [];

  String cdevices = '';

  @override
  void initState() {
    super.initState();
    fetchConnectedDevices();
  }

  Future<void> fetchConnectedDevices() async {
    final response = await http.get(
      Uri.parse(
          'http://${widget.ipAddress}/rest/interface/wireless/registration-table'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
      },
    );
    final device = await http.get(
      Uri.parse(
          'http://${widget.ipAddress}/rest/interface/wireless/registration-table'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        devices = List<DeviceInfo>.from(
            data.map((deviceJson) => DeviceInfo.fromJson(deviceJson)));
      });
    } else {
      // Handle error
      print('Failed to fetch connected devices');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> toggleDeviceBlockStatus(DeviceInfo device) async {
    // Prepare the request body
    final requestBody = json.encode({
      'mac-address': device.macAddress,
      // 'disabled': !device.isBlocked,
      'authentication': device.isBlocked,
    });

    final response = await http.post(
      Uri.parse(
          'http://${widget.ipAddress}/rest/interface/wireless/access-list/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      // Update the device's block status
      setState(() {
        device.isBlocked = !device.isBlocked;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConDevices(
                    ipAddress: widget.ipAddress,
                    username: widget.username,
                    password: widget.password,
                  )),
        );
      });
      print(
          'Device ${device.name} ${device.isBlocked ? 'blocked' : 'unblocked'} successfully.');
    } else {
      // Handle error
      print('Failed to toggle device block status');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Failed to Block device ${device.name} '),
            content: Text(
              'Failed to Block Device. Error code: ${response.statusCode} .. Status: ${response.reasonPhrase}',
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 320,
          height: 550,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: Container(
                  padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.devices,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text(
                        '${devices.length} Connected Devices',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          // decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    DeviceInfo device = devices[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(device.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('MAC: ${device.macAddress}'),
                            Text('IP: ${device.ipAddress}'),
                            Text('Data Usage: ${device.dataUsage}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(device.isBlocked
                              ? Icons.check_circle
                              : Icons.block),
                          onPressed: () {
                            toggleDeviceBlockStatus(device);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeviceInfo {
  final String id;
  final String name;
  final String macAddress;
  final String ipAddress;
  final String dataUsage;
  bool isBlocked;

  DeviceInfo({
    required this.id,
    required this.name,
    required this.macAddress,
    required this.ipAddress,
    required this.dataUsage,
    this.isBlocked = false,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      id: json['.id'],
      name: json['.id'],
      macAddress: json['mac-address'],
      ipAddress: json['last-ip'],
      dataUsage: json['rx-rate'],
    );
  }
}
