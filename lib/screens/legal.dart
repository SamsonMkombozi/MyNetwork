import 'package:flutter/material.dart';

class LegalPage extends StatelessWidget {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Add your legal content here
              Text(
                'Legal Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                style: TextStyle(fontSize: 16),
              ),
              // Add more legal content widgets as needed
            ],
          ),
        ),
      ),
    );
  }
}
