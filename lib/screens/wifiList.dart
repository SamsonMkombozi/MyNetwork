import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:mynetwork/screens/wifi.dart';

class WiFiListPage extends StatefulWidget {
  final String ipAddresses;
  final String ipUsername;
  final String ipPassword;
  final String username;
  final String password;

  const WiFiListPage({
    Key? key,
    required this.ipAddresses,
    required this.ipUsername,
    required this.ipPassword,
    required this.username,
    required this.password,
  }) : super(key: key);

  @override
  _WiFiListPageState createState() => _WiFiListPageState();
}

class _WiFiListPageState extends State<WiFiListPage> {
  List<WiFiNetwork> networks = [];
  late StreamController<List<WiFiNetwork>> _networksStreamController;
  late Stream<List<WiFiNetwork>> _networksStream;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _networksStreamController = StreamController<List<WiFiNetwork>>();
    _networksStream = _networksStreamController.stream;

    fetchWiFiNetworks();

    Timer.periodic(Duration(seconds: 1), (_) {
      fetchWiFiNetworks();
    });
  }

  @override
  void dispose() {
    _isMounted = false;
    _networksStreamController.close();
    super.dispose();
  }

  Future<void> fetchWiFiNetworks() async {
    final response = await http.get(
      Uri.parse('http://${widget.ipAddresses}/rest/interface/wireless'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final updatedNetworks =
          data.map((item) => WiFiNetwork.fromJson(item)).toList();

      if (_isMounted) {
        setState(() {
          networks = updatedNetworks;
        });
        _networksStreamController.add(updatedNetworks);
      }
    } else {
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      if (_isMounted) {
        throw Exception('Failed to load WiFi networks');
      }
    }
  }

  Future<void> showAddNetworkDialog(BuildContext context) async {
    final networkName = TextEditingController();
    final ssid = TextEditingController();
    final preSharedKey = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New WiFi Network'),
          content: Column(
            children: <Widget>[
              TextField(
                controller: networkName,
                decoration: InputDecoration(labelText: 'Network Name'),
              ),
              TextField(
                controller: ssid,
                decoration: InputDecoration(labelText: 'SSID'),
              ),
              TextField(
                controller: preSharedKey,
                decoration: InputDecoration(labelText: 'WPA2 Pre-Shared Key'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await addWiFiNetwork(
                    networkName: networkName.text,
                    ssid: ssid.text,
                    preSharedKey: preSharedKey.text,
                  );

                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error $e');
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showAddNetworkDialog(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<List<WiFiNetwork>>(
        stream: _networksStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final networkList = snapshot.data;
            return ListView.builder(
              itemCount: networkList?.length,
              itemBuilder: (context, index) {
                return WiFiNetworkCard(
                  network: networkList![index],
                  index: index,
                  ipAddresses: widget.ipAddresses,
                  ipUsername: widget.ipUsername,
                  ipPassword: widget.ipPassword,
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<void> addWiFiNetwork({
    required String networkName,
    required String ssid,
    required String preSharedKey,
  }) async {
    try {
      final baseUrl = 'http://${widget.ipAddresses}/rest';
      final commonHeaders = {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
      };

      final securityProfileEndpoint =
          '/interface/wireless/security-profiles/add';
      final securityProfileBody = {
        'name': networkName,
        'authentication-types': 'wpa2-psk',
        'mode': 'dynamic-keys',
        'wpa2-pre-shared-key': preSharedKey,
      };
      final securityProfileResponse = await http.post(
        Uri.parse('$baseUrl$securityProfileEndpoint'),
        headers: commonHeaders,
        body: jsonEncode(securityProfileBody),
      );

      if (securityProfileResponse.statusCode != 200) {
        throw Exception('Failed to create security profile');
      }

      final wifiNetworkEndpoint = '/interface/wireless/add';
      final wifiNetworkBody = {
        'name': networkName,
        'ssid': ssid,
        'mode': 'ap-bridge',
        'master-interface': 'wlan1',
        'security-profile': networkName,
      };
      final wifiNetworkResponse = await http.post(
        Uri.parse('$baseUrl$wifiNetworkEndpoint'),
        headers: commonHeaders,
        body: jsonEncode(wifiNetworkBody),
      );

      if (wifiNetworkResponse.statusCode != 200) {
        throw Exception('Failed to create WiFi network');
      }

      await fetchWiFiNetworks();
    } catch (e) {
      print('Error: $e');
    }
  }
}

class WiFiNetwork {
  final String name;
  final String ssid;

  WiFiNetwork({required this.name, required this.ssid});

  factory WiFiNetwork.fromJson(Map<String, dynamic> json) {
    return WiFiNetwork(
      name: json['name'],
      ssid: json['ssid'],
    );
  }
}

class WiFiNetworkCard extends StatefulWidget {
  final WiFiNetwork network;
  final String ipAddresses;
  final String ipUsername;
  final String ipPassword;
  final int index;

  WiFiNetworkCard({
    required this.network,
    required this.ipAddresses,
    required this.ipUsername,
    required this.ipPassword,
    required this.index,
  });

  @override
  _WiFiNetworkCardState createState() => _WiFiNetworkCardState();
}

class _WiFiNetworkCardState extends State<WiFiNetworkCard> {
  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Card(
          child: ListTile(
            title: Text(widget.network.name + ' (${widget.index})'),
            subtitle: Text('SSID: ${widget.network.ssid}'),
            trailing: Switch(
              activeColor: Colors.black,
              onChanged: (bool value) {
                setState(() {
                  isEnabled = value;
                  toggleWirelessStatus(widget.index, isEnabled);
                });
              },
              value: isEnabled,
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyWifiWidget(
                ipAddresses: widget.ipAddresses,
                ipUsername: widget.ipUsername,
                ipPassword: widget.ipPassword,
              ),
            ),
          );
        });
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
        body: json.encode({'numbers': '$index'}),
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
}
