// ignore_for_file: unused_import

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkInfo {
  NetworkInfo({required this.title, required this.icon, required this.command});

  final String command;
  String? data;
  final IconData icon;
  final String title;
}

class stream extends StatefulWidget {
  final String ipAddress;
  final String password;
  final String username;
  const stream({
    super.key,
    required this.ipAddress,
    required this.username,
    required this.password,
  });

  @override
  State<stream> createState() => _streamState();
}

class _streamState extends State<stream> {
  Map<String, String?> networkData = {};
  List<NetworkInfo> networkInfoList = [
    NetworkInfo(
      title: 'Bandwidth Usage',
      icon: Icons.network_check,
      command: '/interface/ethernet',
    ),
    NetworkInfo(
      title: 'Connected Devices',
      icon: Icons.devices,
      command: '/interface/wireless/registration-table',
    ),
    NetworkInfo(
      title: 'CPU Load',
      icon: Icons.memory,
      command: '/system/resource',
    ),
    NetworkInfo(
      title: 'Uptime',
      icon: Icons.timelapse,
      command: '/system/resource',
    ),
    NetworkInfo(
      title: 'Download Speed',
      icon: Icons.arrow_downward,
      command: '/interface/ethernet',
    ),
    NetworkInfo(
      title: 'Upload Speed',
      icon: Icons.arrow_upward,
      command: '/interface/ethernet',
    ),
    // NetworkInfo(
    //   title: 'Internet Status',
    //   icon: Icons.wifi,
    //   command: '/interface/monitor-traffic',
    // ),
  ];

  StreamController<Map<String, String?>> networkDataStreamController =
      StreamController<Map<String, String?>>();
  StreamController<String> errorStreamController = StreamController<String>();

  @override
  void initState() {
    super.initState();
    fetchNetworkDataStream();
  }

  Stream<Map<String, String?>> fetchNetworkDataStream() async* {
    for (var networkInfo in networkInfoList) {
      String command = networkInfo.command;
      try {
        http.Response response = await http.get(
          Uri.parse('http://${widget.ipAddress}/rest$command'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
          },
        );

        if (response.statusCode == 200) {
          dynamic responseBody = json.decode(response.body);
          String? data;

          if (networkInfo.title == 'CPU Load') {
            if (responseBody != null && responseBody.length > 0) {
              data = responseBody['cpu-load'] ?? 'N/A';
            }
          } else if (networkInfo.title == 'Uptime') {
            if (responseBody != null && responseBody.length > 0) {
              data = responseBody['uptime'];
            }
          } else if (networkInfo.title == 'Connected Devices') {
            if (responseBody != null && responseBody.length > 0) {
              data = responseBody.length.toString();
            }
          } else if (networkInfo.title == 'Bandwidth Usage') {
            if (responseBody != null && responseBody.length > 0) {
              data = responseBody[0]['bandwidth'];
            }
          } else if (networkInfo.title == 'Download Speed') {
            if (responseBody != null && responseBody.length > 0) {
              data = responseBody[0]['rx-bytes'] + ' Mbps';
            }
          } else if (networkInfo.title == 'Upload Speed') {
            if (responseBody != null && responseBody.length > 0) {
              data = responseBody[0]['tx-bytes'] + ' Mbps';
            }
          }

          networkData[networkInfo.title] = data;
          networkDataStreamController.add(networkData);
        } else {
          errorStreamController.add(
            'Failed to fetch data for ${networkInfo.title}. Error code: ${response.statusCode} .. Status: ${response.reasonPhrase}',
          );
        }
      } catch (error) {
        errorStreamController.add(
          'An error occurred while fetching data for ${networkInfo.title}: $error',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: networkDataStreamController.stream,
      // initialData: initialData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: networkInfoList.map((networkInfo) {
              return ListTile(
                leading: Icon(
                  networkInfo.icon,
                  color: Colors.black87,
                ),
                title: Text(
                  networkInfo.title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  snapshot.data?[networkInfo.title] ?? 'Loading...',
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
              );
            }).toList(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  @override
  void dispose() {
    networkDataStreamController.close();
    errorStreamController.close();
    super.dispose();
  }
}
