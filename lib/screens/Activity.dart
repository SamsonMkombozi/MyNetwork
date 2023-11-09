import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiDataAndGraph extends StatefulWidget {
  final String ipAddresses;
  final String ipUsername;
  final String ipPassword;
  final String username;
  final String password;

  const ApiDataAndGraph({
    Key? key,
    required this.ipAddresses,
    required this.ipUsername,
    required this.ipPassword,
    required this.username,
    required this.password,
  }) : super(key: key);

  @override
  _ApiDataAndGraphState createState() => _ApiDataAndGraphState();
}

class _ApiDataAndGraphState extends State<ApiDataAndGraph> {
  Map<String, dynamic> data = {};
  List<Data> barData = [];
  int barInterval = 5;

  @override
  void initState() {
    super.initState();
    fetchData();
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
    var _mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: Transform.scale(
            scale:
                2.5, // Adjust this value to increase or decrease the icon size
            child: Padding(
              padding: EdgeInsets.only(left: 13),
              child: IconButton(
                onPressed: () {
                  // Handle back button press here
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back),
              ),
            )),
        toolbarHeight: 130,
        backgroundColor: Color.fromARGB(255, 218, 32, 40),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              color: const Color(0xff020227),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Weekly Data Usage (GB)',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
                    Padding(
                      padding: const EdgeInsets.all(22),
                      child: Container(
                        width: _mediaQuery.size.width * 0.9,
                        height: _mediaQuery.size.height * 0.6,
                        child: BarChartWidget(barData: barData),
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  final List<Data> barData;

  BarChartWidget({required this.barData});

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    return BarChart(BarChartData(
      alignment: BarChartAlignment.end,
      maxY: 2,
      groupsSpace: _mediaQuery.size.width * 0.085,
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
        leftTitles: AxisTitles(
          drawBelowEverything: true,
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2, 
            getTitlesWidget: (double value, TitleMeta meta) {
              if (value % 2 == 0) {
                return Text(
                  '${value.toInt()}',
                  style: TextStyle(color: Colors.white),
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
                    style: TextStyle(color: Colors.white),
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
