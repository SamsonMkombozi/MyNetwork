// // ignore_for_file: must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class Graphs extends StatelessWidget {
//   WebViewController controller = WebViewController()
//     ..setJavaScriptMode(JavaScriptMode.unrestricted)
//     ..setBackgroundColor(const Color(0x00000000))
//     ..setNavigationDelegate(
//       NavigationDelegate(
//         onProgress: (int progress) {
//           // Update loading bar.
//         },
//         onPageStarted: (String url) {},
//         onPageFinished: (String url) {},
//         onWebResourceError: (WebResourceError error) {},
//         onNavigationRequest: (NavigationRequest request) {
//           if (request.url.startsWith('http://localhost/phpmyadmin/')) {
//             return NavigationDecision.prevent;
//           }
//           return NavigationDecision.navigate;
//         },
//       ),
//     )
//     ..loadRequest(Uri.parse('http://localhost/phpmyadmin/'));

//   Graphs({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter WebView',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Flutter WebView'),
//         ),
//         body: WebViewWidget(
//           controller: controller,
//         ),
//       ),
//     );
//   }
// }
