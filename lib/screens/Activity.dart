import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:mynetwork/db/employee.dart';

class MikrotikChartPage extends StatefulWidget {
  final String ipAddress;
  final String username;
  final String password;

  const MikrotikChartPage({
    Key? key,
    required this.ipAddress,
    required this.username,
    required this.password,
  }) : super(key: key);

  @override
  _MikrotikChartPageState createState() => _MikrotikChartPageState();
}

class _MikrotikChartPageState extends State<MikrotikChartPage> {
  List<List<FlSpot>> _chartData = [];
  int _selectedTabIndex = 0;
  // var db = new Mysql();
  // var mail = '';

  @override
  void initState() {
    super.initState();
    // Fetch data for the initial tab (Day)
    _fetchDataForTab(0);
  }

  Widget _buildChart(int index) {
    if (_chartData.isEmpty || index >= _chartData.length) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      color: Colors.white,
      height: 200,
      width: 400,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: _chartData[index],
              isCurved: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
              color: Colors.black,
              isStrokeCapRound: true,
            ),
          ],
        ),
      ),
    );
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });

    // Fetch data for the selected tab
    _fetchDataForTab(index);
  }

  Future<void> _fetchDataForTab(int index) async {
    // Replace the following logic with actual API calls to fetch data for each timeline.
    // Use 'widget.ipAddress', 'widget.username', and 'widget.password' for API authentication.
    // You can use any HTTP library (e.g., http package) to make API requests.

    // Dummy data for the line chart for different timelines.
    List<List<double>> dummyData = [
      // Day
      [0, 1000, 2000, 3000, 2500, 1500, 5000],
      // Week
      [0, 2000, 1500, 1000, 3500, 3000, 2000],
      // Month
      [0, 2500, 3000, 2000, 3500, 4500, 5000],
      // Year
      [0, 1500, 1000, 2500, 2000, 3500, 3000],
    ];

    // Convert dummy data to FlSpot format and update the state.
    setState(() {
      _chartData = dummyData
          .map((data) => data
              .asMap()
              .entries
              .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
              .toList())
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
        children: [
          Expanded(
            child: _buildChart(_selectedTabIndex),
          ),
          Container(
            color: Color.fromARGB(255, 218, 32, 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabItem('Day', 0),
                _buildTabItem('Week', 1),
                _buildTabItem('Month', 2),
                _buildTabItem('Year', 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, int index) {
    return InkWell(
      onTap: () {
        _onTabSelected(index);
      },
      child: Container(
        height: 100,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: index == _selectedTabIndex
                  ? Colors.white
                  : Color.fromARGB(255, 218, 32, 40),
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: index == _selectedTabIndex ? Colors.white : Colors.grey,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
