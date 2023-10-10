import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PasswordChangePage extends StatefulWidget {
  final String ipAddresses;
  final String username;
  final String password;

  const PasswordChangePage({
    Key? key,
    required this.ipAddresses,
    required this.username,
    required this.password,
  });
  @override
  _PasswordChangePageState createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  Future<void> changePassword() async {
    
    String credentials = '${widget.username}:${widget.password}';
    String encodedCredentials = base64Encode(utf8.encode(credentials));

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $encodedCredentials',
    };

    var request = http.Request(
        'POST',
        Uri.parse(
            'https://bwmgr-api.habari.co.tz/api/habarinodenetworkmanager/resetPassword'));

    final oldPassword = oldPasswordController.text;
    final newPassword = newPasswordController.text;

    request.body = json.encode({
      "ip_address": "${widget.ipAddresses}",
      "old_password": oldPassword,
      "new_password": newPassword,
    });
    request.headers.addAll(headers);

    final response = await http.Client().send(request);

    if (response.statusCode == 200) {
      // Password change successful
      print("Password changed successfully");
    } else {
      // Password change failed
      print("Password change failed: ${response.reasonPhrase}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        toolbarHeight: 130,
        backgroundColor: Color.fromARGB(255, 218, 32, 40),
        centerTitle: true,
        leading: Transform.scale(
          scale: 2.5, // Adjust this value to increase or decrease the icon size
          child: Padding(
            padding: EdgeInsets.only(left: 13),
            child: IconButton(
              onPressed: () {
                // Handle back button press here
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Old Password'),
              ),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'New Password'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromRGBO(0, 0, 0, 1),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: changePassword,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
