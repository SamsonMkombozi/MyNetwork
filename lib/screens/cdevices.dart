// ignore_for_file: unused_field, unused_local_variable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mynetwork/screens/conndevices.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ConnectedDevicesPage extends StatefulWidget {
  final String ipAddresses;
  final String ipUsername;
  final String ipPassword;

  const ConnectedDevicesPage({
    Key? key,
    required this.ipAddresses,
    required this.ipUsername,
    required this.ipPassword,
  }) : super(key: key);

  @override
  _ConnectedDevicesPageState createState() => _ConnectedDevicesPageState();
}

class _ConnectedDevicesPageState extends State<ConnectedDevicesPage> {
  List<DeviceInfo> devices = [];
  StreamController<List<DeviceInfo>> _devicesStreamController =
      StreamController<List<DeviceInfo>>();
  StreamController<List<DeviceInfo>> _dialogContentStreamController =
      StreamController<List<DeviceInfo>>();
  late Timer _timer;

  // Stream<List<DeviceInfo>>? _dialogContentStream;

  @override
  void initState() {
    super.initState();
    fetchConnectedDevices();

    // Set up a timer to refresh the data every 10 seconds
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) {
        fetchConnectedDevices();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _devicesStreamController.close();
    _dialogContentStreamController.close();
    _timer.cancel();
  }

