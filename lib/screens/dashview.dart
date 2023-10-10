import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
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
    required this.ipAddresses,
    required this.ipUsername,
    required this.ipPassword,
    required this.username,
    required this.password,
  }) : super(key: key);

  final String ipAddresses;
  final String ipUsername;
  final String ipPassword;
  final String username;
  final String password;

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
  Map<String, dynamic> data = {};
  List<Data> barData = [];
  int barInterval = 5;

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
      Uri.parse('http://${widget.ipAddresses}/rest/system/reboot'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
      },
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Dashview(
            ipAddresses: widget.ipAddresses,
            ipUsername: widget.ipUsername,
            ipPassword: widget.ipPassword,
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
      fetchNetworkData();
      fetchData(); // Fetch data every second
    });
    // fetchData();
  }

  Stream<Map<String, String>> get networkDataStream =>
      _networkDataController.stream;

  Future<void> fetchNetworkData() async {
    NetworkInfo networkInfo = networkInfoList[currentIndex];
    String command = networkInfo.command;
    try {
      http.Response response = await http.get(
        Uri.parse('http://${widget.ipAddresses}/rest$command'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
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

  Future<void> fetchData() async {
    String credentials = '${widget.username}:${widget.password}';
    String encodedCredentials = base64Encode(utf8.encode(credentials));
    try {
      Map<String, String> body = {
        "ip_address": "${widget.ipAddresses}",
      };

      String jsonBody = jsonEncode(body);
      final response = await http.post(
        Uri.parse(
            'https://bwmgr-api.habari.co.tz/api/habarinodenetworkmanager/weeklyUtilisation'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $encodedCredentials',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        setState(() {
          data = decodedData;
          barData = updateBarData(decodedData);
        });
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<Data> updateBarData(Map<String, dynamic> apiData) {
    List<Data> barData = [];
    int id = 0;
    final dateFormat = DateFormat('dd/MM');

    for (var date in apiData.keys) {
      double download = apiData[date]['download'].toDouble();
      double upload = apiData[date]['upload'].toDouble();
      String formattedDate = dateFormat.format(DateTime.parse(date));

      Color downloadColor = Colors.amber;
      Color uploadColor = Colors.blue;

      barData.add(Data(
        id: id,
        name: formattedDate,
        y: download,
        y2: upload,
        color: downloadColor,
        color2: uploadColor, // You can set different colors here
      ));
      id++;
    }
    return barData;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Weekly Data Usage',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
                    backgroundColor: Colors.amber,
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
                    backgroundColor: Colors.blue,
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: BarChartWidget(barData: barData),
                ),
              ),

              // Expanded(
              //   child: Card(
              //     elevation: 4,
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(32)),
              //     color: const Color(0xff020227),
              //     child: Padding(
              //       padding: const EdgeInsets.all(8),
              //       child: BarChartWidget(barData: barData),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 16.0),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              //   onPressed: () {
              //     showDialog(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return AlertDialog(
              //           title: const Text(
              //             'Reboot',
              //             style: TextStyle(
              //                 fontSize: 30, fontWeight: FontWeight.w600),
              //             textAlign: TextAlign.center,
              //           ),
              //           content: Text(
              //             'Do You Want To Reboot Router?',
              //             style: TextStyle(
              //                 fontSize: 25, fontWeight: FontWeight.w300),
              //             textAlign: TextAlign.center,
              //           ),
              //           actions: [
              //             Row(
              //               mainAxisSize: MainAxisSize.max,
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //               children: [
              //                 TextButton(
              //                   style: TextButton.styleFrom(
              //                     foregroundColor:
              //                         const Color.fromRGBO(0, 0, 0, 1),
              //                     backgroundColor: Colors.white,
              //                     shape: RoundedRectangleBorder(
              //                       side: const BorderSide(
              //                           color: Colors.black, width: 3),
              //                       borderRadius: BorderRadius.circular(8),
              //                     ),
              //                   ),
              //                   child: const Text(
              //                     'Yes',
              //                     style: TextStyle(
              //                         fontSize: 20,
              //                         fontWeight: FontWeight.w400),
              //                   ),
              //                   onPressed: () {
              //                     rebootRouter();
              //                     Navigator.of(context).pop();
              //                   },
              //                 ),
              //                 TextButton(
              //                   style: TextButton.styleFrom(
              //                     foregroundColor:
              //                         const Color.fromRGBO(0, 0, 0, 1),
              //                     backgroundColor: Colors.white,
              //                     shape: RoundedRectangleBorder(
              //                       side: const BorderSide(
              //                           color: Colors.black, width: 3),
              //                       borderRadius: BorderRadius.circular(8),
              //                     ),
              //                   ),
              //                   child: const Text(
              //                     'No',
              //                     style: TextStyle(
              //                         fontSize: 20,
              //                         fontWeight: FontWeight.w400),
              //                   ),
              //                   onPressed: () {
              //                     Navigator.of(context).pop();
              //                   },
              //                 ),
              //               ],
              //             )
              //           ],
              //         );
              //       },
              //     );
              //   },
              //   child: const Text(
              //     'Reboot',
              //     style: TextStyle(fontSize: 20),
              //   ),
              // ),
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
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  final List<Data> barData;

  BarChartWidget({required this.barData});

  @override
  Widget build(BuildContext context) {
    return BarChart(BarChartData(
      alignment: BarChartAlignment.end,
      maxY: 20,
      groupsSpace: 28,
      barTouchData: BarTouchData(enabled: true),
      titlesData: FlTitlesData(
        topTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: false,
        )),
        rightTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: false,
        )),
        show: true,
        leftTitles: AxisTitles(
          drawBelowEverything: false,
          sideTitles: SideTitles(
            showTitles: true,
            interval: 5,
            getTitlesWidget: (double value, TitleMeta meta) {
              if (value % 5 == 0) {
                return Text(
                  '${value.toInt()}\nGb',
                  style: TextStyle(color: Colors.black),
                );
              }
              return Text('');
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double id, TitleMeta meta) {
              if (id < 0 || id >= barData.length) {
                return Text('');
              }
              final data = barData[id.toInt()];
              return RotatedBox(
                  quarterTurns: 4,
                  child: Text(
                    data.name,
                    style: TextStyle(color: Colors.black),
                  ));
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: true),
      gridData: FlGridData(show: true),
      barGroups: barData
          .map(
            (data) => BarChartGroupData(x: data.id, barsSpace: 2, barRods: [
              BarChartRodData(
                toY: data.y,
                width: 7,
                color: data.color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
              BarChartRodData(
                toY: data.y2,
                width: 7,
                color: data.color2,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ]),
          )
          .toList(),
    ));
  }
}

class Data {
  final int id;
  final String name;
  final double y;
  final double y2;
  final Color color;
  final Color color2;

  Data({
    required this.id,
    required this.name,
    required this.y,
    required this.y2,
    required this.color,
    required this.color2,
  });
}
