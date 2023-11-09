import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter/material.dart';

class SupportM1 extends StatefulWidget {
  const SupportM1({super.key});

  @override
  State<SupportM1> createState() => _SupportM1State();
}

class _SupportM1State extends State<SupportM1> {
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

  // final name = TextEditingController();
  final email = TextEditingController();
  // final subject = TextEditingController();
  final body = TextEditingController();
  String subject = menuItems[0];
  final _key = GlobalKey<FormState>();

  sendEmail(String Subject, String Body, String recipientEmail) async {
    final Email email = Email(
      subject: Subject,
      body: Body,
      recipients: [recipientEmail],
      // cc: ['cc@example.com'],
      // bcc: ['bcc@example.com'],
      // attachmentPaths: ['/path/to/attachment.zip'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
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
            buildTextField(title: 'Your Email', controller: email),
            const SizedBox(
              height: 16,
            ),
            DropdownButtonFormField<String>(
              value: subject,
              items: _dropitems,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() => subject = newValue);
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
            // buildTextField(title: 'Fullname', controller: name),
            // const SizedBox(
            //   height: 16,
            // ),
            buildTextField(
              title: 'Message',
              controller: body,
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
                onPressed: () {
                  _key.currentState!.save();
                  print('${email.text}');
                  sendEmail(subject, body.text, email.text);
                }),
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
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
        ],
      );
}
