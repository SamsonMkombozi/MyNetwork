import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class deviceInfo extends StatefulWidget {
  const deviceInfo({super.key});

  @override
  State<deviceInfo> createState() => _deviceInfoState();
}

class _deviceInfoState extends State<deviceInfo> {
  DeviceInfoPlugin deviceInfor = DeviceInfoPlugin();
  AndroidDeviceInfo? androidInfo;

  Future<AndroidDeviceInfo> getInfo() async {
    return await deviceInfor.androidInfo;
  }

  Future<IosDeviceInfo> getIosInfo() async {
    return await deviceInfor.iosInfo;
  }

  Future<WindowsDeviceInfo> getWinInfor() async {
    return await deviceInfor.windowsInfo;
  }

  Widget showCard(String name, String value) {
    return Card(
      child: ListTile(
        title: Text(
          "$name : $value",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
          child: FutureBuilder<AndroidDeviceInfo>(
              future: getInfo(),
              builder: (context, snapshot) {
                // initialize data if you want to snapshot many times
                final data = snapshot.data!;
                return Column(
                  children: [
                    // use this snapshot if way if you want to specify only once
                    showCard(
                        'version', "${snapshot.data!.version.previewSdkInt}"),

                    showCard('brand', data.brand),
                    showCard('device', data.device),
                    showCard('model', data.model),
                    showCard('manufacturer', data.manufacturer),
                    showCard('product', data.product),
                    showCard('hardware', data.hardware),
                    showCard(
                        'isPhysicalDevice', data.isPhysicalDevice.toString()),
                    showCard('version', data.version.release.toString()),
                  ],
                );
              })),
    );
  }
}
