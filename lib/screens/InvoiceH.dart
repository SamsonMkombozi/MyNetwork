import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynetwork/drawer/billing/invoice.dart';
import 'package:mynetwork/drawer/billing/reciepts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DemoChoosePlanScreen3 extends StatefulWidget {
  @override
  DemoChoosePlanScreen3State createState() => DemoChoosePlanScreen3State();
}

class DemoChoosePlanScreen3State extends State<DemoChoosePlanScreen3> {
  CarouselController buttonCarouselController = CarouselController();
  int currentPageIndex = 0;
  List<Widget> pages = [
    invoice(),
    Reciept(),
  ];

  // Text(currentPageIndex == 0 ? 'Invoice' : 'Receipts'),
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'BALANCE',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
            ),
            Text(
              '-105 USD-',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        centerTitle: true,
        leading: Transform.scale(
          scale: 2.5,
          child: Padding(
            padding: EdgeInsets.only(left: 13),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.white,
              icon: Icon(Icons.arrow_back),
            ),
          ),
        ),
        toolbarHeight: 100,
        backgroundColor: Color.fromARGB(255, 218, 32, 40),
      ),
      backgroundColor: context.scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CarouselSlider(
            items: pages,
            carouselController: buttonCarouselController,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.72,
              autoPlay: false,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              aspectRatio: 2.0,
              initialPage: currentPageIndex,
              onPageChanged: (index, reason) {
                setState(() {
                  currentPageIndex = index;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 218, 32, 40),
                border: Border.all(
                    color: Color.fromARGB(255, 218, 32, 40), width: 3),
                borderRadius: BorderRadius.circular(30),
              ),
              height: 60,
              width: MediaQuery.of(context).size.width * 0.6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 45,
                    width: 105,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: currentPageIndex == 0
                            ? Colors.white
                            : Color.fromARGB(255, 218, 32, 40),
                        onPrimary: currentPageIndex == 0
                            ? Colors.black87
                            : Colors.white,
                        textStyle: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: currentPageIndex == 0
                                  ? Colors.white
                                  : Color.fromARGB(255, 218, 32, 40),
                              width: 3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        buttonCarouselController.animateToPage(
                          0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.linear,
                        );
                      },
                      child: Text('Invoice'),
                    ),
                  ),
                  Container(
                    height: 45,
                    width: 115,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: currentPageIndex == 1
                            ? Colors.white
                            : Color.fromARGB(255, 218, 32, 40),
                        onPrimary: currentPageIndex == 1
                            ? Colors.black87
                            : Colors.white,
                        textStyle: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: currentPageIndex == 1
                                  ? Colors.white
                                  : Color.fromARGB(255, 218, 32, 40),
                              width: 3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        buttonCarouselController.animateToPage(
                          1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.linear,
                        );
                      },
                      child: Text('Receipts'),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
