// ignore_for_file: unused_import, non_constant_identifier_names, unused_label, unused_field

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class QrWidget extends StatefulWidget {
  const QrWidget({super.key});

  @override
  State<QrWidget> createState() => _QrWidgetState();
}

class _QrWidgetState extends State<QrWidget> {
  // TextEditingController textdata = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lime,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: QrImageView(
              embeddedImage: const NetworkImage(''),
              data: '',
              version: QrVersions.auto,
              size: 250.0,
              backgroundColor: Colors.white,
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     // controller: textdata,
          //     decoration: const InputDecoration(
          //         border: OutlineInputBorder(), label: Text('Enter Message')),
          //   ),
          // ),
          ElevatedButton(
            child: const Text(''),
            onPressed: _shareQrCode,
          ),
        ]));
  }

  void _shareQrCode() async {
    final qrPainter = QrPainter(
      data: 'share',
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.M,
      color: Colors.white,
    );

    final qrCodeImage = await qrPainter.toImageData(300);

    final tempDir = Directory.systemTemp;
    final filePath = '${tempDir.path}/qr_code.png';

    File(filePath).writeAsBytesSync(qrCodeImage!.buffer.asUint8List());

    Share.shareFiles([filePath], text: 'Sharing QR code');
  }
}
