import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loosechange/components/reusable_bg.dart';
import 'package:loosechange/components/custom_positioning.dart';
import 'package:loosechange/components/appbar_widget.dart';
import 'package:loosechange/components/divider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:loosechange/components/auth_button.dart';
import 'dart:async';

import '../globals.dart' as globals;
import 'dart:io';

class BankTransferPage extends StatefulWidget {
  @override
  _BankTransferPageState createState() => _BankTransferPageState();
}

class _BankTransferPageState extends State<BankTransferPage> {
  final List<String> entries = <String>['No Withdrawals Yet'];

  ProgressDialog pr;

  var paystacBalance;

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  Timer _timer;
  int _start = 180;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            Navigator.pop(context);
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void confirmedTransfer() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
      globals.confirmedBankTransfer = true;
      Navigator.pop(context);
    } on SocketException catch (_) {
      noConnection(context);
    }
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
                appbarTextTwo: 'Bank Transfer',
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
                  children: <Widget>[
                    Text(
                      "Amount: ₦" + globals.bankTransferAmount,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        // height: 2.0,
                        color: Colors.white,
                      ),
                    ),
                    SelectableText(
                      "0077988097",
                      style: TextStyle(
                        fontSize: 30.0,
                        height: 2.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Sterling Bank",
                      style: TextStyle(
                        fontSize: 20.0,
                        height: 2.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "${(_start ~/ 60).toString().padLeft(2, '0')}:${(_start % 60).toString().padLeft(2, '0')}",
                      style: TextStyle(
                        fontSize: 20.0,
                        height: 2.0,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AuthButton(
                        onPressed: () {
                          confirmedTransfer();
                        },
                        buttontext: 'I\'ve Made the Transfer',
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

  noConnection(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Your Device is not connected to the internet."),
      content: Text("Try reconnecting then try again."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
