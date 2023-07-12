import 'package:flutter/material.dart';
import 'package:mynetwork/db/mysql.dart';

class sql extends StatefulWidget {
  const sql({super.key});

  @override
  State<sql> createState() => _sqlState();
}

class _sqlState extends State<sql> {
  var db = new Mysql();
  var mail = '';
  void _getCustomer() {
    var conn;
    db.getConnection().then((conn));
    String sql = 'select customer from etbwmgr.customers where id = 10';
    conn.query(sql).then((results) {
      for (var row in results) {
        setState(() {
          mail = row[0];
        });
      }
    }).catchError((error) {
      // Handle query error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Data Fetch Failed'),
            content: Text('An error occurred while fetching data for $error'),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Align(
          alignment: Alignment.center,
          child: Container(
            color: Colors.white,
            alignment: Alignment.bottomCenter,
            child: Center(
              child: Column(
                children: [
                  Text('Mail: '),
                  Text(
                    mail,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
