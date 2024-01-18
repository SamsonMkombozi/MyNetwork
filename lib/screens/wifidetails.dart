import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class MyWifiWidget extends StatefulWidget {
  final String ipAddresses;
  final String ipUsername;
  final String ipPassword;
  final String ssid;
  final String Profile;
  final int index;

  const MyWifiWidget(
      {Key? key,
      required this.ipAddresses,
      required this.ipUsername,
      required this.ipPassword,
      required this.ssid,
      required this.Profile,
      required this.index})
      : super(key: key);

  @override
  _MyWifiWidgetState createState() => _MyWifiWidgetState();
}

class _MyWifiWidgetState extends State<MyWifiWidget> {
  TextEditingController unameController = TextEditingController();
  TextEditingController pwordController = TextEditingController();
  String wifiUsername = '';
  String wifiPassword = '';
  String securityProfilePassword = '';
  int wifiIndex = 0;
  int securityProfileIndex = 0;
  bool isPasswordVisible = false;
  bool hasUnsavedChanges = false;
  bool isWifiEnabled = true;

  @override
  void initState() {
    super.initState();
    unameController.text = widget.ssid;
    pwordController.text = widget.Profile;
  }

  Future<void> editWifiDetails(String newUsername, String newPassword) async {
    try {
      final requestBody = {
        'numbers': widget.index,
        'ssid': newUsername,
      };

      final requestBody1 = {
        'numbers': widget.index,
        'wpa-pre-shared-key': newPassword,
      };

      final response = await http.post(
        Uri.parse('http://${widget.ipAddresses}/rest/interface/wireless/set'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        setState(() {
          wifiUsername = newUsername;
          hasUnsavedChanges = false;
        });
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(
            'API Error (Change Username): ${errorResponse['message']}');
      }

      final response1 = await http.post(
        Uri.parse(
            'http://${widget.ipAddresses}/rest/interface/wireless/security-profiles/set'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
        },
        body: json.encode(requestBody1),
      );

      if (response1.statusCode == 200) {
        setState(() {
          wifiPassword = newPassword;
          securityProfilePassword = newPassword;
        });
      } else {
        final errorResponse1 = json.decode(response1.body);
        throw Exception(
            'API Error (Change Password): ${errorResponse1['message']}');
      }

      final snackBar =
          SnackBar(content: Text('WiFi details updated successfully!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (error) {
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

  void saveWifiDetails() {
    if (hasUnsavedChanges) {
      editWifiDetails(
        unameController.text,
        pwordController.text,
      );
      hasUnsavedChanges = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Transform.scale(
          scale: 2.5,
          child: Padding(
            padding: EdgeInsets.only(left: 13),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.white,
              icon: Icon(Icons.arrow_back),
            ),
          ),
        ),
        toolbarHeight: 130,
        backgroundColor: Color.fromARGB(255, 218, 32, 40),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Transform.scale(
              scale: 2.5,
              child: Padding(
                padding: EdgeInsets.only(left: 13),
                child: PopupMenuButton<String>(
                  color: Colors.white,
                  iconColor: Colors.white,
                  onSelected: (String value) {
                    if (value == 'Enable') {
                      setState(() {
                        isWifiEnabled = true;
                        toggleWirelessStatus(widget.index, isWifiEnabled);
                      });
                    } else if (value == 'Disable') {
                      setState(() {
                        isWifiEnabled = false;
                        toggleWirelessStatus(widget.index, isWifiEnabled);
                      });
                    } else if (value == 'share') {
                      _shareQrCode();
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        value: isWifiEnabled ? 'Disable' : 'Enable',
                        // enabled: hasUnsavedChanges,
                        child: Center(
                          child: Text(isWifiEnabled ? 'Disable' : 'Enable'),
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
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Container(
            width: MediaQuery.sizeOf(context).width * 1,
            height: MediaQuery.sizeOf(context).height * 1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 2),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.wifi,
                    size: 90,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'WIFI',
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
                  Container(
                    height: 50,
                    width: 220,
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
                        labelText: 'SSID',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 3),
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
                  Container(
                    height: 50,
                    width: 220,
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
                        labelText: 'PASSWORD',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 3),
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 60),
                      primary: Colors.black,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                    ),
                    onPressed: saveWifiDetails,
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                        color: Colors.white,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void toggleWirelessStatus(int index, bool isEnabled) async {
    final endpoint = isEnabled
        ? '/rest/interface/wireless/enable'
        : '/rest/interface/wireless/disable';

    try {
      final response = await http.post(
        Uri.parse('http://${widget.ipAddresses}$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
        },
        body: json.encode({'numbers': widget.index}),
      );

      if (response.statusCode == 200) {
        print(
            'Wireless network $index ${isEnabled ? 'enabled' : 'disabled'} successfully.');
      } else {
        final error = jsonDecode(response.body);
        print('Failed to toggle wireless network status: ${error['message']}');
      }
    } catch (e) {
      print('Error toggling wireless network status: $e');
    }
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
