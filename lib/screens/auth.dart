import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mynetwork/screens/dashboard.dart';

class RouterConnectionPage extends StatefulWidget {
  @override
  _RouterConnectionPageState createState() => _RouterConnectionPageState();
}

class _RouterConnectionPageState extends State<RouterConnectionPage> {
  TextEditingController ipAddressController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String responseMessage = '';

  Future connectToRouter() async {
    String ipAddress = ipAddressController.text;
    String username = usernameController.text;
    String password = passwordController.text;
    String credentials = '$username:$password';
    String encodedCredentials = base64Encode(utf8.encode(credentials));

    http.post(
      Uri.parse('http://$ipAddress/rest/login'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $encodedCredentials',
      },
    ).then((response) {
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Dash(
                    ipAddress: ipAddress,
                    username: username,
                    password: password,
                  )),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text(
                'Connection failed. Error code: ${response.statusCode} .. Status: ${response.reasonPhrase}',
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
      }
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('An error occurred: $error'),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 32, 40),
      body: Center(
        child: Theme(
          data: ThemeData(
            brightness: Brightness.dark,
          ),
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Positioned(
                bottom: 22,
                child: Image.asset(
                  'lib/Assets/Mn-logo2.jpg',
                  width: 300,
                  height: 250,
                ),
              ),
              Container(
                width: 360,
                height: 451,
                // padding: EdgeInsets.only(left: 5, right: 5, bottom: 0),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 2.0),
                        Text(
                          'LogIn',
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 24.0),
                        TextFormField(
                          controller: ipAddressController,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'IP Address',
                            labelStyle: TextStyle(
                              // textAlign: TextAlign.center,
                              color: Colors.black,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: usernameController,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: passwordController,
                          textAlign: TextAlign.center,
                          obscureText: true,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.0),
                        ElevatedButton(
                          onPressed: connectToRouter,
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(200, 60),
                            primary: Colors.black,
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16,
                            ),
                          ),
                          child: Text(
                            'Connect',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(height: 24.0),
                        Text(
                          responseMessage,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
