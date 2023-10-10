import 'dart:convert';
import 'dart:io';
// import 'package:esp_smartconfig/esp_smartconfig.dart';
import 'package:flutter/material.dart';
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
  bool hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    fetchWifiDetails();
  }

  Future<void> fetchWifiDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://${widget.ipAddress}/rest/interface/wireless'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
        },
      );
      final pass = await http.get(
        Uri.parse(
            'http://${widget.ipAddress}/rest/interface/wireless/security-profiles'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
        },
      );

      if (response.statusCode == 200 && pass.statusCode == 200) {
        final data = json.decode(response.body);
        final pw = json.decode(pass.body);
        setState(() {
          wifiUsername = data[0]['ssid'].toString();
          wifiPassword = pw[0]['wpa-pre-shared-key'].toString();
          unameController.text = wifiUsername;
          pwordController.text = wifiPassword;
        });
      } else {
        final snackBar = SnackBar(
          content: Text(
            'Error: ${response.statusCode} ${response.body}',
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print('Failed to fetch WiFi details');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> editWifiDetails(String newUsername, String newPassword) async {
    try {
      final requestBody = {
        'numbers': 0,
        'ssid': newUsername,
      };

      final requestBody1 = {
        'numbers': 0,
        'wpa-pre-shared-key': newPassword,
      };

      final response = await http.post(
        Uri.parse('http://${widget.ipAddress}/rest/interface/wireless/set'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // Handle successful response for the first request
        setState(() {
          wifiUsername = newUsername;
          hasUnsavedChanges = false; // Reset the flag after saving changes
        });
      } else {
        // Handle error response for the first request
        final errorResponse = json.decode(response.body);
        throw Exception(
            'API Error (Change Username): ${errorResponse['message']}');
      }

      final response1 = await http.post(
        Uri.parse(
            'http://${widget.ipAddress}/rest/interface/wireless/security-profiles/set'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
        },
        body: json.encode(requestBody1),
      );

      if (response1.statusCode == 200) {
        // Handle successful response for the second request
        setState(() {
          wifiPassword = newPassword;
        });
      } else {
        // Handle error response for the second request
        final errorResponse1 = json.decode(response1.body);
        throw Exception(
            'API Error (Change Password): ${errorResponse1['message']}');
      }

      final snackBar =
          SnackBar(content: Text('WiFi details updated successfully!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (error) {
      // Handle other errors (e.g., network errors) here
      print('Error: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Failed to Edit WiFi details'),
            content: Text(
              'Error: $error',
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
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Color.fromARGB(255, 218, 32, 40),
              width: 500,
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Transform.scale(
                      scale: 2.5,
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
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'WIFI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 55,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Transform.scale(
                      scale: 2.5,
                      child: Padding(
                        padding: EdgeInsets.only(left: 13),
                        child: PopupMenuButton<String>(
                          color: Colors.white,
                          onSelected: (String value) {
                            if (value == 'save') {
                              // Handle the "Save" action here
                              if (hasUnsavedChanges) {
                                editWifiDetails(
                                  unameController.text,
                                  pwordController.text,
                                );
                                hasUnsavedChanges = false; // Reset the flag
                              }
                            } else if (value == 'share') {
                              _shareQrCode();
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem<String>(
                                value: 'save',
                                enabled:
                                    hasUnsavedChanges, // Enable only if changes are made
                                child: Center(
                                  child: Text('Save'),
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'share',
                                child: Center(
                                  child: Text('Share'),
                                ),
                              ),
                            ];
                          },
                        ),
                      ),
                    ),
                  ),
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.wifi,
                        size: 90,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        'CONNECT',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(height: 13),
                      Container(
                        width: 100,
                        height: 2,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'SSID',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 200,
                        child: TextFormField(
                          controller: unameController,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                          onChanged: (newValue) {
                            setState(() {
                              hasUnsavedChanges = true;
                            });
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 240, 240, 240),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Password',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 200,
                        child: TextFormField(
                          controller: pwordController,
                          textAlign: TextAlign.center,
                          obscureText: !isPasswordVisible,
                          scrollPadding: EdgeInsets.only(left: 6),
                          style: TextStyle(color: Colors.black),
                          onChanged: (newValue) {
                            setState(() {
                              hasUnsavedChanges = true;
                            });
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 240, 240, 240),
                            suffixIcon: IconButton(
                              icon: Icon(isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: QrImageView(
                          data:
                              'WIFI:S:${unameController.text};T:WPA;P:${pwordController.text};;',
                          version: QrVersions.auto,
                          size: 250.0,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        child: Text(
                          'Scan QrCode',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 27,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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

    Share.shareFiles([filePath], text: 'Sharing WiFi QR code');
  }
}

// void main(List<String> arguments) async {
//   final provisioner = Provisioner.espTouchV2();
//   provisioner.listen((response) {
//     print("Device $response has been connected to WiFi");
//   });

//   await provisioner.start(ProvisioningRequest.fromStrings(
//     ssid: "",
//     bssid: "",
//     password: "",
//   ));
//   await Future.delayed(Duration(seconds: 15));
//   provisioner.stop();
//   exit(0);
// }
