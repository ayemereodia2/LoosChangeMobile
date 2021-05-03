import 'package:flutter/material.dart';

class ReusableText extends StatelessWidget {
  final String customtext;
  final double customFontSize;
  final Color colour;
  const ReusableText(
      {@required this.customtext, this.customFontSize, this.colour});

  @override
  Widget build(BuildContext context) {
    return Text(
      customtext,
      style: TextStyle(fontSize: customFontSize, color: colour, fontFamily: 'SourceSansPro'),
    );
  }
}
