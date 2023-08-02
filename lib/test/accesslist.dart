// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:mynetwork/screens/conndevices.dart';

class AccessListPage extends StatefulWidget {
  final String ipAddress;
  final String username;
  final String password;

  const AccessListPage({
    Key? key,
    required this.ipAddress,
    required this.username,
    required this.password,
  }) : super(key: key);

  @override
  _AccessListPageState createState() => _AccessListPageState();
}

class _AccessListPageState extends State<AccessListPage> {
  List<AccessListItem> accessList = [];

  @override
  void initState() {
    super.initState();
    fetchAccessList();
  }

  Future<void> fetchAccessList() async {
    final response = await http.post(
      Uri.parse(
          'http://${widget.ipAddress}/rest/interface/wireless/access-list/print'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      final fetchedAccessList = data
          .map((item) => AccessListItem(
                macAddress: item['mac-address'],
                // deviceName: item['device_name'],
              ))
          .toList();

      setState(() {
        accessList = fetchedAccessList;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Data Fetch Failed'),
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
  }

  Future<void> deleteAccessListItem(int index) async {
    // final macAddress = accessList[index].macAddress;
    final response = await http.post(
        Uri.parse(
            'http://${widget.ipAddress}/rest/interface/wireless/access-list/remove'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
        },
        body: json.encode({'numbers': accessList[index].macAddress}));
    // final response = await http.delete(Uri.parse('$apiUrl/$index'));
    if (response.statusCode == 200) {
      setState(() {
        // accessList.removeAt(index);
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Data Fetch Failed'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 320,
          height: 550,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
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
                          // decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ListView.builder(
              //   itemCount: accessList.length,
              //   itemBuilder: (context, index) {
              //     final accessListItem = accessList[index];

              //     return Card(
              //       child: ListTile(
              //         // title: Text(accessListItem.deviceName),
              //         subtitle: Text(accessListItem.macAddress),
              //         trailing: IconButton(
              //           icon: Icon(Icons.delete),
              //           onPressed: () => deleteAccessListItem(index),
              //         ),
              //       ),
              //     );
              //   },
              // ),
              Expanded(
                child: ListView.builder(
                  itemCount: accessList.length,
                  itemBuilder: (context, index) {
                    final accessListItem = accessList[index];

                    return Card(
                      child: ListTile(
                        // title: Text(accessListItem.deviceName),
                        subtitle: Text(accessListItem.macAddress),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteAccessListItem(index),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AccessListItem {
  final String macAddress;
  // final String deviceName;

  AccessListItem({
    required this.macAddress,
    // required this.deviceName,
  });
}
