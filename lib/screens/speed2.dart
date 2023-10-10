// // import 'dart:convert';
// // import 'dart:io';

// // import 'package:flutter/material.dart';
// // import 'package:speed_test_dart/classes/classes.dart';
// // import 'package:speed_test_dart/speed_test_dart.dart';

// // void main() => runApp(const Speed());

// // class Speed extends StatefulWidget {
// //   const Speed({super.key});

// //   @override
// //   State<Speed> createState() => _SpeedState();
// // }

// // class _SpeedState extends State<Speed> {
// //   SpeedTestDart tester = SpeedTestDart();
// //   List<Server> bestServersList = [];

// //   double downloadRate = 0;
// //   double uploadRate = 0;

// //   bool readyToTest = false;
// //   bool loadingDownload = false;
// //   bool loadingUpload = false;

// //   Future<void> setBestServers() async {
// //     final settings = await tester.getSettings();
// //     final servers = settings.servers;

// //     final _bestServersList = await tester.getBestServers(
// //       servers: servers,
// //     );

// //     setState(() {
// //       bestServersList = _bestServersList;
// //       readyToTest = true;
// //     });
// //   }

// //   Future<void> _testDownloadSpeed() async {
// //     setState(() {
// //       loadingDownload = true;
// //     });
// //     final _downloadRate =
// //         await tester.testDownloadSpeed(servers: bestServersList);
// //     setState(() {
// //       downloadRate = _downloadRate;
// //       loadingDownload = false;
// //     });
// //   }

// //   Future<void> _testUploadSpeed() async {
// //     setState(() {
// //       loadingUpload = true;
// //     });

// //     final _uploadRate = await tester.testUploadSpeed(servers: bestServersList);

// //     setState(() {
// //       uploadRate = _uploadRate;
// //       loadingUpload = false;
// //     });
// //   }
// //   void runSpeedtestCLI() async {
// //   final result = await Process.run('speedtest', []);
// //   final output = utf8.decode(result.stdout);

// //   print('Speedtest Output: $output');
// // }

// //   @override
// //   void initState() {
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       setBestServers();
// //     });
// //     super.initState();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //         appBar: AppBar(
// //           title: const Text('Speed Test Example App'),
// //         ),
// //         body: Center(
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               const Text(
// //                 'Download Test:',
// //                 style: TextStyle(
// //                   fontSize: 20,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //               const SizedBox(
// //                 height: 10,
// //               ),
// //               if (loadingDownload)
// //                 Column(
// //                   children: const [
// //                     CircularProgressIndicator(),
// //                     SizedBox(
// //                       height: 10,
// //                     ),
// //                     Text('Testing download speed...'),
// //                   ],
// //                 )
// //               else
// //                 Text('Download rate  ${downloadRate.toStringAsFixed(2)} Mb/s'),
// //               const SizedBox(height: 10),
// //               ElevatedButton(
// //                 style: ElevatedButton.styleFrom(
// //                   primary: readyToTest && !loadingDownload
// //                       ? Colors.blue
// //                       : Colors.grey,
// //                 ),
// //                 onPressed: loadingDownload
// //                     ? null
// //                     : () async {
// //                         if (!readyToTest || bestServersList.isEmpty) return;
// //                         await _testDownloadSpeed();
// //                       },
// //                 child: const Text('Start'),
// //               ),
// //               const SizedBox(
// //                 height: 50,
// //               ),
// //               const Text(
// //                 'Upload Test:',
// //                 style: TextStyle(
// //                   fontSize: 20,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //               const SizedBox(
// //                 height: 10,
// //               ),
// //               if (loadingUpload)
// //                 Column(
// //                   children: const [
// //                     CircularProgressIndicator(),
// //                     SizedBox(height: 10),
// //                     Text('Testing upload speed...'),
// //                   ],
// //                 )
// //               else
// //                 Text('Upload rate ${uploadRate.toStringAsFixed(2)} Mb/s'),
// //               const SizedBox(
// //                 height: 10,
// //               ),
// //               ElevatedButton(
// //                 style: ElevatedButton.styleFrom(
// //                   primary: readyToTest ? Colors.blue : Colors.grey,
// //                 ),
// //                 onPressed: loadingUpload
// //                     ? null
// //                     : () async {
// //                         if (!readyToTest || bestServersList.isEmpty) return;
// //                         await _testUploadSpeed();
// //                       },
// //                 child: const Text('Start'),
// //               ),

// //               ElevatedButton(
// //   onPressed: () {
// //     runSpeedtestCLI();
// //   },
// //   child: Text('Run Speedtest'),
// // )

// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:flutter_spinkit/flutter_spinkit.dart';

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

  final Color leftBarColor = Colors.red;
  final Color rightBarColor = Colors.red;
  final Color avgColor = Colors.orange;

  @override
  State<Dashview> createState() => _DashviewState();
}

