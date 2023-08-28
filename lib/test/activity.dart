// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class MikrotikChartPage extends StatefulWidget {
//   // final String ipAddress;
//   // final String username;
//   // final String password;

//   // const MikrotikChartPage({
//   //   Key? key,
//   //   required this.ipAddress,
//   //   required this.username,
//   //   required this.password,
//   // }) : super(key: key);

//   @override
//   _MikrotikChartPageState createState() => _MikrotikChartPageState();
// }

// class _MikrotikChartPageState extends State<MikrotikChartPage> {
//   List<FlSpot> _chartData = [];

//   @override
//   void initState() {
//     super.initState();
//     // Fetch data for the day
//     _fetchDataForDay();
//   }

//   void _fetchDataForDay() async {
//     http
//         .get(
//       Uri.parse('https://gabbascode.000webhostapp.com/get.php'),
//     )
//         .then((response) async {
//       print('Response: ${response.body}');
//       if (response.statusCode == 200) {
//         setState(() {
//           var data = jsonDecode(response.body);
//           print(data.toString());

//           // Added this line to get the bytesIn value from the JSON response
//         });
//       }
//     }).catchError((error) {});
//     // Get the current day.
//     DateTime now = DateTime.now();
//     DateTime startDate = now.subtract(Duration(days: 1));
//     DateTime endDate = now;

//     // Fetch the bandwidth usage data for the current day.
//     List<Map<String, dynamic>> results = await db.query(
//       'SELECT date, bytesin, bytesout FROM bandwidth_usage WHERE date = ?',
//       [startDate],
//     );

//     // Convert the data to FlSpot format and update the state.
//     for (var result in results) {
//       _chartData.add(FlSpot(result['date'].toDouble(), result['bytesin']));
//       _chartData.add(FlSpot(result['date'].toDouble(), result['bytesout']));
//     }

//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Transform.scale(
//             scale:
//                 2.5, // Adjust this value to increase or decrease the icon size
//             child: Padding(
//               padding: EdgeInsets.only(left: 13),
//               child: IconButton(
//                 onPressed: () {
//                   // Handle back button press here
//                   Navigator.of(context).pop();
//                 },
//                 icon: Icon(Icons.arrow_back),
//               ),
//             )),
//         toolbarHeight: 130,
//         backgroundColor: Color.fromARGB(255, 218, 32, 40),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: _buildChart(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildChart() {
//     if (_chartData.isEmpty) {
//       return Center(child: CircularProgressIndicator());
//     }

//     return Container(
//       color: Colors.white,
//       height: 200,
//       width: 400,
//       child: LineChart(
//         LineChartData(
//           gridData: FlGridData(show: true),
//           titlesData: FlTitlesData(show: true),
//           borderData: FlBorderData(show: true),
//           lineBarsData: [
//             LineChartBarData(
//               spots: _chartData,
//               isCurved: true,
//               dotData: FlDotData(show: false),
//               belowBarData: BarAreaData(show: false),
//               color: Colors.black,
//               isStrokeCapRound: true,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
