// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;

// // class MikrotikApiExample extends StatefulWidget {
// //   @override
// //   _MikrotikApiExampleState createState() => _MikrotikApiExampleState();
// // }

// // class _MikrotikApiExampleState extends State<MikrotikApiExample> {
// //   final _ipController = TextEditingController();
// //   final _responseController = TextEditingController();

// //   Future<void> sendApiRequest(String command) async {
// //     final ip = _ipController.text;
// //     final url = Uri.http(ip, '/command');

// //     final response = await http.post(
// //       url,
// //       headers: {'Content-Type': 'application/x-www-form-urlencoded'},
// //       body: {'command': command},
// //     );

// //     if (response.statusCode == 200) {
// //       setState(() {
// //         _responseController.text = response.body;
// //       });
// //     } else {
// //       setState(() {
// //         _responseController.text =
// //             'Error ${response.statusCode}: ${response.reasonPhrase}';
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('MikroTik API Example'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           children: [
// //             TextFormField(
// //               controller: _ipController,
// //               decoration: InputDecoration(labelText: 'MikroTik IP'),
// //             ),
// //             ElevatedButton(
// //               onPressed: () {
// //                 sendApiRequest('/command=system/resource/print');
// //               },
// //               child: Text('Get System Info'),
// //             ),
// //             ElevatedButton(
// //               onPressed: () {
// //                 sendApiRequest('interface print');
// //               },
// //               child: Text('Get Interfaces'),
// //             ),
// //             ElevatedButton(
// //               onPressed: () {
// //                 sendApiRequest('ip firewall filter print');
// //               },
// //               child: Text('Get Firewall Filter Rules'),
// //             ),
// //             // ... add more buttons for other API commands

// //             SizedBox(height: 16.0),
// //             TextFormField(
// //               controller: _responseController,
// //               maxLines: null,
// //               readOnly: true,
// //               decoration: InputDecoration(
// //                 labelText: 'API Response',
// //                 border: OutlineInputBorder(),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';

// void main() {
//   runApp(NetworkApp());
// }

// class NetworkApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Network Page',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: NetworkPage(),
//     );
//   }
// }

// class NetworkPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Network'),
//       ),
//       body: Center(
//         child: Card(
//           child: Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Network Configuration',
//                   style: TextStyle(
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 16.0),
//                 NetworkOption(
//                   icon: Icons.signal_cellular_alt,
//                   title: 'Internet',
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => InternetPage(),
//                       ),
//                     );
//                   },
//                 ),
//                 SizedBox(height: 8.0),
//                 NetworkOption(
//                   icon: Icons.router,
//                   title: 'Network Hardware',
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => NetworkHardwarePage(),
//                       ),
//                     );
//                   },
//                 ),
//                 SizedBox(height: 8.0),
//                 NetworkOption(
//                   icon: Icons.devices,
//                   title: 'Connected Devices',
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ConnectedDevicesPage(),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class NetworkOption extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final VoidCallback onTap;

//   const NetworkOption({
//     required this.icon,
//     required this.title,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(icon),
//       title: Text(
//         title,
//         style: TextStyle(
//           fontSize: 16.0,
//         ),
//       ),
//       onTap: onTap,
//     );
//   }
// }

// class InternetPage extends StatelessWidget {
//   // You can integrate MikroTik API here to get the speed test status
//   // and display it dynamically
//   String getSpeedTestStatus() {
//     // Your implementation here
//     return 'In Progress';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Internet'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Speed Test Status:',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8.0),
//             Text(
//               getSpeedTestStatus(),
//               style: TextStyle(
//                 fontSize: 16.0,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class NetworkHardwarePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Network Hardware'),
//       ),
//       body: Center(
//         child: Text('Network Hardware Page'),
//       ),
//     );
//   }
// }

// class ConnectedDevicesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Connected Devices'),
//       ),
//       body: Center(
//         child: Text('Connected Devices Page'),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

void main() {
  runApp(SettingsApp());
}

class SettingsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings Page',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsOption(
              icon: Icons.settings,
              title: 'App Preferences',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppPreferencesPage(),
                  ),
                );
              },
            ),
            SizedBox(height: 16.0),
            SettingsOption(
              icon: Icons.account_circle,
              title: 'Account',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountPage(),
                  ),
                );
              },
            ),
            SizedBox(height: 16.0),
            SettingsOption(
              icon: Icons.gavel,
              title: 'Legal',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LegalPage(),
                  ),
                );
              },
            ),
            SizedBox(height: 16.0),
            SettingsOption(
              icon: Icons.feedback,
              title: 'Leave Us Feedback',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedbackPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon),
              SizedBox(width: 16.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppPreferencesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Preferences'),
      ),
      body: Center(
        child: Text('App Preferences Page'),
      ),
    );
  }
}

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Center(
        child: Text('Account Page'),
      ),
    );
  }
}

class LegalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Legal'),
      ),
      body: Center(
        child: Text('Legal Page'),
      ),
    );
  }
}

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Us Feedback'),
      ),
      body: Center(
        child: Text('Feedback Page'),
      ),
    );
  }
}
