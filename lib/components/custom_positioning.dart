import 'package:flutter/material.dart';

class CustomPositioning extends StatelessWidget {
  final double customTop;
  final double customLeft;
  final double customRight;
  final double customBottom;
  final Widget customChild;

  const CustomPositioning({this.customTop = 0.0, this.customLeft = 0.0, this.customRight = 0.0, this.customBottom, @required this.customChild});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: customTop,
      left: customLeft,
      right: customRight,
      bottom: customBottom,
      child: customChild,
    );
  }
}