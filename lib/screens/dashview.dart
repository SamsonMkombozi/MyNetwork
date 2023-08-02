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

          if (networkInfo.title == 'CPU Load') {
            if (responseBody != null && responseBody.length > 0) {
              data = responseBody['cpu-load'] + ' %' ?? 'N/A';
            }
          } else if (networkInfo.title == 'Uptime') {
            if (responseBody != null && responseBody.length > 0) {
              data = responseBody['uptime'];
            }
          } else if (networkInfo.title == 'Connected Devices') {
            if (responseBody != null && responseBody.length > 0) {
              data = responseBody.length.toString();
            } else {
              data = '0';
            }
          } else if (networkInfo.title == 'Bandwidth Usage') {
            if (responseBody != null && responseBody.length > 0) {
              data = responseBody[0]['bandwidth'];
            }
          } else if (networkInfo.title == 'Download Speed') {
            if (responseBody != null && responseBody.length > 0) {
              // Convert rx-bytes to Mbps
              int rxBytes = int.tryParse(responseBody[0]['rx-bytes']) ?? 0;
              double downloadSpeedMbps = rxBytes / 1000000;
              data = downloadSpeedMbps.toStringAsFixed(2) + ' Mbps';
            }
          } else if (networkInfo.title == 'Upload Speed') {
            if (responseBody != null && responseBody.length > 0) {
              // Convert tx-bytes to Mbps
              int txBytes = int.tryParse(responseBody[0]['tx-bytes']) ?? 0;
              double uploadSpeedMbps = txBytes / 1000000;
              data = uploadSpeedMbps.toStringAsFixed(2) + ' Mbps';
            }
          }
          // else if (networkInfo.title == 'Internet Status') {
          //   if (responseBody != null && responseBody.length > 0) {
          //     data = responseBody[0]['status'];
          //   }
          // }

          setState(() {
            networkData[networkInfo.title] = data;
          });
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Data Fetch Failed'),
                content: Text(
                  'Failed to fetch data for ${networkInfo.title}. Error code: ${response.statusCode} .. Status: ${response.reasonPhrase}',
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
      } catch (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Data Fetch Failed'),
              content: Text(
                  'An error occurred while fetching data for ${networkInfo.title}: $error'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'MyNetwork',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: false,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 120,
                    crossAxisCount: 2, // Number of columns in the grid
                    crossAxisSpacing: 8.0, // Spacing between columns
                    mainAxisSpacing: 0, // Spacing between rows
                  ),
                  itemCount: networkInfoList.length,
                  itemBuilder: (context, index) {
                    var networkInfo = networkInfoList[index];
                    return NetworkItem(
                      icon: networkInfo.icon,
                      title: networkInfo.title,
                      response: networkData[networkInfo.title] ?? 'Loading...',
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {
                    fetchNetworkData();
                  },
                  backgroundColor: Colors.black,
                  child: Icon(
                    Icons.refresh,
                    size: 50,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NetworkItem extends StatelessWidget {
  const NetworkItem({
    required this.icon,
    required this.title,
    required this.response,
  });

  final IconData icon;
  final String response;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  icon,
                  color: Colors.black87,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  response,
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
