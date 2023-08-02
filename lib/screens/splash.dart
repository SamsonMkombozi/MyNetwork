import 'package:flutter/material.dart';
import 'package:mynetwork/screens/auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay for the splash screen
    Future.delayed(Duration(seconds: 3), () {
      // Navigate to the actual home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RouterConnectionPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 32, 40),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/Assets/Mn-logo2.jpg',
              width: 290,
              height: 240,
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
