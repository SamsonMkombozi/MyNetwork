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
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mynetwork/Services/notification_service.dart';
import 'package:mynetwork/reuseable_widget/NotificationButton.dart';
import 'package:mynetwork/screens/router.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notiffication extends StatefulWidget {
  final String ipAddresses;
  final String ipUsername;
  final String ipPassword;

  const Notiffication({
    Key? key,
    required this.ipAddresses,
    required this.ipUsername,
    required this.ipPassword,
  }) : super(key: key);

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
                      child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 1, 0, 0),
                                      child: Material(
                                        color: Colors.transparent,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 247, 233, 233),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12, 12, 12, 12),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 44,
                                                  height: 44,
                                                  decoration: BoxDecoration(
                                                    color: Color(0x4D9489F5),
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Color(0xFF6F61EF),
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                2, 2, 2, 2),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      child: Image.network(
                                                        'https://source.unsplash.com/random/1280x720?user&2',
                                                        width: 44,
                                                        height: 44,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                8, 0, 0, 0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Habari Node',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Plus Jakarta Sans',
                                                            color: Color(
                                                                0xFF15161E),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(0,
                                                                      4, 0, 0),
                                                          child: Text(
                                                            'We are sad to inform you that today You will be having Slow internet due to maintaince, will inform you on any update',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Outfit',
                                                              color: Color(
                                                                  0xFF606A85),
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0,
                                                                          4,
                                                                          0,
                                                                          0),
                                                              child: Text(
                                                                'Mon. July 3rd - 4:12pm',
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Outfit',
                                                                  color: Color(
                                                                      0xFF606A85),
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .chevron_right_rounded,
                                                              color: Color(
                                                                  0xFF606A85),
                                                              size: 24,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ])),
                    ),
                  ),
                ))
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
              Icons.download,
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
