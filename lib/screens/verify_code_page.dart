import 'package:flutter/material.dart';
import 'package:loosechange/components/reusable_bg.dart';
import 'package:loosechange/components/custom_positioning.dart';
import 'package:loosechange/components/appbar_widget.dart';
import 'package:loosechange/components/reusable_text.dart';
import 'package:loosechange/components/divider.dart';
import 'package:loosechange/components/auth_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

import '../globals.dart' as globals;
import 'package:http/http.dart';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VerifyCodePage extends StatefulWidget {
  @override
  _VerifyCodePageState createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  String code;
  static List verificationsList;
  static List profileList;
  var rNum;

  ProgressDialog pr;

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    profileList = globals.profileDetails.values.toList();
    verificationsList = globals.verifyDetails.values.toList();
    print(verificationsList);
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
                appbarTextTwo: 'Verify Code',
              ),
            ),
            new CustomPositioning(
              customTop: 80.0,
              customChild: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 16.0, bottom: 16.0, top: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[],
                      ),
                    ),
                  ],
                ),
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
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: new Container(
                    // color: Colors.yellow,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Verify Code",
                                style: TextStyle(
                                  fontSize: 40.0,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "A code was sent to the phone number you provided. Kindly verify the code below",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 70.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20.0),
                                      topLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(20.0),
                                    ),
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Code',
                                        border: InputBorder.none,
                                      ),
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                          // color: Colors.white,
                                          fontWeight: FontWeight.w300),
                                      onChanged: (text) {
                                        code = text;
                                        // print(amount);
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: AuthButton(
                                    onPressed: () {
                                      verifyCode();
                                    },
                                    buttontext: 'PROCEED',
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: double.infinity,
                                          color: Colors.transparent,
                                          child: FlatButton(
                                            color: Colors.transparent,
                                            onPressed: () {
                                              resendText();
                                            },
                                            child: Text(
                                              'Resend Code',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: double.infinity,
                                          color: Colors.transparent,
                                          child: FlatButton(
                                            color: Colors.transparent,
                                            onPressed: () {
                                              resendCall();
                                            },
                                            child: Text(
                                              'Receive Call',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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

  Future<void> verifyCode() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}

      final file = await _localTokenFile;
      // Read the file
      String contents = await file.readAsString();
      if (code == globals.vCode.toString()) {
        pr.show();
        Map vTable = {
          "verified": true,
        };
        var vbody = json.encode(vTable);

        Response verResponse = await put(
          'https://lcapi.loosechangeng.com/api/verifications/' +
              verificationsList[0].toString() +
              '/',
          headers: {
            HttpHeaders.authorizationHeader: "JWT " + contents,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: vbody,
        );
        if (verResponse.statusCode == 200) {
          int min = 1000; //min and max values act as your 6 digit range
          int max = 9999;
          var randomizer = new Random();
          rNum = min + randomizer.nextInt(max - min);

          Map pbodd = {
              "pin": rNum,
            };
            var pbody = json.encode(pbodd);
            Response prrResponse = await put(
              'https://lcapi.loosechangeng.com/api/profiles/' +
                  profileList[0].toString() +
                  '/',
              headers: {
                HttpHeaders.authorizationHeader: "JWT " + contents,
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: pbody,
            );
            print(prrResponse);

          var url =
              "https://api.twilio.com/2010-04-01/Accounts/AC11e2082a48fa4c9d8c04fa145af48f39/Messages.json";

          Map text = {
            "Body":
                'This is your withdrawal pin. Keep it safe and secret as your pin will be required whenever you make a withdrawal request. Pin: ' +
                    rNum.toString(),
            "From": 'LooseChange',
            "To": globals.vPhone,
          };

          var key = base64.encode(utf8.encode(
              'AC11e2082a48fa4c9d8c04fa145af48f39' +
                  ':' +
                  'ba7ea8b9e95ac75da65d48a09372dd5a'));

          var body = json.encode(text);
          var client = http.Client();

          var response = await client.post(url,
              headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                HttpHeaders.authorizationHeader: 'Basic ' + key
              },
              body: text);
          print(body);
          var textArray;
          textArray = json.decode(response.body);
          print(textArray);

          if (textArray["account_sid"] ==
              "AC11e2082a48fa4c9d8c04fa145af48f39") {
            pr.hide();
            Navigator.pushReplacementNamed(context, '/homepage');
          } else {
            pr.hide();
            errorSend(context);
          }
        } else {
          pr.hide();
          errorSend(context);
        }
      } else {
        pr.hide();
        errorSend(context);
      }

      pr.hide();
    } on SocketException catch (_) {
      noConnection(context);
    }
  }

  Future<void> resendText() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

      var url = "https://api.twilio.com/2010-04-01/Accounts/AC11e2082a48fa4c9d8c04fa145af48f39/Messages.json";

        Map text = {
          "Body" : globals.vCode.toString(),
          "From" : 'LooseChange',
          "To" : globals.vPhone,
        };

      var key = base64.encode(utf8.encode('AC11e2082a48fa4c9d8c04fa145af48f39' + ':' + 'ba7ea8b9e95ac75da65d48a09372dd5a'));
      print(key);

      var body = json.encode(text);
      var client = http.Client();

      var response = await client.post(url, headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          HttpHeaders.authorizationHeader: 'Basic ' + key
        }, 
        body: text
      );
      print(body);
      var textArray;
      textArray = json.decode(response.body);
      print(textArray);

      if(textArray["account_sid"] == "AC11e2082a48fa4c9d8c04fa145af48f39"){
        codeResent(context);
      }else{
        errorSend(context);
      }

      pr.hide();
      }
    } on SocketException catch (_) {
      noConnection(context);
    }
  }

  Future<void> resendCall() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

      var url = "https://api.twilio.com/2010-04-01/Accounts/AC11e2082a48fa4c9d8c04fa145af48f39/Calls.json";

        Map text = {
          "Twiml" : "<Response><Say>Hello ," + globals.userDetails.values.toList()[3] + ". Your verification code is" +
            globals.vCode.toString() +
            ". I repeat, your code is" +
            globals.vCode.toString() + 
            "</Say></Response>",
          "From" : '+12058803891',
          "To" : globals.vPhone,
        };

      var key = base64.encode(utf8.encode('AC11e2082a48fa4c9d8c04fa145af48f39' + ':' + 'ba7ea8b9e95ac75da65d48a09372dd5a'));
      print(key);

      var body = json.encode(text);
      var client = http.Client();

      var response = await client.post(url, headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          HttpHeaders.authorizationHeader: 'Basic ' + key
        }, 
        body: text
      );
      print(body);
      var textArray;
      textArray = json.decode(response.body);
      print(textArray);

      if(textArray["account_sid"] == "AC11e2082a48fa4c9d8c04fa145af48f39"){
        codeResent(context);
      }else{
        errorSend(context);
      }

      pr.hide();
      }
    } on SocketException catch (_) {
      noConnection(context);
    }
  }

  errorSend(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error Verifying Code"),
      content: Text("Please check code and try again."),
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

  codeResent(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Code Resent!"),
      content: Text("The code has been resent to your phone number"),
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
