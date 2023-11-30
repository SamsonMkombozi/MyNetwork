import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mynetwork/screens/dashboard.dart';
import 'dart:convert';
import 'package:mynetwork/screens/dashview.dart';

class RouterPage extends StatefulWidget {
  final String ipAddresses;
  final String ipUsername;
  final String ipPassword;
  final String username;
  final String password;

  const RouterPage({
    Key? key,
    required this.ipAddresses,
    required this.ipUsername,
    required this.ipPassword,
    required this.username,
    required this.password,
  }) : super(key: key);

  @override
  _RouterPageState createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {
  String routerName = '';
  String routerOsVersion = '';
  String uploadSpeed = '';
  String downloadSpeed = '';
  String updateStatus = '';
  String routerUpdateVersion = '';
  ImageProvider? _routerImageProvider;
  bool _isFetchingImage = true;

  double _parseSpeed(String speed) {
    double bytes = double.tryParse(speed) ?? 0.0;
    double megabits = bytes / (1024 * 1024); // Convert bytes to megabits
    return megabits;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    // upgradeRouterOs();
    _fetchRouterImage(); // Add this line to fetch the router image.
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('http://${widget.ipAddresses}/rest/system/resource'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
      },
    );

    final response2 = await http.get(
      Uri.parse('http://${widget.ipAddresses}/rest/interface/ethernet'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
      },
    );

    final response3 = await http.get(
      Uri.parse('http://${widget.ipAddresses}/rest/system/package/update'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
      },
    );

    if (response.statusCode == 200 &&
        response2.statusCode == 200 &&
        response3.statusCode == 200) {
      final data = jsonDecode(response.body);
      final data2 = jsonDecode(response2.body);
      final data3 = jsonDecode(response3.body);
      setState(() {
        routerName = data['board-name'];
        routerOsVersion = data['version'];
        downloadSpeed = _parseSpeed(data2[0]['rx-bytes']).toStringAsFixed(2);
        uploadSpeed = _parseSpeed(data2[0]['tx-bytes']).toStringAsFixed(2);
        updateStatus = data3['status'];
        routerUpdateVersion = data3['latest-version'];
      });
    } else {
      print('failed');
    }
  }

  Future<void> upgradeRouterOs() async {
    // Make an HTTP request to upgrade router OS
    final response = await http.post(
      Uri.parse(
          'http://${widget.ipAddresses}/rest/system/package/update/install'),
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
          builder: (context) => Dash(
            ipAddresses: widget.ipAddresses,
            ipUsername: widget.ipUsername,
            ipPassword: widget.ipPassword,
            username: widget.username,
            password: widget.password,
          ),
        ),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Router Upgrade Succesfully'),
            content: Text(
              'Wait for Some Few Seconds',
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
    } else {
      print('Failed to send upgrade request');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    // Add any additional logic or error handling here
  }

  Future<void> rebootRouter() async {
    // Make an HTTP request to reboot router
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
          builder: (context) => Dash(
            ipAddresses: widget.ipAddresses,
            ipUsername: widget.ipUsername,
            ipPassword: widget.ipPassword,
            username: widget.username,
            password: widget.password,
          ),
        ),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Router Reboot Succesfully'),
            content: Text(
              'Wait for Some Few Seconds',
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
    } else {
      print('Failed to send reboot request');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    // Add any additional logic or error handling here
  }

  Future<void> _fetchRouterImage() async {
    // Construct the URL for the router image.
    final routerImageURL = 'https://i.mt.lv/cdn/rb_images/902_hi_res.png';

    try {
      final response = await http.get(Uri.parse(routerImageURL));

      if (response.statusCode == 200) {
        // Get the image provider for the router image.
        final routerImageProvider = MemoryImage(response.bodyBytes);

        // Set the state with the router image provider and indicate that the image has been fetched.
        setState(() {
          _routerImageProvider = routerImageProvider;
          _isFetchingImage = false; // Set to false when image is fetched
        });
      } else {
        print('Failed to fetch router image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching router image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        toolbarHeight: 130,
        backgroundColor: Color.fromARGB(255, 218, 32, 40),
        centerTitle: true,
        leading: Transform.scale(
          scale: 2.5,
          child: Padding(
            padding: EdgeInsets.only(left: 13),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
        ),
        // title: Icon(
        //   Icons.router_rounded,
        //   size: 90,
        //   color: Colors.white,
        // ),
      ),
      body: Center(
        // padding: EdgeInsets.only(left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 8),
                borderRadius: BorderRadius.circular(7.0),
              ),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Padding(
                padding: EdgeInsets.all(9),
                child: Image.asset('lib/Assets/R1.png', fit: BoxFit.cover),
              ),
            ),
            Container(
              width: 350.0,
              height: 366.0,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Mikrotik Router',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '-$routerName-',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'RouterOS Version',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '-$routerOsVersion-',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  Container(
                    width: 250,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 240, 240, 240),
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: Colors.black,
                        width: 3,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(9),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            updateStatus.isNotEmpty
                                ? Text(
                                    updateStatus,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.green),
                                  )
                                : Text(
                                    'No Updates available',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors
                                            .red), // Change color or style as needed
                                  ),
                            updateStatus.isNotEmpty
                                ? Text(
                                    routerUpdateVersion,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.green),
                                  )
                                : SizedBox(), // You can also choose to display nothing for routerUpdateVersion
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 55,
                        width: 110,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Update',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Text(
                                    'Do You Want To update RouterOs?',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        'Yes',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      onPressed: () {
                                        upgradeRouterOs();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    SizedBox(
                                      width: 140,
                                    ),
                                    TextButton(
                                      child: const Text(
                                        'No',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            onPrimary: Colors.black87,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Upgrade',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 55,
                      ),
                      SizedBox(
                        height: 55,
                        width: 110,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Reboot',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Text(
                                    'Do You Want To Reboot Router?',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        'Yes',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      onPressed: () {
                                        rebootRouter();
                                        Navigator.pop(context);
                                      },
                                    ),
                                    SizedBox(
                                      width: 140,
                                    ),
                                    TextButton(
                                      child: const Text(
                                        'No',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            onPrimary: Colors.black87,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Reboot',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
