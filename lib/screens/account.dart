import 'package:flutter/material.dart';
import 'package:mynetwork/screens/changepassword.dart';

class AccountSettingsPage extends StatelessWidget {
  final String ipAddresses;
  final String username;
  final String password;

  const AccountSettingsPage({
    Key? key,
    required this.ipAddresses,
    required this.username,
    required this.password,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Transform.scale(
            scale:
                2.5, // Adjust this value to increase or decrease the icon size
            child: Padding(
              padding: EdgeInsets.only(left: 13),
              child: IconButton(
                onPressed: () {
                  // Handle back button press here
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back),
              ),
            )),
        toolbarHeight: 130,
        backgroundColor: Color.fromARGB(255, 218, 32, 40),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Change Password'),
            subtitle: Text('Change your account password'),
            leading: Icon(Icons.lock),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PasswordChangePage(
                    ipAddresses: ipAddresses,
                    username: username,
                    password: password,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Change Email'),
            subtitle: Text('Change your account email address'),
            leading: Icon(Icons.email),
            onTap: () {
              // Handle change email tap
              // Add your logic here
            },
          ),
          ListTile(
            title: Text('Delete Account'),
            subtitle: Text('Permanently delete your account'),
            leading: Icon(Icons.delete),
            onTap: () {
              // Handle delete account tap
              // Add your logic here
            },
          ),
          // Add more ListTile widgets for additional account settings
        ],
      ),
    );
  }
}