class _DashviewState extends State<Dashview> {
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;
  Map<String, String> networkData = {};
  int currentIndex = 0; // Keep track of the currently displayed item
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
  ];

  Future<void> rebootRouter() async {
    // Make HTTP request to reboot router
    // Replace <API_ENDPOINT> with your Mikrotik API endpoint
    final response = await http.post(
      Uri.parse('http://${widget.ipAddress}/rest/system/reboot'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
      },
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Dashview(
            ipAddress: widget.ipAddress,
            username: widget.username,
            password: widget.password,
          ),
        ),
      );
    } else {
      print('Failed to send reboot request');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    // Add any additional logic or error handling here
  }

  late StreamController<Map<String, String>> _networkDataController;
  late Timer _timer; // Add a Timer

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when disposing
    _networkDataController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _networkDataController = StreamController<Map<String, String>>.broadcast();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      fetchNetworkData(); // Fetch data every second
    });
    final barGroup1 = makeGroupData(0, 5, 12);
    final barGroup2 = makeGroupData(1, 16, 12);
    final barGroup3 = makeGroupData(2, 18, 5);
    final barGroup4 = makeGroupData(3, 20, 16);
    final barGroup5 = makeGroupData(4, 17, 6);
    final barGroup6 = makeGroupData(5, 19, 1.5);
    final barGroup7 = makeGroupData(6, 10, 1.5);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  Stream<Map<String, String>> get networkDataStream =>
      _networkDataController.stream;

  // Function to check internet availability
  Future<bool> checkInternetAvailability() async {
    try {
      final result = await Process.run(
          'ping', ['8.8.8.8', '-c', '4']); // Ping Google's DNS server 4 times
      if (result.exitCode == 0) {
        return true; // Internet is available
      } else {
        return false; // Internet is not available
      }
    } catch (e) {
      return false; // An error occurred, consider it as no internet
    }
  }

  Future<void> fetchNetworkData() async {
    NetworkInfo networkInfo = networkInfoList[currentIndex];
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
          if (await checkInternetAvailability()) {
            if (responseBody != null && responseBody.length > 0) {
              data = responseBody[0]['bandwidth'];
            } else {
              data = 'N/A';
            }
          } else {
            data = 'Internet Not Available'; // Set data accordingly
          }
        }

        networkData[networkInfo.title] = data;
        _networkDataController.sink.add(networkData);
      } else {
        // Handle error case
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
      // Handle error case
    }
  }

  void _nextItem() {
    if (currentIndex < networkInfoList.length - 1) {
      currentIndex++;
      fetchNetworkData();
    }
  }

  void _previousItem() {
    if (currentIndex > 0) {
      currentIndex--;
      fetchNetworkData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 650,
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(9.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'MyNetwork',
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16.0),
              StreamBuilder<Map<String, String>>(
                stream: networkDataStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SpinKitPouringHourGlass(
                          color: Colors.black, // Customize the color
                          size: 60.0, // Customize the size
                        ),
                        SizedBox(height: 10),
                        Text(
                          'LOADING',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w400),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Column(
                      children: [
                        Container(
                          height: 100,
                          width: 200,
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
                                  Icons.network_check,
                                  color: Colors.black87,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Internet Availability',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  snapshot.data?['Internet Availability'] ??
                                      'Loading...',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                              backgroundColor: Colors.black,
                              onPressed: _previousItem,
                              child: Icon(Icons.arrow_back),
                            ),
                            SizedBox(width: 10),
                            NetworkItem(
                              icon: networkInfoList[currentIndex].icon,
                              title: networkInfoList[currentIndex].title,
                              response: snapshot.data?[
                                      networkInfoList[currentIndex].title] ??
                                  'Loading...',
                            ),
                            SizedBox(width: 10),
                            FloatingActionButton(
                              backgroundColor: Colors.black,
                              onPressed: _nextItem,
                              child: Icon(Icons.arrow_forward),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
              SizedBox(
                height: 9,
              ),
              SizedBox(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Weekly Data Usage',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Chip(
                        label: Text(
                          'Download',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.red,
                      ),
                      Chip(
                        label: Text(
                          'Upload',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: BarChart(
                    BarChartData(
                      maxY: 20,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.grey,
                          getTooltipItem: (a, b, c, d) => null,
                        ),
                        touchCallback: (FlTouchEvent event, response) {
                          if (response == null || response.spot == null) {
                            setState(() {
                              touchedGroupIndex = -1;
                              showingBarGroups = List.of(rawBarGroups);
                            });
                            return;
                          }

                          touchedGroupIndex =
                              response.spot!.touchedBarGroupIndex;

                          setState(() {
                            if (!event.isInterestedForInteractions) {
                              touchedGroupIndex = -1;
                              showingBarGroups = List.of(rawBarGroups);
                              return;
                            }
                            showingBarGroups = List.of(rawBarGroups);
                            if (touchedGroupIndex != -1) {
                              var sum = 0.0;
                              for (final rod
                                  in showingBarGroups[touchedGroupIndex]
                                      .barRods) {
                                sum += rod.toY;
                              }
                              final avg = sum /
                                  showingBarGroups[touchedGroupIndex]
                                      .barRods
                                      .length;

                              showingBarGroups[touchedGroupIndex] =
                                  showingBarGroups[touchedGroupIndex].copyWith(
                                barRods: showingBarGroups[touchedGroupIndex]
                                    .barRods
                                    .map((rod) {
                                  return rod.copyWith(
                                      toY: avg, color: widget.avgColor);
                                }).toList(),
                              );
                            }
                          });
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: bottomTitles,
                            reservedSize: 42,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            interval: 1,
                            getTitlesWidget: leftTitles,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBarGroups,
                      gridData: const FlGridData(show: false),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          'Reboot',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: const Text(
                          'Do you really want to reboot your router?',
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              rebootRouter();
                            },
                            child: const Text(
                              'Reboot',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  'Reboot Router',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, [
    double width = 22,
    double spacing = 6,
  ]) {
    // Choose the desired color for the bar here.
    const colors = [Colors.red, Colors.green, Colors.blue, Colors.yellow];

    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        toY: y,
        width: width,
        color: colors[x.toInt()],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
      ),
    ]);
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromARGB(255, 13, 18, 25),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '1GB';
    } else if (value == 10) {
      text = '5GB';
    } else if (value == 19) {
      text = '10+';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Mn', 'Te', 'Wd', 'Tu', 'Fr', 'St', 'Su'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color.fromARGB(255, 13, 18, 25),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }
}

class NetworkItem extends StatelessWidget {
  const NetworkItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.response,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String response;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
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
    );
  }
}
