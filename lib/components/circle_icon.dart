import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  final double customWidth;
  final double customHeight;
  final Color gradientStart;
  final Color gradientStop;
  final double customRadius;

  CircleIcon(
      {this.customWidth = 20.0,
      this.customHeight = 20.0,
      @required this.gradientStart,
      @required this.gradientStop,
      this.customRadius = 10.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: customWidth,
      height: customHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [gradientStart, gradientStop],
        ),
        borderRadius: BorderRadius.circular(customRadius),
      ),
    );
  }
}
