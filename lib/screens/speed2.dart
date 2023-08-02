// import 'package:flutter/material.dart';
// import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   InternetSpeedTest _internetSpeedTest;
//   double _downloadSpeed = 0.0;
//   double _uploadSpeed = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _internetSpeedTest = InternetSpeedTest();
//     _startSpeedTest();
//   }

//   void _startSpeedTest() async {
//     try {
//       SpeedTestResult result = await _internetSpeedTest.startTesting(
//         useFastApi: true,
//         onStarted: () {
//           print('Speed test started');
//         },
//         onCompleted: (TestResult download, TestResult upload) {
//           print('Speed test completed');
//           setState(() {
//             _downloadSpeed = download.download;
//             _uploadSpeed = upload.upload;
//           });
//         },
//         onProgress: (double percent, TestResult data) {
//           print('Speed test in progress: $percent');
//           if (data is TestResultDownload) {
//             _downloadSpeed = data.download;
//           } else if (data is TestResultUpload) {
//             _uploadSpeed = data.upload;
//           }
//         },
//         onError: (String errorMessage, String speedTestError) {
//           print('Speed test error: $errorMessage, $speedTestError');
//         },
//         onDefaultServerSelectionInProgress: () {
//           print('Default server selection in progress');
//         },
//         onDefaultServerSelectionDone: (Client client) {
//           print('Default server selection done: $client');
//         },
//         onDownloadComplete: (TestResult data) {
//           print('Download complete: $data');
//         },
//         onUploadComplete: (TestResult data) {
//           print('Upload complete: $data');
//         },
//         onCancel: () {
//           print('Speed test cancelled');
//         },
//       );
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Speed Test',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Flutter Speed Test'),
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               Text(
//                 'Download Speed: ${_downloadSpeed.toStringAsFixed(2)} Mbps',
//                 style: TextStyle(fontSize: 20),
//               ),
//               Gauge(
//                 value: _downloadSpeed,
//                 minValue: 0,
//                 maxValue: 1000,
//                 width: 200,
//                 height: 200,
//               ),
//               Text(
//                 'Upload Speed: ${_uploadSpeed.toStringAsFixed(2)} Mbps',
//                 style: TextStyle(fontSize: 20),
//               ),
//               Gauge(
//                 value: _uploadSpeed,
//                 minValue: 0,
//                 maxValue: 1000,
//                 width: 200,
//                 height: 200,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
