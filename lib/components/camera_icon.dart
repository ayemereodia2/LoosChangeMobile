import 'package:flutter/material.dart';

class CameraIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 45.0,
      width: 60.0,
      decoration: BoxDecoration(
        border: Border.all(width: 4.0, color: Color(0xFFFFFFFF)),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        width: 30.0,
        height: 30.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: 4.0, color: Color(0xFFFFFFFF)),
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
