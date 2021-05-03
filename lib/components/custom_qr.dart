import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CustomQRImage extends StatelessWidget {
  final Function onQRTap;
  final String data;
  CustomQRImage({
    @required this.onQRTap,
    @required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onQRTap,
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: QrImage(
            data: data,
            version: 1,
            gapless: false,
          ),
        ),
      ),
    );
  }
}
