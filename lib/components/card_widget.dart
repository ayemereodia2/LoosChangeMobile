import 'package:flutter/material.dart';
import 'package:loosechange/components/reusable_text.dart';
import 'package:loosechange/components/circle_icon.dart';

class CardWidget extends StatelessWidget {
  final String customName;
  final String customBankName;
  final String customAccountNumber;
  final String customBottomText;
  final double customRadius;
  final Color customGradientStart;
  final Color customGradientStop;
  final Function onTap;

  const CardWidget(
      {@required this.customName,
      @required this.customBankName,
      @required this.customAccountNumber,
      this.customBottomText,
      this.customRadius = 0.0,
      @required this.customGradientStart,
      this.onTap,
      @required this.customGradientStop});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(20.0),
        gradient: LinearGradient(
          colors: [Color(0xFF000000), Color(0xFF59A3D9)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ReusableText(
                  customtext: customName,
                  customFontSize: 18.0,
                  colour: Color(0xFFFFFFFF),
                ),
                CircleIcon(
                  customWidth: 40.0,
                  customHeight: 40.0,
                  customRadius: customRadius,
                  gradientStart: customGradientStart,
                  gradientStop: customGradientStop,
                ),
              ],
            ),
            ReusableText(
              customtext: customBankName,
              colour: Color(0xFFFFFFFF),
              customFontSize: 14.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            ReusableText(
              customtext: customAccountNumber,
              colour: Color(0xFFFFFFFF),
              customFontSize: 14.0,
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ReusableText(
                  customtext: customBottomText,
                  colour: Color(0xFFFFFFFF),
                  customFontSize: 14.0,
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: onTap,
                      child: ReusableText(
                        customtext: 'Edit',
                        colour: Color(0xFFFFFFFF),
                        customFontSize: 14.0,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
