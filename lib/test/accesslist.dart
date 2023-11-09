// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class AccessListPage extends StatefulWidget {
  const AccessListPage({
    Key? key,
    required this.ipAddresses,
    required this.ipUsername,
    required this.ipPassword,
  }) : super(key: key);

  final String ipAddresses;
  final String ipUsername;
  final String ipPassword;

  @override
  _AccessListPageState createState() => _AccessListPageState();
}

class _AccessListPageState extends State<AccessListPage> {
  List<AccessListItem> accessList = [];
  StreamController<List<AccessListItem>> _accessListStreamController =
      StreamController<List<AccessListItem>>();
  late Timer _timer;
  bool _isLoading = true;
  StreamSubscription<List<AccessListItem>>? _accessListSubscription;

  @override
  void initState() {
    super.initState();
    _accessListSubscription = _accessListStreamController.stream.listen((data) {
      setState(() {
        accessList = data;
        _isLoading = false;
      });
    });
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _fetchAccessList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _accessListSubscription?.cancel();
    _accessListStreamController.close();
    _timer.cancel();
  }

  Future<void> _fetchAccessList() async {
    final response = await http.post(
      Uri.parse(
          'http://${widget.ipAddresses}/rest/interface/wireless/access-list/print'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;

      // Fetch hostnames from the lease table
      final leaseResponse = await http.get(
        Uri.parse('http://${widget.ipAddresses}/rest/ip/dhcp-server/lease'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
        },
      );

      if (leaseResponse.statusCode == 200) {
        final leaseData = json.decode(leaseResponse.body) as List<dynamic>;

        final updatedAccessList = data.map((item) {
          final macAddress = item['mac-address'];
          final leaseItem = leaseData.firstWhere(
            (lease) => lease['mac-address'] == macAddress,
            orElse: () => null,
          );

          final hostName = leaseItem != null ? leaseItem['host-name'] : 'N/A';
          final ipAddress = leaseItem != null ? leaseItem['address'] : 'N/A';

          return AccessListItem(
            macAddress: item['mac-address'],
            hostName: hostName,
            ipAddress: ipAddress,
          );
        }).toList();

        _accessListStreamController.add(updatedAccessList);
      } else {
        // Handle error
        _handleFetchError('Lease Data Fetch Failed', leaseResponse);
      }
    } else {
      // Handle error
      _handleFetchError('Access List Fetch Failed', response);
    }
  }

  void _handleFetchError(String title, http.Response response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(
            'Failed to fetch data. Error code: ${response.statusCode} .. Status: ${response.reasonPhrase}',
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteAccessListItem(int index) async {
    await _fetchAccessList(); // Fetch the latest data from the server

    if (index >= 0 && index < accessList.length) {
      final response = await http.post(
        Uri.parse(
          'http://${widget.ipAddresses}/rest/interface/wireless/access-list/remove',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
        },
        body: json.encode({'numbers': '$index'}),
      );

      if (response.statusCode == 200) {
        setState(() {
          accessList.removeAt(index);
        });
      } else {
        _handleDeleteError(response);
      }
    }
  }

  void _handleDeleteError(http.Response response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Data Delete Failed'),
          content: Text(
            'Failed to delete data. Error code: ${response.statusCode} .. Status: ${response.reasonPhrase}',
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        width: _mediaQuery.size.width * 1,
        height: _mediaQuery.size.height * 1,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Container(
                padding: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.app_blocking_outlined),
                    SizedBox(width: 10),
                    Text(
                      'Blocked Devices',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? SpinKitPianoWave(
                      color: Colors.black, // Customize the color
                      size: 60.0, // Customize the size
                    ) // Display loading indicator
                  : _buildAccessList(), // Display access list
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessList() {
    if (accessList.isEmpty) {
      return Center(
        child: Text(
          'No devices are blocked',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: accessList.length,
      itemBuilder: (context, index) {
        final accessListItem = accessList[index];

        return Card(
          child: ListTile(
            title: Text('${accessListItem.hostName}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${accessListItem.macAddress}'),
                Text('${accessListItem.ipAddress}'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => deleteAccessListItem(index),
            ),
          ),
        );
      },
    );
  }
}

class AccessListItem {
  final String macAddress;
  final String hostName;
  final String ipAddress;

  AccessListItem({
    required this.macAddress,
    required this.hostName,
    required this.ipAddress,
  });
}
