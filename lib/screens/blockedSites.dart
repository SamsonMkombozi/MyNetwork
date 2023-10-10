// ignore_for_file: unused_local_variable, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class bsites extends StatefulWidget {
  const bsites({
    Key? key,
    required this.ipAddresses,
    required this.ipUsername,
    required this.ipPassword,
  }) : super(key: key);

  final String ipAddresses;
  final String ipUsername;
  final String ipPassword;

  @override
  State<bsites> createState() => _bsitesState();
}

class _bsitesState extends State<bsites> {
  // List<String> blockedUrls = [];
  List<String> firewallRules = [];

  @override
  void initState() {
    super.initState();
    fetchFirewallRules();
  }

  Future<void> fetchFirewallRules() async {
    final response = await http.post(
      Uri.parse('http://${widget.ipAddresses}/rest/ip/firewall/filter/print'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
      },
    );

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      if (data is List) {
        setState(() {
          firewallRules = data
              .map<String>((item) => item['content'] != null
                  ? item['content'].toString()
                  : 'Unknown URL')
              .toList();
        });
      }
    } else {
      // Handle error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Data Fetch Failed'),
            content: Text(
              'Failed to fetch data for . Error code: ${response.statusCode} .. Status: ${response.reasonPhrase}',
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // Function to add a URL to the block list
  Future<void> addBlockedUrl(String url) async {
    final response = await http.post(
      Uri.parse('http://${widget.ipAddresses}/rest/ip/firewall/filter/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
      },
      body: jsonEncode({
        'chain': 'forward',
        'protocol': 'tcp',
        'dst-port': '80,443',
        'content': url,
        'action': 'reject',
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        firewallRules.add(url);
      });
    } else {
      // Handle error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Data Add Failed'),
            content: Text(
              'Failed to fetch data for . Error code: ${response.statusCode} .. Status: ${response.reasonPhrase}',
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // Function to edit a blocked URL
  Future<void> editBlockedUrl(int index, String newUrl) async {
    final response = await http.post(
      Uri.parse('http://${widget.ipAddresses}/rest/ip/firewall/filter/set'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
      },
      body: jsonEncode({
        'numbers': index,
        'content': newUrl,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        firewallRules[index] = newUrl;
      });
    } else {
      // Handle error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Data Edit Failed'),
            content: Text(
              'Failed to fetch data for . Error code: ${response.statusCode} .. Status: ${response.reasonPhrase}',
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // Function to remove a blocked URL
  Future<void> removeBlockedUrl(int index) async {
    final response = await http.post(
      Uri.parse('http://${widget.ipAddresses}/rest/ip/firewall/filter/remove'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${widget.ipUsername}:${widget.ipPassword}'))}',
      },
      body: jsonEncode({
        'numbers': index,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        firewallRules.removeAt(index);
      });
    } else {
      // Handle error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Data Remove Failed'),
            content: Text(
              'Failed to fetch data for . Error code: ${response.statusCode} .. Status: ${response.reasonPhrase}',
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            // alignment: Alignment.centerLeft,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              child: const Icon(
                color: Colors.black,
                Icons.add,
                size: 50,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String newUrl = '';
                    return AlertDialog(
                      title: const Center(
                        child: Text('ADD SITE URL'),
                      ),
                      content: SizedBox(
                        height: 60, // Adjust this value as needed
                        child: Center(
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              newUrl =
                                  value; // Update newUrl with entered value
                            },
                            decoration: InputDecoration(
                              labelText: 'Enter Site URL',
                              labelStyle: const TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 35, bottom: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors
                                      .white, // Set your desired text/icon color here
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Colors.black, width: 3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('CANCEL'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 35, bottom: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors
                                      .white, // Set your desired text/icon color here
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Colors.black, width: 3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('BLOCK'),
                                onPressed: () async {
                                  await addBlockedUrl(newUrl);
                                  // setState(() {
                                  //   firewallRules
                                  //       .add(newUrl); // Add newUrl to the list
                                  // });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: Align(
        alignment: AlignmentDirectional.center,
        child: Container(
          width: 400,
          height: 630,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 2),
          ),
          child: SingleChildScrollView(
            // padding: const EdgeInsets.all(20),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 11, bottom: 11),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: firewallRules.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: Color.fromARGB(255, 240, 240, 240),
                            elevation: 2, // Add elevation for the card shadow
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),

                            child: ListTile(
                                // leading: Text('$index'),
                                title: Text(firewallRules[index]),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            String editedUrl =
                                                firewallRules[index];
                                            return AlertDialog(
                                              title: const Center(
                                                child: Text('EDIT SITE URL'),
                                              ),
                                              content: SizedBox(
                                                height: 60,
                                                child: Center(
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.text,
                                                    initialValue: editedUrl,
                                                    onChanged: (value) {
                                                      editedUrl = value;
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Enter Site URL',
                                                      labelStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.black),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              actions: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 35,
                                                              bottom: 20),
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                              Colors.black,
                                                          backgroundColor:
                                                              Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 3),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                        child: const Text(
                                                            'CANCEL'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 35,
                                                              bottom: 20),
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                              const Color
                                                                  .fromRGBO(
                                                                  0, 0, 0, 1),
                                                          backgroundColor:
                                                              Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 3),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                        child: const Text(
                                                            'UPDATE'),
                                                        onPressed: () async {
                                                          await editBlockedUrl(
                                                              index, editedUrl);
                                                          setState(() {
                                                            firewallRules[
                                                                    index] =
                                                                editedUrl;
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            String deleteUrl =
                                                firewallRules[index];
                                            return AlertDialog(
                                              title: const Center(
                                                child: Text('Delete SITE URL'),
                                              ),
                                              content: const SizedBox(
                                                  height: 60,
                                                  child: Center(
                                                    child: Text(
                                                      'Are You Sure You Want Delete this site ?',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )),
                                              actions: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 35,
                                                              bottom: 20),
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                              Colors.black,
                                                          backgroundColor:
                                                              Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 3),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                        child: const Text(
                                                            'CANCEL'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 35,
                                                              bottom: 20),
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                              const Color
                                                                  .fromRGBO(
                                                                  0, 0, 0, 1),
                                                          backgroundColor:
                                                              Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 3),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                        child: const Text(
                                                            'DELETE'),
                                                        onPressed: () async {
                                                          // setState(() {
                                                          //   firewallRules
                                                          //       .removeAt(
                                                          //           index);
                                                          // });

                                                          removeBlockedUrl(
                                                              index);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                )),
                          );
                        }),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
