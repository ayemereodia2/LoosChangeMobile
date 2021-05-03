import 'package:flutter/material.dart';
import 'package:loosechange/components/reusable_bg.dart';
import 'package:loosechange/components/custom_positioning.dart';
import 'package:loosechange/components/appbar_widget.dart';
import 'package:loosechange/components/divider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../globals.dart' as globals;
import 'dart:io';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final List<String> entries = <String>['No Withdrawals Yet'];

  ProgressDialog pr;

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, isDismissible: false);

    return Scaffold(
      body: Container(
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: <Widget>[
            Container(
              decoration: bodyGradientColor(),
            ),
            new CustomPositioning(
              customTop: 20.0,
              customChild: CustomAppBar(
                appbarFontSizeOne: 16.0,
                appbarFontSizeTwo: 24.0,
                appbarTextOne: '',
                appbarTextTwo: 'Transaction',
              ),
            ),
            BuildDivider(
              dividerTop: 200.0,
            ),
            new CustomPositioning(
              customBottom: 0.0,
              customTop: 220.0,
              customChild: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0)),
                  color: Colors.transparent,
                ),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Transfer to " + globals.transferUsername,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30.0,
                        // height: 2.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Amount: ₦" +
                          globals.transferAmount
                              .toString()
                              .replaceAllMapped(reg, mathFunc),
                      style: TextStyle(
                        fontSize: 20.0,
                        height: 2.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Date: " + globals.transferDate,
                      style: TextStyle(
                        fontSize: 20.0,
                        height: 2.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    // print(directory.path);
    return directory.path;
  }

  Future<File> get _localTokenFile async {
    final path = await _localPath;
    return File('$path/token.txt');
  }
}
