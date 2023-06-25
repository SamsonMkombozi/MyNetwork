import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkInfo {
  final String title;
  final IconData icon;
  final String command;
  String? data;

  NetworkInfo({required this.title, required this.icon, required this.command});
}

class Dashview extends StatefulWidget {
  final String ipAddress;
  final String username;
  final String password;

  const Dashview({
    Key? key,
    required this.ipAddress,
    required this.username,
    required this.password,
  }) : super(key: key);

  @override
  State<Dashview> createState() => _DashviewState();
}

class _DashviewState extends State<Dashview> {
  List<NetworkInfo> networkInfoList = [
    NetworkInfo(
      title: 'Bandwidth Usage',
      icon: Icons.network_check,
      command: '/interface/monitor-traffic',
    ),
    NetworkInfo(
      title: 'Connected Devices',
      icon: Icons.devices,
      command: '/interface/ethernet',
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
      command: '/interface/monitor-traffic',
    ),
    NetworkInfo(
      title: 'Upload Speed',
      icon: Icons.arrow_upward,
      command: '/interface/monitor-traffic',
    ),
    NetworkInfo(
      title: 'Internet Status',
      icon: Icons.wifi,
      command: '/interface/monitor-traffic',
    ),
  ];

  Map<String, String> networkData = {};

  @override
  void initState() {
    super.initState();
    fetchNetworkData();
  }

  Future<void> fetchNetworkData() async {
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
          String data = '';

          if (networkInfo.title == 'CPU Load') {
            data = responseBody[0]['cpu-load'] ?? 'N/A';
          } else if (networkInfo.title == 'Bandwidth Usage') {
            data = responseBody[0]['Bandwidth-Usage'] ?? 'N/A';
          } else if (networkInfo.title == 'Uptime') {
            data = responseBody[0]['uptime'] ?? 'N/A';
          } else if (networkInfo.title == 'Download Speed') {
            data = responseBody[0]['Download-Speed'] ?? 'N/A';
          } else if (networkInfo.title == 'Upload Speed') {
            data = responseBody[0]['Upload-Speed'] ?? 'N/A';
          } else if (networkInfo.title == 'Internet Status') {
            data = responseBody[0]['Internet-Status'] ?? 'N/A';
          } else if (networkInfo.title == 'Connected Devices') {
            data = responseBody.length.toString();
          }

          setState(() {
            networkData[networkInfo.title] = data;
          });
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Data Fetch Failed'),
                content: Text(
                  'Failed to fetch data for ${networkInfo.title}. Error code: ${response.statusCode} .. Status: ${response.reasonPhrase}',
                ),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Data Fetch Failed'),
              content: Text(
                  'An error occurred while fetching data for ${networkInfo.title}: $error'),
              actions: [
                TextButton(
                  child: Text('OK'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'MyNetwork',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              for (var networkInfo in networkInfoList)
                Center(
                  child: Center(
                    child: ListTile(
                      leading: Icon(
                        networkInfo.icon,
                        color: Colors.black87,
                      ),
                      title: Text(
                        networkInfo.title,
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        networkData[networkInfo.title] ?? 'Loading...',
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
