import 'package:flutter/material.dart';

class PreferencePage extends StatefulWidget {
  @override
  _PreferencePageState createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  String _selectedLanguage = 'English';
  Color _selectedColor = Colors.red;

  // List of supported languages
  List<String> _languages = ['English', 'Spanish', 'French'];

  // List of supported theme colors
  List<Color> _colors = [
    Colors.black,
    Colors.red,
  ];

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
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Language'),
            subtitle: Text('Change the app language'),
            leading: Icon(Icons.language),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                });
                // Add logic to change the app language
              },
              items: _languages.map((language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: Text('Theme Color'),
            subtitle: Text('Change the app theme color'),
            leading: Icon(Icons.color_lens),
            trailing: DropdownButton<Color>(
              value: _selectedColor,
              onChanged: (newColor) {
                setState(() {
                  _selectedColor = newColor!;
                });
                // Add logic to change the app theme color
              },
              items: _colors.map((color) {
                return DropdownMenuItem<Color>(
                  value: color,
                  child: Container(
                    width: 20,
                    height: 20,
                    color: color,
                  ),
                );
              }).toList(),
            ),
          ),
          // Add more ListTile widgets for additional settings
        ],
      ),
    );
  }
}
