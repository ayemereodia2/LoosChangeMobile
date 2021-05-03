import 'package:flutter/material.dart';
import 'package:loosechange/components/reusable_text.dart';

class CustomButton extends StatelessWidget {
  final Color startColor;
  final Color endColor;
  final String buttonText;
  final Function onPressed;

  const CustomButton({
    @required this.startColor, @required this.endColor, @required this.buttonText, @required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, endColor],
        ),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: FlatButton(
        onPressed: onPressed,
        child: ReusableText(
          customtext: buttonText,
          colour: Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}
