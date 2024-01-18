import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:mynetwork/screens/wifidetails.dart';

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
  bool _isMounted = false;

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> deleteWifi() async {
    final response = await http.delete(
        Uri.parse('http://${widget.ipAddresses}/rest/interface/wireless/two'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
        });

    final response2 = await http.delete(
      Uri.parse(
          'http://${widget.ipAddresses}/rest/interface/wireless/security-profiles/two'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
      },
    );

    if (response.statusCode == 204 && response2.statusCode == 204) {
      print('Delete Wi-Fi Complete');
    } else {
      print('${response.statusCode}' + '${response.reasonPhrase}');
      print('${response2.statusCode}' + '${response2.reasonPhrase}');
      print('Failed To Delete Wi-Fi');
    }
  }

  // Future<void> deleteSecurity() async {
  //   final response2 = await http.delete(
  //     Uri.parse(
  //         'http://${widget.ipAddresses}/rest/interface/wireless/security-profiles/two'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization':
  //           'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
  //     },
  //   );

  //   if (response2.statusCode == 204) {
  //     print('Delete Security-Profile Complete');
  //     print(response2);
  //   } else {
  //     print(response2.statusCode);
  //     print(response2.reasonPhrase);
  //     print('Failed To Security-Profile Delete');
  //   }
  // }

  Future<void> fetchWiFiNetworks() async {
    final response = await http.get(
        Uri.parse('http://${widget.ipAddresses}/rest/interface/wireless'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
        });
    final securityProfilesResponse = await http.get(
        Uri.parse(
            'http://${widget.ipAddresses}/rest/interface/wireless/security-profiles'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
        });

    if (response.statusCode == 200 &&
        securityProfilesResponse.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<dynamic> securityProfiles =
          json.decode(securityProfilesResponse.body);
      final updatedNetworks = data.map((item) {
        final network = WiFiNetwork.fromJson(item);
        network.securityProfile =
            getSecurityProfileForNetwork(securityProfiles, network.name);
        return network;
      }).toList();

      if (_isMounted) {
        setState(() {
          networks = updatedNetworks;
          networks = networks.reversed.toList();
        });
      }
    } else {
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      if (_isMounted) {
        throw Exception('Failed to load WiFi networks');
      }
    }
  }

  String getSecurityProfileForNetwork(
      List<dynamic> securityProfiles, String networkName) {
    final securityProfile = securityProfiles.firstWhere(
      (profile) => profile['name'] == networkName,
      orElse: () => null,
    );
    return securityProfile != null
        ? securityProfile['wpa2-pre-shared-key']
        : "Test1234";
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
            content: Container(
              height: MediaQuery.sizeOf(context).height * 0.25,
              child: Column(
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
                    decoration:
                        InputDecoration(labelText: 'WPA2 Pre-Shared Key'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    fetchWiFiNetworks();

    Timer.periodic(Duration(seconds: 1), (_) {
      fetchWiFiNetworks();
    });
  }

  @override
  Widget build(BuildContext context) {
    networks.sort((a, b) => a.name.compareTo(b.name));
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
                color: Colors.white,
                icon: Icon(Icons.arrow_back),
              ),
            )),
        toolbarHeight: 130,
        backgroundColor: Color.fromARGB(255, 218, 32, 40),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            // alignment: Alignment.centerLeft,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              child: const Icon(
                color: Colors.black,
                Icons.add,
                size: 50,
              ),
              onPressed: () {
                showAddNetworkDialog(context);
              },
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: networks.length,
        itemBuilder: (BuildContext context, int index) {
          return WiFiNetworkCard(
            network: networks[index],
            index: index,
            ipAddresses: widget.ipAddresses,
            ipUsername: widget.ipUsername,
            ipPassword: widget.ipPassword,
          );
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
  String securityProfile;

  WiFiNetwork({
    required this.name,
    required this.ssid,
    this.securityProfile = "No Security Profile",
  });

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
          title: Text(widget.network.name),
          subtitle: Text(
              'SSID: ${widget.network.ssid} \n ${widget.network.securityProfile} '),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // deleteWirelessNetworkAndSecurityProfile(widget.network.name);
              deleteWifi(widget.network.name);
            },
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
              ssid: widget.network.ssid,
              Profile: widget.network.securityProfile,
              index: widget.index,
            ),
          ),
        );
      },
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

  Future<void> deleteWifi(String networkName) async {
    final response = await http.delete(
        Uri.parse(
            'http://${widget.ipAddresses}/rest/interface/wireless/$networkName'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
        });

    final response2 = await http.delete(
      Uri.parse(
          'http://${widget.ipAddresses}/rest/interface/wireless/security-profiles/$networkName'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
      },
    );

    if (response.statusCode == 204 && response2.statusCode == 204) {
      print('Delete Wi-Fi Complete');
    } else {
      print('${response.statusCode}' + '${response.reasonPhrase}');
      print('${response2.statusCode}' + '${response2.reasonPhrase}');
      print('Failed To Delete Wi-Fi');
    }
  }
}
