import 'package:flutter/material.dart';

class PreferencePage extends StatefulWidget {
  @override
  _PreferencePageState createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  String _selectedLanguage = 'English';
  Color _selectedColor = Colors.blue;

  // List of supported languages
  List<String> _languages = ['English', 'Spanish', 'French'];

  // List of supported theme colors
  List<Color> _colors = [
    Colors.blue,
    Colors.green,
    Colors.red,
  ];

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
