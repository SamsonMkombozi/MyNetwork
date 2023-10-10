import 'package:flutter/material.dart';
// import 'package:mynetwork/db/DataTableDemo.dart';
import 'package:mynetwork/screens/Subscription.dart';
import 'package:mynetwork/screens/auth.dart';
import 'package:mynetwork/screens/settings.dart';
import 'package:mynetwork/screens/support2.dart';
import 'package:mynetwork/screens/wifiList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class drawp extends StatefulWidget {
  // const drawp({super.key, required ListView child});

  const drawp(
      {Key? key,
      required this.ipAddresses,
      required this.ipUsername,
      required this.ipPassword,
      required this.username,
      required this.password})
      : super(key: key);

  final String ipAddresses;
  final String ipUsername;
  final String ipPassword;
  final String username;
  final String password;

  @override
  State<drawp> createState() => _drawpState();
}

class _drawpState extends State<drawp> {
  final AuthProvider _authProvider = AuthProvider();

  void _launchWhatsApp() async {
    final link = 'whatsapp://send?phone=255767205251';
    if (await launchUrlString('$link')) {
      await launchUrlString('$link');
    } else {
      print('Could not launch WhatsApp');
      throw 'Could not launch WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Drawer(
        child: Container(
          color: Colors
              .white, // Set the background color of the drawer body to white
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountEmail: Text('    ' + widget.username),
                accountName: Text(widget.ipAddresses),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    "A",
                    style: TextStyle(fontSize: 40.0, color: Colors.black),
                  ),
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 218, 32, 40),

                  // Set the background color of the drawer header to black
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                // padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.payment,
                    color: Colors.black,
                    size: 40,
                  ),
                  title: Align(
                    child: Text(
                      "Subscription",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                    size: 40,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DemoChoosePlanScreen3(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                // padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Colors.black,
                    size: 40,
                  ),
                  title: Align(
                    child: Text(
                      "Settings",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                    size: 40,
                  ),
                  onTap: () {
                    // Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Settings(
                          ipAddresses: widget.ipAddresses,
                          ipUsername: widget.ipUsername,
                          ipPassword: widget.ipPassword,
                          username: widget.username,
                          password: widget.password,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                // padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.help_center,
                    color: Colors.black,
                    size: 40,
                  ),
                  title: Align(
                    child: Text(
                      "Get Help",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                    size: 40,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            'HELP & SUPPORT',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          content: Text(
                            'You Can Contact Us for Support Or Make A Request For Your Internet Services!',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w300),
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            Center(
                              child: TextButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Colors.black, width: 3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'MAKE REQUEST',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                                onPressed: () {
                                  // Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SupportM(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: 35,
                            ),
                            Center(
                              child: TextButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Colors.black, width: 3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'CONTACT US',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                                onPressed: _launchWhatsApp,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                // padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.feedback_outlined,
                    color: Colors.black,
                    size: 40,
                  ),
                  title: const Align(
                      alignment: Alignment.center,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "wifi(test)",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      )),
                  trailing: Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                    size: 40,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WiFiListPage(
                                ipAddresses: widget.ipAddresses,
                                ipUsername: widget.ipUsername,
                                ipPassword: widget.ipPassword,
                                username: widget.username,
                                password: widget.password,
                              )),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 200,
              ),
              Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 200,
                        height: 70,
                        child: FloatingActionButton(
                          backgroundColor: Colors.black,
                          onPressed: () async {
                            await _authProvider.logout();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RouterConnectionPage()), // Navigate to LoginPage
                              (route) =>
                                  false, // Remove all previous routes from the stack
                            );
                          },
                          child: Text('LOGOUT'),
                          shape: ContinuousRectangleBorder(),
                        ),
                      )
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    checkLoginStatus();
  }
  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  Future<void> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    _isLoggedIn = false;
    notifyListeners();
  }
}
