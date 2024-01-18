import 'package:flutter/material.dart';
import 'package:mynetwork/reuseable_widget/notiffication.dart';
import 'package:mynetwork/screens/InvoiceH.dart';
import 'package:mynetwork/screens/auth.dart';
import 'package:mynetwork/screens/changepassword.dart';
import 'package:mynetwork/screens/legal.dart';
import 'package:mynetwork/screens/support.dart';
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
    var _mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Drawer(
        width: _mediaQuery.size.width * 1,
        child: Container(
          color: Colors
              .white, // Set the background color of the drawer body to white
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: MediaQuery.sizeOf(context).height * 0.05,
                color: Color.fromARGB(255, 218, 32, 40),
              ),
              Container(
                  width: MediaQuery.sizeOf(context).width * 1,
                  height: MediaQuery.sizeOf(context).height * 0.3,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Card(
                      color: Color.fromARGB(255, 218, 32, 40),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 12),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 2),
                                        color: Colors
                                            .white, // Set the background color of the container
                                        shape: BoxShape
                                            .circle, // Make the container circular
                                      ),
                                      width: 90,
                                      height: 90,
                                      child: Center(
                                        child: Text(
                                          widget.username.isNotEmpty
                                              ? widget.username[0]
                                              : '',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 50, right: 7),
                                    child: IconButton(
                                      onPressed: () {
                                        // Handle back button press here
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(
                                        Icons.arrow_circle_right_outlined,
                                        size: 55,
                                        weight: 200,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                widget.username,
                                style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                widget.ipAddresses,
                                style: TextStyle(
                                    fontSize: 27.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            )
                          ]),
                    ),
                  )),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Container(
                  // padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(6)),
                  child: ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color: Colors.black,
                      size: 40,
                    ),
                    title: Align(
                      child: Text(
                        "Notification",
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Notiffication(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Container(
                  // padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.article_outlined,
                      color: Colors.black,
                      size: 40,
                    ),
                    title: Align(
                      child: Text(
                        "Payment",
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DemoChoosePlanScreen3(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Container(
                  // padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.lock,
                      color: Colors.black,
                      size: 40,
                    ),
                    title: Align(
                      child: Text(
                        "Password",
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
                          builder: (context) => PasswordChangePage(
                            ipAddresses: widget.ipAddresses,
                            username: widget.username,
                            password: widget.password,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Container(
                  // padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.gavel,
                      color: Colors.black,
                      size: 40,
                    ),
                    title: Align(
                      child: Text(
                        "Legal Terms",
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
                          builder: (context) => LegalPage(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(6),
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
                                    'EMAIL US',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  onPressed: () {
                                    // Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SupportM1(),
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
              ),
              SizedBox(
                height: 110,
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
                          child: Text(
                            'LOGOUT',
                            style: TextStyle(color: Colors.white),
                          ),
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
