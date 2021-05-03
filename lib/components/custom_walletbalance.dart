import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loosechange/components/reusable_text.dart';
import 'package:loosechange/components/custom_qr.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../globals.dart' as globals;

class CustomWalletBalance extends StatefulWidget {
  final Function onQRTap;
  final String customtext;

  CustomWalletBalance({@required this.onQRTap, @required this.customtext});

  @override
  _CustomWalletBalanceState createState() => _CustomWalletBalanceState();
}

class _CustomWalletBalanceState extends State<CustomWalletBalance> {
  static List userList;
  static List profileList;
  static GlobalKey previewContainer = new GlobalKey();
  // var _renderObjectKey = 1234567;

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      userList = globals.userDetails.values.toList();
      profileList = globals.profileDetails.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 16.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: CustomQRImage(
              data: userList[0].toString(),
              onQRTap: widget.onQRTap,
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                ReusableText(
                  customtext: 'Wallet Balance',
                  customFontSize: 16.0,
                  colour: Color(0xFF000000),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      ReusableText(
                        customtext: '₦',
                        customFontSize: 36.0,
                        colour: Color(0xFFFFFFFF),
                      ),
                      ReusableText(
                        customtext: widget.customtext,
                        customFontSize: 36.0,
                        colour: Color(0xFFFFFFFF),
                      ),
                      // ReusableText(
                      //   customtext: '.00',
                      //   customFontSize: 24.0,
                      //   colour: Color(0xFFFFFFFF),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
