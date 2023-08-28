// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'package:esp_smartconfig/esp_smartconfig.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  TextEditingController bssidController = TextEditingController();
  String wifiCredentials = '';
  String wifiUsername = '';
  String wifiPassword = '';
  String Bssid = '';
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
    final pass = await http.get(
      Uri.parse(
          'http://${widget.ipAddress}/rest/interface/wireless/security-profiles'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final pw = json.decode(pass.body);
      setState(() {
        Bssid = data[0]['mac-address'];
        wifiUsername = data[0]['ssid'];
        wifiPassword = pw[0]['wpa-pre-shared-key'];
        unameController.text = wifiUsername;
        pwordController.text = wifiPassword;
        bssidController.text = Bssid;
        String wifiCredentials = 'WIFI:S:$wifiUsername;T:WPA;P:$wifiPassword;;';
      });
    } else {
      final snackBar = SnackBar(
          content: Text('Error: ${response.statusCode}  ${response.body}'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('failed');
    }
  }

  // Future<void> startProvisioning() async {
  //   final provisioner = Provisioner.espTouchV2();

  //   provisioner.listen((response) {
  //     print("Device $response has been connected to wifi");
  //   });

  //   await provisioner.start(ProvisioningRequest.fromStrings(
  //     ssid: wifiUsername,
  //     bssid: Bssid,
  //     password: wifiPassword,
  //   ));

  //   await Future.delayed(Duration(seconds: 15));

  //   provisioner.stop();

  //   // After the provisioning process, fetch the updated WiFi details
  //   await fetchWifiDetails();
  // }

  // Future<void> editWifiDetails(String newUsername) async {
  //   final requestBody = {
  //     'ssid': newUsername,
  //     //'radio-name': newPassword,
  //   };

  //   final response = await http.post(
  //     Uri.parse('http://${widget.ipAddress}/rest/interface/wireless/set'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization':
  //           'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
  //     },
  //     body: json.encode(requestBody),
  //   );

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       wifiUsername = newUsername;
  //       //wifiPassword = newPassword;
  //     });
  //     final snackBar =
  //         SnackBar(content: Text('WiFi details updated successfully!'));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   } else {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Failed to Edit Wifi details'),
  //           content: Text(
  //             'Error code: ${response.statusCode} .. Status: ${response.reasonPhrase}',
  //           ),
  //           actions: [
  //             TextButton(
  //               child: const Text('OK'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
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
                      width: 90,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'WIFI',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      width: 55,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Transform.scale(
                          scale:
                              2.5, // Adjust this value to increase or decrease the icon size
                          child: Padding(
                            padding: EdgeInsets.only(left: 13),
                            child: IconButton(
                              onPressed: _shareQrCode,
                              icon: Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                            ),
                          )),
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
                            fontWeight: FontWeight.w600, fontSize: 25),
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
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                      Container(
                        height: 50,
                        width: 200,
                        child: TextFormField(
                          controller: unameController,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            // labelText: 'Username',
                            // labelStyle: TextStyle(color: Colors.black),
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
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                      Container(
                        height: 50,
                        width: 200,
                        child: TextFormField(
                          controller: pwordController,
                          // obscureText: !isPasswordVisible,
                          textAlign: TextAlign.center,
                          scrollPadding: EdgeInsets.only(left: 6),
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            // labelText: 'Password',
                            // labelStyle: TextStyle(color: Colors.black),
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
                            // suffixIcon: IconButton(
                            //   icon: Icon(isPasswordVisible
                            //       ? Icons.visibility_off
                            //       : Icons.visibility),
                            //   onPressed: () {
                            //     setState(() {
                            //       isPasswordVisible = !isPasswordVisible;
                            //     });
                            //   },
                            // ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: QrImageView(
                          embeddedImage: const NetworkImage(''),
                          data: '$wifiUsername+$wifiPassword',
                          //  wifiCredentials,

                          version: QrVersions.auto,
                          size: 250.0,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(
                          child: Text(
                        'Scan QrCode',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 27),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ],
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

void main(List<String> arguments) async {
  final provisioner = Provisioner.espTouchV2();
  provisioner.listen((response) {
    print("Device $response has been connected to wifi");
  });

  await provisioner.start(ProvisioningRequest.fromStrings(
    ssid: "",
    bssid: "",
    password: "",
  ));
  await Future.delayed(Duration(seconds: 15));
  provisioner.stop();
  exit(0);
}
// SafeArea(
//           child: SingleChildScrollView(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     child: QrImageView(
//                       embeddedImage: const NetworkImage(''),
//                       data:
//                           'Username\n $wifiUsername\n and \nPassword\n $wifiPassword',
//                       version: QrVersions.auto,
//                       size: 250.0,
//                       backgroundColor: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(
//                       child: Text(
//                     'Scan QrCode',
//                     style: TextStyle(fontWeight: FontWeight.w600, fontSize: 27),
//                   )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Center(
//                     child: Container(
//                       width: 350,
//                       height: 450,
//                       padding: const EdgeInsets.symmetric(horizontal: 19),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15),
//                         border: Border.all(width: 2),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const SizedBox(height: 50),
//                           const Text(
//                             'Main Wifi',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontFamily: 'Poppins',
//                               fontSize: 35,
//                               fontWeight: FontWeight.w600,
//                               // decoration: TextDecoration.underline,
//                             ),
//                           ),
//                           const SizedBox(height: 40),
//                           TextFormField(
//                             controller: unameController,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.black),
//                             decoration: InputDecoration(
//                               labelText: 'Username',
//                               labelStyle: TextStyle(color: Colors.black),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.black),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.black),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 15),
//                           TextFormField(
//                             controller: pwordController,
//                             // obscureText: !isPasswordVisible,
//                             textAlign: TextAlign.center,
//                             scrollPadding: EdgeInsets.only(left: 6),
//                             style: TextStyle(color: Colors.black),
//                             decoration: InputDecoration(
//                               labelText: 'Password',
//                               labelStyle: TextStyle(color: Colors.black),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.black),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.black),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               // suffixIcon: IconButton(
//                               //   icon: Icon(isPasswordVisible
//                               //       ? Icons.visibility_off
//                               //       : Icons.visibility),
//                               //   onPressed: () {
//                               //     setState(() {
//                               //       isPasswordVisible = !isPasswordVisible;
//                               //     });
//                               //   },
//                               // ),
//                             ),
//                           ),
//                           const SizedBox(height: 30),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               SizedBox(
//                                 height: 75,
//                                 child: ElevatedButton.icon(
//                                   onPressed: () =>
//                                       editWifiDetails(unameController.text),
//                                   icon: FaIcon(FontAwesomeIcons.solidEdit,
//                                       size: 60),
//                                   label: Text('Edit'),
//                                   style: ElevatedButton.styleFrom(
//                                     primary: Colors
//                                         .black, // Set your desired button color here
//                                     onPrimary: Colors
//                                         .white, // Set your desired text/icon color here
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 75,
//                                 child: ElevatedButton.icon(
//                                   onPressed: _shareQrCode,
//                                   icon: FaIcon(FontAwesomeIcons.shareFromSquare,
//                                       size: 60),
//                                   label: Text('Share'),
//                                   style: ElevatedButton.styleFrom(
//                                     primary: Colors
//                                         .black, // Set your desired button color here
//                                     onPrimary: Colors
//                                         .white, // Set your desired text/icon color here
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             ),
//           ),
//         ),
