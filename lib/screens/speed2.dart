import 'package:flutter/material.dart';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';

class SpeedTestPage1 extends StatefulWidget {
  const SpeedTestPage1({Key? key}) : super(key: key);

  @override
  State<SpeedTestPage1> createState() => _SpeedTestPage1State();
}

class _SpeedTestPage1State extends State<SpeedTestPage1> {
  final speedtest = FlutterInternetSpeedTest();
  double downloadSpeed = 0;
  double uploadSpeed = 0;
  bool loading = false;

  Future<void> _testSpeeds() async {
    setState(() {
      loading = true;
    });

    await speedtest.startTesting(
      downloadTestServer: 'https://fast.com',
      uploadTestServer: 'https://fast.com',
      onProgress: (double percent, TestResult data) {
        // Handle progress updates
      },
      onDone: (download, upload) {
        print('Download speed: ${download.toString()} Mbps');
        print('Upload speed: ${upload.toString()} Mbps');
      },
      onError: (String errorMessage, String speedTestError) {
        // Handle errors
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speed Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Download speed: ${downloadSpeed.toStringAsFixed(2)} Mbps',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Upload speed: ${uploadSpeed.toStringAsFixed(2)} Mbps',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : _testSpeeds,
              child: Text('Start test'),
            ),
          ],
        ),
      ),
    );
  }
}
