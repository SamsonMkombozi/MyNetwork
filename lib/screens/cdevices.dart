import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    fetchConnectedDevices();
  }

  Future<void> fetchConnectedDevices() async {
    final response =
        await http.get(Uri.parse('YOUR_API_ENDPOINT_FOR_FETCHING_DEVICES'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        devices = List<DeviceInfo>.from(
          data.map((deviceJson) => DeviceInfo.fromJson(deviceJson)),
        );
      });
    } else {
      // Handle error
    }
  }

  Future<void> toggleDeviceBlockStatus(DeviceInfo device) async {
    final response = await http.post(
      Uri.parse('YOUR_API_ENDPOINT_FOR_TOGGLING_BLOCK_STATUS'),
      body: {
        'deviceId': device.id,
        'blocked': device.isBlocked ? '0' : '1',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        device.isBlocked = data['blocked'] == '1';
      });
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Container(
          width: 320,
          height: 720,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 40,
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
                      Icon(Icons.devices),
                      SizedBox(width: 10),
                      Text('\$No Connected Devices'),
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
                              ? Icons.block
                              : Icons.check_circle),
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
      id: json['id'],
      name: json['name'],
      macAddress: json['macAddress'],
      ipAddress: json['ipAddress'],
      dataUsage: json['dataUsage'],
      isBlocked: json['isBlocked'],
    );
  }
}
