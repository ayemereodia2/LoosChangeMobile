import 'package:flutter/material.dart';
import 'package:loosechange/components/reusable_text.dart';

class AuthButton extends StatelessWidget {
  final String buttontext;
  final Function onPressed;

  const AuthButton({
    @required this.buttontext,
    @required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9DCB3B), Color(0xFF4BB749)],
          ),
          borderRadius: BorderRadius.circular(30.0)),
      child: FlatButton(
        onPressed: onPressed,
        child: ReusableText(
          customtext: buttontext,
          colour: Colors.white,
          customFontSize: 18.0,
        ),
      ),
    );
  }
}
