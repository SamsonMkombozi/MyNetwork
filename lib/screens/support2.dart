import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SupportM extends StatefulWidget {
  const SupportM({super.key});

  @override
  State<SupportM> createState() => _SupportMState();
}

class _SupportMState extends State<SupportM> {
  static const menuItems = <String>[
    'Trouble Ticketing',
    'Service Ticketing',
    'Personal Ticketing',
    'Others',
  ];
  final List<DropdownMenuItem<String>> _dropitems = menuItems
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  final name = TextEditingController();
  final email = TextEditingController();
  // final subject = TextEditingController();
  final message = TextEditingController();
  String subject1 = menuItems[0];
  final _key = GlobalKey<FormState>();

  Future sendEmail() async {
    const serviceId = "service_a042gdq";
    const templateId = "template_pow7678";
    const userId = "GRE1QCwtRtq-J6quG";
    const accessToken = "XUbQ7YLbLqv00yvUf8adB";

    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "service_id": serviceId,
          "template_id": templateId,
          "user_id": userId,
          "accessToken": accessToken,
          "template_params": {
            "users_subject": subject1,
            "users_email": email.text,
            "users_message": message.text,
            "users_name": name.text,
          },
        }));
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Email Sent'),
            content: Text('Email sent successfully'),
            actions: [
              TextButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Email Not Sent'),
            content: Text(
                'An error occurred while sending Email. Status code: ${response.statusCode}'),
            actions: [
              TextButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
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
      appBar: AppBar(
        title: Text('Make Request'),
        centerTitle: true,
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
        padding: EdgeInsets.all(16),
        child: Form(
          key: _key,
          child: Column(children: [
            const SizedBox(
              height: 16,
            ),
            DropdownButtonFormField<String>(
              value: subject1,
              items: _dropitems,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() => subject1 = newValue);
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Subject',
                labelStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            buildTextField(title: 'Your Email', controller: email),
            const SizedBox(
              height: 16,
            ),
            buildTextField(title: 'Fullname', controller: name),
            const SizedBox(
              height: 16,
            ),
            buildTextField(
              title: 'Message',
              controller: message,
              maxLines: 8,
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: Size.fromHeight(50),
                textStyle: TextStyle(fontSize: 20),
              ),
              child: Text('SEND'),
              onPressed: () => sendEmail(),
            ),
          ]),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String title,
    required TextEditingController controller,
    int maxLines = 1,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
        ],
      );
}
