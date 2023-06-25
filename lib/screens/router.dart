import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RouterPage extends StatefulWidget {
  final String ipAddress;
  final String username;
  final String password;
  const RouterPage({
    Key? key,
    required this.ipAddress,
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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Make HTTP request to retrieve router data
    // Replace <API_ENDPOINT> with your Mikrotik API endpoint
    final response = await http.get(
      Uri.parse('http://${widget.ipAddress}/rest/system/resource'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        routerName = data['architecture-name'];
        routerOsVersion = data['version'];
        // uploadSpeed = data['upload_speed'];
        // downloadSpeed = data['download_speed'];
      });
    } else {
      print('failed');
    }
  }

  Future<void> upgradeRouterOs() async {
    // Make HTTP request to upgrade router OS
    // Replace <API_ENDPOINT> with your Mikrotik API endpoint
    await http.post(Uri.parse('<API_ENDPOINT>/upgrade_router_os'));
    // Add any additional logic or error handling here
  }

  Future<void> rebootRouter() async {
    // Make HTTP request to reboot router
    // Replace <API_ENDPOINT> with your Mikrotik API endpoint
    await http.post(Uri.parse('<API_ENDPOINT>/reboot_router'));
    // Add any additional logic or error handling here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Container(
          width: 300.0,
          height: 300.0,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Router Name \n $routerName'),
              Text('RouterOS Version: $routerOsVersion'),
              Text('Upload Speed: $uploadSpeed'),
              Text('Download Speed: $downloadSpeed'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.upgrade),
                    onPressed: upgradeRouterOs,
                  ),
                  IconButton(
                    icon: Icon(Icons.restart_alt),
                    onPressed: rebootRouter,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
