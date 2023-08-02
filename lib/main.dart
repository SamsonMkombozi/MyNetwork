// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:mynetwork/reuseable_widget/notiffication.dart';
import 'package:mynetwork/screens/splash.dart';
// import 'package:provider/provider.dart';

// void main() {
//   WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//   FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
//   runApp(MyApp());
// }

// whenever your initialization is completed, remove the splash screen:
// FlutterNativeSplash.remove();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}


// ChangeNotifierProvider(
//       create: (context) => DeviceProvider(),
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: SplashScreen(),
//       ),
//     );