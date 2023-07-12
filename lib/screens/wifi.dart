// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class MyWifiWidget extends StatefulWidget {
  final String ipAddress;
  final String username;
  final String password;

  const MyWifiWidget({
    Key? key,
    required this.ipAddress,
    required this.username,
    required this.password,
  }) : super(key: key);

  @override
  _MyWifiWidgetState createState() => _MyWifiWidgetState();
}

class _MyWifiWidgetState extends State<MyWifiWidget> {
  TextEditingController unameController = TextEditingController();
  TextEditingController pwordController = TextEditingController();
  String wifiUsername = '';
  String wifiPassword = '';
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    fetchWifiDetails();
  }

  Future<void> fetchWifiDetails() async {
    final response = await http.get(
      Uri.parse('http://${widget.ipAddress}/rest/interface/wireless'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        wifiUsername = data[0]['ssid'];
        wifiPassword = data[0]['radio-name'];
      });
    } else {
      final snackBar = SnackBar(
          content: Text('Error: ${response.statusCode}  ${response.body}'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('failed');
    }
  }

  Future<void> editWifiDetails(String newUsername, String newPassword) async {
    final requestBody = {
      'ssid': unameController,
      // 'radio-name': pwordController,
    };

    final response = await http.post(
      Uri.parse('http://${widget.ipAddress}/rest/interface/wireless'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      setState(() {
        wifiUsername = unameController as String;
        // wifiPassword = newPassword;
      });
      final snackBar =
          SnackBar(content: Text('WiFi details updated successfully!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Failed to Edit Wifi details'),
            content: Text(
              'Error code: ${response.statusCode} .. Status: ${response.reasonPhrase}',
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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            'MyWifi',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: QrImageView(
                      embeddedImage: const NetworkImage(''),
                      data:
                          'Username\n $wifiUsername\n and \nPassword\n $wifiPassword',
                      version: QrVersions.auto,
                      size: 250.0,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(
                      child: Text(
                    'Scan QrCode',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 27),
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      width: 350,
                      height: 450,
                      padding: const EdgeInsets.symmetric(horizontal: 19),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),
                          const Text(
                            'Main Wifi',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 35,
                              fontWeight: FontWeight.w600,
                              // decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            'Username',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            width: 280,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width: 2),
                            ),
                            child: Center(
                              child: Text(
                                '$wifiUsername',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Password',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.black,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                    width: 280,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(width: 2),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          '${isPasswordVisible ? wifiPassword : '******************'}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colors.black,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            shape: BoxShape
                                                .rectangle, // Set the shape to circle for IconButton with circular border
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 2,
                                            ),
                                          ),
                                          child: Center(
                                            child: IconButton(
                                              padding: EdgeInsets.all(2),
                                              onPressed: () {
                                                setState(() {
                                                  isPasswordVisible =
                                                      !isPasswordVisible;
                                                });
                                              },
                                              icon: Icon(
                                                isPasswordVisible
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 75,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          bool isChecked = false;
                                          return StatefulBuilder(
                                            builder: (BuildContext context,
                                                setState) {
                                              return AlertDialog(
                                                content: Form(
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Text('Modify'),
                                                          TextFormField(
                                                            controller:
                                                                unameController,
                                                            decoration:
                                                                const InputDecoration(
                                                              hintText:
                                                                  "Enter New Username",
                                                            ),
                                                          ),
                                                          // TextFormField(
                                                          //   controller:
                                                          //       pwordController,
                                                          //   decoration:
                                                          //       const InputDecoration(
                                                          //           hintText:
                                                          //               "Enter New Password"),
                                                          // ),
                                                          TextButton(
                                                              child: const Text(
                                                                  'OK'),
                                                              onPressed: () {
                                                                editWifiDetails(
                                                                    wifiUsername,
                                                                    wifiPassword);
                                                              }),
                                                        ]),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        });
                                  },
                                  icon: FaIcon(FontAwesomeIcons.solidEdit,
                                      size: 60),
                                  label: Text('Edit'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors
                                        .black, // Set your desired button color here
                                    onPrimary: Colors
                                        .white, // Set your desired text/icon color here
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 75,
                                child: ElevatedButton.icon(
                                  onPressed: _shareQrCode,
                                  icon: FaIcon(FontAwesomeIcons.shareFromSquare,
                                      size: 60),
                                  label: Text('Share'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors
                                        .black, // Set your desired button color here
                                    onPrimary: Colors
                                        .white, // Set your desired text/icon color here
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _shareQrCode() async {
    final qrPainter = QrPainter(
      data: 'Username\n $wifiUsername\n and \nPassword\n $wifiPassword',
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.M,
      color: Colors.white,
    );

    final qrCodeImage = await qrPainter.toImageData(300);

    final tempDir = Directory.systemTemp;
    final filePath = '${tempDir.path}/qr_code.png';

    File(filePath).writeAsBytesSync(qrCodeImage!.buffer.asUint8List());

    Share.shareFiles([filePath], text: 'Sharing wifi QR code');
  }
}
