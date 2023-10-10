import 'package:flutter/material.dart';
// import 'package:kdgaugeview/kdgaugeview.dart';
import 'package:speed_test_dart/classes/classes.dart';
import 'package:speed_test_dart/speed_test_dart.dart';

class SpeedTestPage extends StatefulWidget {
  const SpeedTestPage({Key? key}) : super(key: key);

  @override
  _SpeedTestPageState createState() => _SpeedTestPageState();
}

class _SpeedTestPageState extends State<SpeedTestPage> {
  late SpeedTestDart tester;
  late List<Server> bestServersList;
  late double downloadRate;
  late double uploadRate;
  bool readyToTest = false;
  bool loading = false;
  late double combinedSpeed;
  late double kd = 78.9736367737365338;

  Future<void> setBestServers() async {
    final settings = await tester.getSettings();
    final servers = settings.servers;

    final _bestServersList = await tester.getBestServers(
      servers: servers,
    );

    setState(() {
      bestServersList = _bestServersList;
      readyToTest = true;
    });
  }

  @override
  void initState() {
    super.initState();
    tester = SpeedTestDart();
    bestServersList = [];
    downloadRate = 0;
    uploadRate = 0;
    combinedSpeed = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setBestServers();
    });
  }

  Future<void> _testSpeeds() async {
    setState(() {
      loading = true;
    });

    final _downloadRate =
        await tester.testDownloadSpeed(servers: bestServersList);
    final _uploadRate = await tester.testUploadSpeed(servers: bestServersList);

    combinedSpeed = (_downloadRate + _uploadRate); // Calculate combined speed

    setState(() {
      downloadRate = _downloadRate;
      uploadRate = _uploadRate;
      loading = false;
    });
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
      ),
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: Center(
        child: Align(
          alignment: AlignmentDirectional.center,
          child: Container(
            width: 400,
            height: 630,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  padding: EdgeInsets.zero,
                  child: Icon(
                    Icons.speed,
                    color: Colors.black,
                    size: 300,
                  ),
                  // child: KdGaugeView(
                  //   minSpeed: 0,
                  //   maxSpeed: 100,
                  //   speed: kd,
                  //   animate: true,
                  //   duration: const Duration(seconds: 5),
                  //   alertSpeedArray: const [45, 80, 90],
                  //   alertColorArray: [
                  //     Colors.black,
                  //     Colors.indigo,
                  //     Colors.red,
                  //   ],
                  //   unitOfMeasurementTextStyle: const TextStyle(
                  //       fontSize: 20,
                  //       color: Colors.black,
                  //       fontWeight: FontWeight.w600),
                  //   unitOfMeasurement: "Mbps",
                  //   gaugeWidth: 10,
                  //   fractionDigits: 3,

                  // ),
                ),
                const SizedBox(height: 0),
                const Text(
                  'Current Speed',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  width: 315,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 240, 240, 240),
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (loading)
                        const Column(
                          children: [
                            SizedBox(height: 15),
                            CircularProgressIndicator(
                              color: Colors.black,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Testing Your Current Network speed',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Text(
                              'Download rate\n   ${downloadRate.toStringAsFixed(2)} Mb/s',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 30),
                            Text(
                              'Upload rate\n  ${uploadRate.toStringAsFixed(2)} Mb/s',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: loading || !readyToTest || bestServersList.isEmpty
                      ? null
                      : () async {
                          setState(() {
                            loading = true;
                          });

                          await _testSpeeds();

                          setState(() {
                            loading = false;
                          });
                        },
                  child: const Text('Start'),
                  style: ElevatedButton.styleFrom(
                    primary:
                        readyToTest && !loading ? Colors.black : Colors.white,
                    fixedSize: const Size(200, 60),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
