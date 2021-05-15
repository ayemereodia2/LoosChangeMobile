import 'package:flutter/material.dart';
import 'package:loosechange/components/reusable_text.dart';

class CustomAppBar extends StatelessWidget {
  final String appbarTextOne;
  final String appbarTextTwo;
  final String appbarTextThree;
  final double appbarFontSizeOne;
  final double appbarFontSizeTwo;

  const CustomAppBar({
    this.appbarTextOne,
    this.appbarTextTwo,
    this.appbarFontSizeOne,
    this.appbarFontSizeTwo,
    this.appbarTextThree = "",
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarOpacity: .5,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.lightGreen),
      elevation: 0.0,
      actions: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: new ReusableText(
                    customtext: appbarTextOne,
                    customFontSize: appbarFontSizeOne,
                    colour: Colors.blueGrey,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      child: new ReusableText(
                        customtext: appbarTextTwo,
                        customFontSize: appbarFontSizeTwo,
                        colour: Colors.blueGrey,
                      ),
                    ),
                    Container(
                      child: new ReusableText(
                        customtext: appbarTextThree,
                        customFontSize: appbarFontSizeTwo,
                        colour: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
