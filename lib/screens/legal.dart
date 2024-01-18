// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class LegalPage extends StatelessWidget {
  Widget _bulletText(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ), // Bullet character
        SizedBox(width: 8.0), // Spacing between bullet and text
        Text(
          text,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ), // Text for the item
      ],
    );
  }

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
                color: Colors.white,
                icon: Icon(Icons.arrow_back),
              ),
            )),
        toolbarHeight: 130,
        backgroundColor: Color.fromARGB(255, 218, 32, 40),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Add your legal content here
              Text(
                'LEGAL TERMS',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 14,
              ),
              Text(
                'Introduction',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                'The use of Habari Node LTDs MyNetwork mobile application ("App") is governed by these Terms and Conditions ("Terms"). You accept these Terms by using this App or by downloading, installing, or utilizing it. Please do not use the App if you disagree with these Terms.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                'Habari Node LTD. offers features and capabilities in the app for controlling and keeping an eye on your Internet network. Its an application that works with the Mikrotik API to let you manage, monitor, and configure your ISP network infrastructure.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Eligibility',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                'To use this app, you have to be at least eighteen years old. You guarantee and declare that you are of legal age to enter into a legally binding contract with us by using the App.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 12,
              ),
              // Text(
              //   'User Obligations',
              //   style: TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              // RichText(
              //   text: TextSpan(
              //     children: [
              //       _bulletText(
              //           'By using the App, you consent to abide by all relevant laws and regulations.'),
              //       _bulletText(
              //           'You pledge not to take part in any actions that could damage our network or the services we offer.'),
              //       _bulletText(
              //           'You are accountable for any activities made using your account and for keeping your login credentials secure.'),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                'Your use of the App is also governed by our Privacy Policy, which is available [insert link]. Please review our Privacy Policy to understand how we collect, use, and protect your personal information.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Intellectual Property',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                'The App and its content are protected by intellectual property rights. You may not reproduce, modify, distribute, or create derivative works without our prior written consent.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Termination',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                'We reserve the right to terminate, suspend, or restrict your access to the App at our discretion, with or without notice, for any reason, including, but not limited to, violation of these Terms.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 12,
              ),
              // Text(
              //   'Disclaimers',
              //   style: TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              // RichText(
              //   text: TextSpan(
              //     children: [
              //       _bulletText(
              //           'The App is provided on an "as is" and "as available" basis. We make no warranties, express or implied, regarding its performance or fitness for a particular purpose.'),
              //       _bulletText(
              //           'We are not responsible for any interruption, delay, or failure in providing the services.'),
              //       _bulletText(
              //           'The App may not be available in all locations, and service quality may vary.'),
              //     ],
              //   ),
              // ),

              Text(
                'Limitation of Liability',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                'To the extent permitted by law, we will not be liable for any indirect, special, incidental, consequential, or punitive damages, or any loss of profits or revenues.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Governing Law and Dispute Resolution',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                'The legal framework of [Your Jurisdiction] governs these terms. Any disagreements arising out of or related to these Terms will be settled by either the courts of [Your Jurisdiction] or by binding arbitration, as decided by us.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Changes to Terms',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                'These Terms could change at any time, and we reserve the right to do so. Change notifications will be sent via the app. After the changes go into effect, you must continue using the App in order to accept the new Terms.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                'If you have any questions or concerns about these Terms, please contact us at [Contact Information].',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                'By using the App, you acknowledge that you have read, understood, and agree to be bound by these Terms.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Habari Node LTD.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                '[Date]',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
