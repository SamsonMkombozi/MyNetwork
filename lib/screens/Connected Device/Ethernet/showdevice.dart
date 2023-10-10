import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConnectedEtherDevicesPage extends StatefulWidget {
  final String ipAddresses;
  final String ipUsername;
  final String ipPassword;

  const ConnectedEtherDevicesPage({
    Key? key,
    required this.ipAddresses,
    required this.ipUsername,
    required this.ipPassword,
  }) : super(key: key);

  @override
  _ConnectedEtherDevicesPageState createState() =>
      _ConnectedEtherDevicesPageState();
}

class EthernetPort {
  final String name;
  final int portNumber; // Card port number (starts from 1)
  bool isEnabled;

  EthernetPort({
    required this.name,
    required this.portNumber,
    this.isEnabled = true,
  });
}

class _ConnectedEtherDevicesPageState extends State<ConnectedEtherDevicesPage> {
  List<EthernetPort> ethernetPorts = [];

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('http://${widget.ipAddresses}/rest/interface/ethernet'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<EthernetPort> ports = [];

      for (var index = 0; index < data.length; index++) {
        String name = data[index]['name'];
        // Assign Ethernet port numbers starting from 0
        int portNumber = index;
        ports.add(EthernetPort(name: name, portNumber: portNumber));
      }

      setState(() {
        ethernetPorts = ports;
      });
    } else {
      print('Failed to fetch Ethernet port data.');
      print('Response status code: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

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
      body: ListView.builder(
        itemCount: ethernetPorts.length,
        itemBuilder: (context, index) {
          EthernetPort port = ethernetPorts[index];

          return Card(
            child: ListTile(
              title: Text('Name: ${port.name}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display card port numbers starting from 1
                  Text('Port Number: ${port.portNumber + 1}'),
                ],
              ),
              trailing: Switch(
                activeColor: Colors.black,
                onChanged: (bool value) {
                  setState(() {
                    port.isEnabled = value;
                    toggleEthernetPortStatus(port.portNumber, value);
                  });
                },
                value: port.isEnabled,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> toggleEthernetPortStatus(int portNumber, bool enable) async {
    final endpoint = enable
        ? '/rest/interface/ethernet/enable'
        : '/rest/interface/ethernet/disable';

    // Map the portNumber back to card port number (starting from 1)
    final cardPortNumber = portNumber + 0;

    final requestBody = json.encode({
      'numbers': '$cardPortNumber',
    });

    try {
      final response = await http.post(
        Uri.parse('http://${widget.ipAddresses}$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        print(
            'Ethernet port $cardPortNumber ${enable ? 'enabled' : 'disabled'} successfully.');
      } else {
        final error = jsonDecode(response.body);
        print('Failed to toggle Ethernet port status: ${error['message']}');
      }
    } catch (e) {
      print('Error toggling Ethernet port status: $e');
    }
  }
}
