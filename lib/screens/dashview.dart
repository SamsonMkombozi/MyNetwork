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

class Dashview extends StatefulWidget {
  const Dashview({
    Key? key,
    required this.ipAddress,
    required this.username,
    required this.password,
  }) : super(key: key);

  final String ipAddress;
  final String password;
  final String username;

  @override
  State<Dashview> createState() => _DashviewState();
}

class _DashviewState extends State<Dashview> {
  Map<String, String> networkData = {};
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

          // if (networkInfo.title == 'Connected Devices') {
          //   data = responseBody.length.toString();
          // } else if (networkInfo.title == 'CPU Load') {
          //   data = responseBody.length.toString();
          // } else if (networkInfo.title == 'Uptime') {
          //   data = responseBody.length.toString();
          // }

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
              data = responseBody.length;
              ;
            }
          } else if (networkInfo.title == 'Bandwidth Usage') {
            if (responseBody != null && responseBody.length > 0) {
              data = responseBody[0]['bandwidth'];
            }
          } else if (networkInfo.title == 'Download Speed') {
            if (responseBody != null && responseBody.length > 0) {
              data = responseBody[0]['rx-bytes'];
            }
          } else if (networkInfo.title == 'Upload Speed') {
            if (responseBody != null && responseBody.length > 0) {
              data = responseBody[0]['tx-bytes'];
            }
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
