// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;

// class Device {
//   final String name;
//   final String ipAddress;

//   Device({required this.name, required this.ipAddress});
// }

// class NotificationCenterPage extends StatefulWidget {
//   final String ipAddress;
//   final String username;
//   final String password;

//   const NotificationCenterPage({
//     Key? key,
//     required this.ipAddress,
//     required this.username,
//     required this.password,
//   }) : super(key: key);
//   @override
//   _NotificationCenterPageState createState() => _NotificationCenterPageState();
// }

// class _NotificationCenterPageState extends State<NotificationCenterPage> {
//   @override
//   void initState() {
//     super.initState();
//     fetchAndSetDevices();
//   }

//   Future<void> fetchAndSetDevices() async {
//     final devices = await fetchDevices();
//     final deviceProvider = Provider.of<DeviceProvider>(context, listen: false);
//     deviceProvider.clearDevices();
//     devices.forEach(deviceProvider.addDevice);
//   }

//   Future<List<Device>> fetchDevices() async {
//     final response = await http.get(
//       Uri.parse(
//           'http://${widget.ipAddress}/rest/interface/wireless/registration-table'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization':
//             'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
//       },
//     );

//     if (response.statusCode == 200) {
//       // Parse the response JSON and create a list of devices
//       final List<dynamic> data = jsonDecode(response.body);
//       return data
//           .map((json) => Device(
//                 name: json['name'],
//                 ipAddress: json['ipAddress'],
//               ))
//           .toList();
//     } else {
//       throw Exception('Failed to fetch devices');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text(
//           'Notification Center',
//           style: TextStyle(
//             color: Colors.white,
//             fontFamily: 'Poppins',
//             fontSize: 30,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Consumer<DeviceProvider>(
//         builder: (context, deviceProvider, child) {
//           final devices = deviceProvider.devices;

//           if (devices.isEmpty) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           return ListView.builder(
//             itemCount: devices.length,
//             itemBuilder: (context, index) {
//               final device = devices[index];
//               return ListTile(
//                 title: Text(device.name),
//                 subtitle: Text(device.ipAddress),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class DeviceProvider extends ChangeNotifier {
//   List<Device> _devices = [];

//   List<Device> get devices => _devices;

//   void addDevice(Device device) {
//     _devices.add(device);
//     notifyListeners();
//   }

// ignore_for_file: unused_local_variable, non_constant_identifier_names, unused_import

//   void clearDevices() {
//     _devices.clear();
//     notifyListeners();
//   }
// }
// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Notiffication extends StatefulWidget {
  // final String ipAddress;
  // final String username;
  // final String password;

  // const SpeedTestPage({
  //   Key? key,
  //   required this.ipAddress,
  //   required this.username,
  //   required this.password,
  // }) : super(key: key);

  @override
  _NotifficationState createState() => _NotifficationState();
}

class _NotifficationState extends State<Notiffication> {
  @override
  void initState() {
    super.initState();
  }

  // Future<void> fetchSpeedTestStatus() async {
  //   final response = await http.get(
  //     Uri.parse('http://${widget.ipAddress}/rest/interface/ethernet'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization':
  //           'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final jsonResponse = json.decode(response.body);
  //     setState(() {
  //       downloadspeed = jsonResponse[0]['rx-bytes'] ?? 'N/A';
  //       uploadspeed = jsonResponse[0]['tx-bytes'] ?? 'N/A';
  //       d = int.tryParse(downloadspeed);
  //       dr = d ~/ 1000000;
  //       u = int.tryParse(uploadspeed);
  //       ur = u ~/ 1000000;
  //     });
  //   } else {
  //     final snackBar = SnackBar(
  //         content: Text('Error: ${response.statusCode}  ${response.body}'));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   }
  // }

  // int parseSpeedString(String speedString) {
  //   int speed = 0;
  //   try {
  //     speed = int.tryParse(speedString) ?? 0;
  //   } catch (e) {
  //     print('Error parsing speed string: $e');
  //   }
  //   return speed ~/ 1000000; // Divide by 1000000 to get the speed in Mbps
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                color: Color.fromARGB(255, 218, 32, 40),
                width: 500,
                height: 200,
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Transform.scale(
                          scale:
                              2.5, // Adjust this value to increase or decrease the icon size
                          child: Padding(
                            padding: EdgeInsets.only(left: 13),
                            child: IconButton(
                              onPressed: () {
                                // Handle back button press here
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 70,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Container(
                color: Color.fromARGB(255, 218, 32, 40),
                width: 500,
                height: 150,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 90),
              child: Align(
                alignment: AlignmentDirectional.center,
                child: Container(
                  width: 350,
                  height: 630,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 2),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Notification',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 180,
                          height: 2,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                        ),
                        SizedBox(height: 20),
                        RectangularContainer(
                          buttonText: 'New Device Connected',
                          onTap: () {},
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class RectangularContainer extends StatelessWidget {
  final String buttonText;
  // final IconData buttonIcon;
  final VoidCallback onTap;

  const RectangularContainer({
    required this.buttonText,
    // required this.buttonIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 80,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Icon(
                //   buttonIcon,
                //   color: Colors.white,
                //   size: 40,
                // ),
                SizedBox(width: 16),
                Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