  Future<void> fetchConnectedDevices() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://${widget.ipAddresses}/rest/interface/wireless/registration-table'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
        },
      );

      final leaseResponse = await http.get(
        Uri.parse('http://${widget.ipAddresses}/rest/ip/dhcp-server/lease'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
        },
      );

      if (response.statusCode == 200 && leaseResponse.statusCode == 200) {
        final data = json.decode(response.body);
        final leaseData = json.decode(leaseResponse.body);

        final macToHostName = {
          for (var lease in leaseData) lease['mac-address']: lease['host-name']
        };

        setState(() {
          devices = List<DeviceInfo>.from(data.map((deviceJson) {
            final macAddress = deviceJson['mac-address'];
            final interface = deviceJson['interface'];
            return DeviceInfo.fromJson(deviceJson,
                activeHostName: macToHostName[macAddress]);
          }));
          _devicesStreamController.add(devices);
          _dialogContentStreamController.add(devices);
        });
      } else {
        print('Failed to fetch connected devices or DHCP leases');
        print('Response status code (devices): ${response.statusCode}');
        print('Response body (devices): ${response.body}');
        print('Response status code (leases): ${leaseResponse.statusCode}');
        print('Response body (leases): ${leaseResponse.body}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> toggleDeviceBlockStatus(DeviceInfo device) async {
    try {
      final requestBody = json.encode({
        'mac-address': device.macAddress,
        'authentication': device.isBlocked,
      });

      final response = await http.post(
        Uri.parse(
            'http://${widget.ipAddresses}/rest/interface/wireless/access-list/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        setState(() {
          device.isBlocked = !device.isBlocked;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConDevices(
              ipAddresses: widget.ipAddresses,
              ipUsername: widget.ipUsername,
              ipPassword: widget.ipPassword,
            ),
          ),
        );
        print(
            'Device ${device.name} ${device.isBlocked ? 'blocked' : 'unblocked'} successfully.');
      } else {
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
    } catch (e) {
      print('Error toggling device block status: $e');
    }
  }

  Future<void> setMaxLimitsForIPAddress(
      String ipAddress, double downloadLimit, double uploadLimit) async {
    try {
      final requestBody = {
        'target': ipAddress,
        'max-limit': '${downloadLimit}M/${uploadLimit}M',
      };

      final response = await http.post(
        Uri.parse('http://${widget.ipAddresses}/rest/queue/simple/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final successMessage = 'Max limits set successfully for IP: $ipAddress';
        _devicesStreamController.sink.add(devices);
        print(successMessage);
      } else {
        print('Failed to set max limits for IP: $ipAddress');
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error setting max limits: $e');
    }
  }

  String _extractDataUsage(String dataUsage) {
    final regex = RegExp(r'([\d.]+)Mbps');
    final match = regex.firstMatch(dataUsage);

    if (match != null) {
      return '${match.group(1)}Mbps';
    } else {
      return dataUsage;
    }
  }

  void showCustomDialog(BuildContext context) {}
  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        width: _mediaQuery.size.width * 1,
        height: _mediaQuery.size.height * 1,
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder<List<DeviceInfo>>(
              stream: _devicesStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: EdgeInsets.only(top: 220),
                    child: SpinKitPianoWave(
                      color: Colors.black,
                      size: 60.0,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(top: 220),
                    child: Text(
                      'No connected devices found.',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  );
                } else {
                  final devices = snapshot.data;

                  return Expanded(
                    child: ListView.builder(
                      itemCount: devices!.length,
                      itemBuilder: (context, index) {
                        DeviceInfo device = devices[index];
                        TextEditingController downloadController =
                            TextEditingController(
                                text: device.downloadMaxLimit.toString());
                        TextEditingController uploadController =
                            TextEditingController(
                                text: device.uploadMaxLimit.toString());

                        return GestureDetector(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              title:
                                  Text('${device.activeHostName ?? "No Name"}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('MAC: ${device.macAddress}'),
                                  Text('IP: ${device.ipAddress}'),
                                  // Text(
                                  //     'Data Speed: ${_extractDataUsage(device.dataUsage)}'),
                                  Text(device.interface),
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
                          ),
                          onTap: () {
                            double initialDownloadLimit =
                                device.downloadMaxLimit;
                            double initialUploadLimit = device.uploadMaxLimit;
                            TextEditingController downloadController =
                                TextEditingController(
                                    text: initialDownloadLimit.toString());
                            TextEditingController uploadController =
                                TextEditingController(
                                    text: initialUploadLimit.toString());

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(
                                    child: Text(
                                        '${device.activeHostName ?? "No name"}'),
                                  ),
                                  content: Container(
                                    height:
                                        MediaQuery.sizeOf(context).height * 0.3,
                                    child: Column(
                                      children: [
                                        Text('IP: ${device.ipAddress}'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        // Text(
                                        //     'Data Usage: ${_extractDataUsage(device.dataUsage)}'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextField(
                                          controller: downloadController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText:
                                                'Download Max Limit (Mbps)',
                                          ),
                                        ),
                                        TextField(
                                          controller: uploadController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText:
                                                'Upload Max Limit (Mbps)',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.black,
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Colors.black,
                                                  width: 3),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.black,
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Colors.black,
                                                  width: 3),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text('Set'),
                                          onPressed: () {
                                            double downloadLimit =
                                                double.tryParse(
                                                        downloadController
                                                            .text) ??
                                                    0.0;
                                            double uploadLimit =
                                                double.tryParse(uploadController
                                                        .text) ??
                                                    0.0;
                                            setMaxLimitsForIPAddress(
                                                device.ipAddress,
                                                downloadLimit,
                                                uploadLimit);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.black,
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Colors.black,
                                                  width: 3),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text('Reset'),
                                          onPressed: () {
                                            downloadController.text =
                                                initialDownloadLimit.toString();
                                            uploadController.text =
                                                initialUploadLimit.toString();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
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
  final String interface;
  bool isBlocked;
  final String? activeHostName;
  double downloadMaxLimit;
  double uploadMaxLimit;

  DeviceInfo({
    required this.id,
    required this.name,
    required this.macAddress,
    required this.ipAddress,
    required this.dataUsage,
    required this.interface,
    this.isBlocked = false,
    this.activeHostName,
    this.downloadMaxLimit = 0.0,
    this.uploadMaxLimit = 0.0,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json,
      {String? activeHostName}) {
    return DeviceInfo(
      id: json['.id'],
      name: json['.id'],
      macAddress: json['mac-address'],
      interface: json['interface'],
      ipAddress: json['last-ip'],
      dataUsage: json['rx-rate'],
      activeHostName: activeHostName,
      downloadMaxLimit: json['download-max-limit'] ?? 0.0,
      uploadMaxLimit: json['upload-max-limit'] ?? 0.0,
    );
  }
}
