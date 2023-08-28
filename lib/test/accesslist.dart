import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AccessListPage extends StatefulWidget {
  const AccessListPage({
    Key? key,
    required this.ipAddress,
    required this.username,
    required this.password,
  }) : super(key: key);

  final String ipAddress;
  final String password;
  final String username;

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
      setState(() {
        accessList = data
            .map((item) => AccessListItem(
                  indexNo: item['.id'],
                  macAddress: item['mac-address'],
                ))
            .toList();
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
    await fetchAccessList(); // Fetch the latest data from the server

    if (index >= 0 && index < accessList.length) {
      final response = await http.post(
        Uri.parse(
          'http://${widget.ipAddress}/rest/interface/wireless/access-list/remove',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${widget.username}:${widget.password}'))}',
        },
        body: json.encode({'numbers': '$index'}),
      );

      if (response.statusCode == 200) {
        setState(() {
          accessList.removeAt(index);
        });
      } else {
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
                child: ListView.builder(
                  itemCount: accessList.length,
                  itemBuilder: (context, index) {
                    final accessListItem = accessList[index];

                    return Card(
                      child: ListTile(
                        title: Text(accessListItem.indexNo as String),
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
  final String indexNo;

  AccessListItem({
    required this.macAddress,
    required this.indexNo,
  });
}
