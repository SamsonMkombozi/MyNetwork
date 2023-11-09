import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mynetwork/screens/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouterConnectionPage extends StatefulWidget {
  @override
  _RouterConnectionPageState createState() => _RouterConnectionPageState();
}

class _RouterConnectionPageState extends State<RouterConnectionPage> {
  String ipUsername = "";
  String ipPassword = "";
  String routerBrand = "";
  List<dynamic> ipAddresses = [];
  // TextEditingController ipAddressController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> loginAuth() async {
    String username = usernameController.text;
    String password = passwordController.text;
    String credentials = '$username:$password';
    String encodedCredentials = base64Encode(utf8.encode(credentials));

    Map<String, String> body = {
      "brand": "Mikrotik",
      "model": "RB11",
    };

    String jsonBody = jsonEncode(body); // Encode the body as JSON

    try {
      final response = await http.post(
        Uri.parse(
            'https://bwmgr-api.habari.co.tz/api/habarinodenetworkmanager/login'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $encodedCredentials',
        },
        body: jsonBody,
      );

      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody.containsKey('error') &&
            responseBody['error'] == 'Password incorrect') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Login Failed'),
                content: Text('Password is incorrect'),
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
          setState(() {
            ipUsername = responseBody['username'];
            ipPassword = responseBody['password'];
            ipAddresses = responseBody['ip_addresses'];
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Dash(
                ipUsername: ipUsername,
                ipPassword: ipPassword,
                ipAddresses: ipAddresses.join(),
                username: username,
                password: password,
              ),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Response: ${response.body}'),
          ));
        }
      } else {
        print(
            'Connection failed. Error code: ${response.statusCode} .. Status: ${response.reasonPhrase}');
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
    } catch (error) {
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
    }
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('http://$ipAddresses/rest/system/resource'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$ipUsername:$ipPassword'))}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        routerBrand = data['platform'];
      });
    } else {
      // Print the response status code and body in case of an error
      print('Failed to fetch data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
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
                  width: 280,
                  height: 230,
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'LogIn',
                          style: TextStyle(
                            fontSize: 48.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
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
                        ElevatedButton(
                          onPressed: () {
                            loginAuth();
                          },
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

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    checkLoginStatus();
  }
  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  Future<void> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    _isLoggedIn = false;
    notifyListeners();
  }
}

class MyCheckBox extends State<RouterConnectionPage> {
  bool isChecked = false;
  void printMessage() {
    print('user accepted the agreement');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Text(
                'Read Agreement',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.teal,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: isChecked,
                        onChanged: (bool? newValue) {
                          setState(() {
                            isChecked = newValue!;
                          });
                        }),
                    Text(
                      'I have read the agreement and i accept it',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: MaterialButton(
                  onPressed: isChecked ? printMessage : null,
                  child: Text('Confirm'),
                  textColor: Colors.white,
                  color: Colors.blue,
                ),
              )
            ],
          )),
    );
  }
}
