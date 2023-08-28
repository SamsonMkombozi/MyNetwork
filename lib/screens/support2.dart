import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SupportM extends StatefulWidget {
  const SupportM({super.key});

  @override
  State<SupportM> createState() => _SupportMState();
}

class _SupportMState extends State<SupportM> {
  final nameController = TextEditingController();
  final controllerTo = TextEditingController();
  final controllerSubject = TextEditingController();
  final controllerMessage = TextEditingController();

  final _key = GlobalKey<FormState>();

  // sendEmail(String subject, String body, String recipientemail) async {
  //   final Email email = Email(
  //     body: body,
  //     subject: subject,
  //     recipients: [recipientemail],
  //     isHTML: false,
  //   );
  //   await FlutterEmailSender.send(email);
  // }

  Future<void> sendEmail() async {
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    const serviceId = "service_a042gdq";
    const templateId = "template_pow7678";
    const userId = "GRE1QCwtRtq-J6quG";

    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "service_id": serviceId,
            "template_id": templateId,
            "userId": userId,
            "template_params": {
              "name": nameController.text,
              "subject": controllerSubject.text,
              "message": controllerMessage.text,
              "user_email": controllerTo.text
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
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Email Not Sent'),
            content: Text('An error occurred: $e'),
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
      appBar: AppBar(
        title: Text('Support'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _key,
          child: Column(children: [
            buildTextField(title: 'Email', controller: controllerTo),
            const SizedBox(
              height: 16,
            ),
            buildTextField(title: 'Name', controller: nameController),
            const SizedBox(
              height: 16,
            ),
            buildTextField(title: 'Subject', controller: controllerSubject),
            const SizedBox(
              height: 16,
            ),
            buildTextField(
              title: 'Message',
              controller: controllerMessage,
              maxLines: 8,
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
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

  // Future launchEmail({
  //   required String toEmail,
  //   required String subject,
  //   required String message,
  // }) async {
  //   final url =
  //       'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(message)}';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     print(errorMessage);
  //     print('lolo');
  //   }
  // }

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
