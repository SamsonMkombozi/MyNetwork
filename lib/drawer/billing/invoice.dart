import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class invoice extends StatefulWidget {
  const invoice({super.key});

  @override
  State<invoice> createState() => _invoiceState();
}

class _invoiceState extends State<invoice> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Card(
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
                                  padding: EdgeInsets.all(3),
                                  child: Text(
                                    '105 USD',
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => iView(),
                      ),
                    );
                  },
                ),
              ],
            ))
      ],
    );
  }
}

class iView extends StatefulWidget {
  const iView({super.key});

  @override
  State<iView> createState() => _iViewState();
}

class _iViewState extends State<iView> {
  Future<void> makePayment() async {
    var headers = {
      'Content-Type': 'application/json',
      'Origin': '*',
      'Authorization':
          'Bearer VkhBZT5FfnR0Yjqc/9iUpZ4D8Vj0W6doYviUhkeAePpjZaf6OrmOxciZQKjBn8a3VmRzwmNd6i2bIbG4yhmHRs70EF2xuqSFOFr/Yh6BGkv7UcyXeMtLcLFXHjb6xFaQxBKtX/lt1EdHlc5q+VN08Hdlj4mreASiFd2sy7EmrxM947P/oWzJor5Az/I/fQwi3j784wKAp7w+I1BwbDFYLDO6TWmaVSbc07I39mSMu4rV1n1CdU7F0gcZ8wsYJm8NL81EBQsGdv+LBaiyvHI0dy3arK6YhSggtd3sUkiYEKKleqsNk3afE/C2/wz3ElDIDZ7TkUnvRjUUfaqYdukuwreJ6dzL+VijgCoGZkIsq4p96Dqg9ZLJeKq42LXuvjNmpjUBgeSN+V3LwJJ+ur7Hoa+kRAnbd48+dtXSaLd7eymP2Q9NJC6m9ImZrmst3jKXTWXbjoWVhwfhbeNnYmgsQ9LwHnN/9/6N95vUSYhuCA0KgmqyLU16wZNlC3W72qeBZD4vAyKN1pfCen/ntQEJbdMpgJhK+hUNKHp+Bba7A3lWaV8b0AhVGZygRuHKROtlvJ/TgY776q/fXS2sWXWAxyCiQb52wTnGum4sqpsyiVj8xnc/P0uK41h61I8qj66JigB4OjPfBtkfJTQ6PY3XRZ1EAAmPu35+qgvJjHFxvmY='
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://openapi.m-pesa.com/sandbox/ipg/v2/vodacomTZN/c2bPayment/singleStage/'));
    request.body = json.encode({
      "input_Amount": "10",
      "input_Country": "TZN",
      "input_Currency": "TZS",
      "input_CustomerMSISDN": "255767205251",
      "input_ServiceProviderCode": "000000",
      "input_ThirdPartyConversationID": "asv02e5958774f7ba228d83d0d689761",
      "input_TransactionReference": "T1234C",
      "input_PurchasedItemsDesc": "Shoes"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Color.fromARGB(255, 218, 32, 40),
          leading: Transform.scale(
            scale: 2.5,
            child: Padding(
              padding: EdgeInsets.only(left: 13),
              child: IconButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          width: MediaQuery.sizeOf(context).width * 1,
          height: MediaQuery.sizeOf(context).height * 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 25,
                  left: 25,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Invoice Detail',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 25,
                ),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 1,
                  height: MediaQuery.sizeOf(context).height * 0.3,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          top: BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 3,
                          ))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Amount',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                '52.00 USD',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 27,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 35,
                              ),
                              Text(
                                'Status',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'Due in 2 days',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 22,
                              ),
                              LinearProgressIndicator(
                                color: Colors.black,
                                backgroundColor: Colors.grey,
                                value: 0.8,
                                minHeight: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Invoice No.',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Z692274',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Date',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Nov 11, 2023',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Account No.',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'UO197696',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 40),
                            Text(
                              'Billing City',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Arusha',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 30),
                            Text(
                              'Account Name',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'TENGERU LLC',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 30),
                            Text(
                              'Billing State',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'CO',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              'Previous Charges',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '104 USD',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: 80,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                  width: 200,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black),
                                      onPressed: () {
                                        makePayment();
                                      },
                                      child: Text(
                                        'Pay Now',
                                        style: TextStyle(color: Colors.white),
                                      ))),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
