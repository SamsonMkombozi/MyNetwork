import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class DemoChoosePlanScreen3 extends StatefulWidget {
  @override
  DemoChoosePlanScreen3State createState() => DemoChoosePlanScreen3State();
}

class DemoChoosePlanScreen3State extends State<DemoChoosePlanScreen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Invoice'),
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
        backgroundColor: context.scaffoldBackgroundColor,
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Color.fromARGB(255, 70, 71, 77),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      height: MediaQuery.sizeOf(context).height * 0.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  '18/10/2023',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    child: FloatingActionButton(
                                      backgroundColor: Colors.white,
                                      child: const Icon(
                                        weight: 600,
                                        color: Colors.black,
                                        Icons.arrow_downward_rounded,
                                        size: 26,
                                      ),
                                      onPressed: () {},
                                    ),
                                  )),
                            ],
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Payment Invoice',
                                  style: TextStyle(
                                      fontSize: 23.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              )),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  '120 USD',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              )),
                          SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    )),
              ],
            )));
  }
}
