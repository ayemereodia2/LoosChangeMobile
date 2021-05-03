import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loosechange/components/reusable_bg.dart';
import 'package:loosechange/components/appbar_widget.dart';
import 'package:loosechange/components/form_auth_field.dart';
import 'package:loosechange/components/auth_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:loosechange/components/reusable_text.dart';

import '../globals.dart' as globals;
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class ChangePin extends StatefulWidget {
  @override
  _ChangePinState createState() => _ChangePinState();
}

class _ChangePinState extends State<ChangePin> {
  static List userList;
  static List profileList;
  String codeOne;
  String codeTwo;

  ProgressDialog pr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userList = globals.userDetails.values.toList();

    profileList = globals.profileDetails.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, isDismissible: false);
    return Scaffold(
      body: Container(
        decoration: bodyGradientColor(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: CustomAppBar(
                appbarTextOne: '',
                appbarTextTwo: 'Change Pin',
                appbarFontSizeTwo: 20.0,
              ),
            ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FormAuthField(
                        customicon: Icons.fiber_pin,
                        customhinttext: 'Old Pin',
                        customtextinputaction: TextInputAction.next,
                        customkeyboardinputtype:
                            TextInputType.numberWithOptions(decimal: false),
                        // initialValue: userList[2],
                        onChanged: (text) {
                          codeOne = text;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FormAuthField(
                        customicon: Icons.push_pin,
                        customhinttext: 'New Pin',
                        customtextinputaction: TextInputAction.next,
                        customkeyboardinputtype:
                            TextInputType.numberWithOptions(decimal: false),
                        // initialValue: profileList[2],
                        onChanged: (text) {
                          codeTwo = text;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40.0, right: 16.0),
                      child: new AuthButton(
                        onPressed: () {
                          updateProfile();
                        },
                        buttontext: 'Update Pin',
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

  Future<Map> updateProfile() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}

      try {
        final file = await _localTokenFile;
        // Read the file
        String contents = await file.readAsString();

        if (codeTwo.length == 4) {
          if (codeOne == globals.profileDetails['pin'].toString()) {
            pr.show();
            Map profileDetails = {'pin': codeTwo};

            var profileBody;
            profileBody = json.encode(profileDetails);

            Response profileResponse = await put(
                'https://lcapi.loosechangeng.com/api/profiles/' +
                    profileList[0].toString() +
                    '/',
                headers: {
                  HttpHeaders.authorizationHeader: "JWT " + contents,
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: profileBody);

            print(profileResponse.body);
            pr.hide().then((value) => {
                  globals.profileUpdateComplete = true,
                  Navigator.pushNamed(context, '/homepage')
                });
          } else {
            pr.hide().then((value) => {wrongCode(context)});
          }
        } else {
          pr.hide().then((value) => {wrongSize(context)});
        }

        // pr.hide().then((value) => {
        //   globals.profileUpdateComplete = true,
        //   Navigator.pushNamed(context, '/homepage')
        // });

        // print(profileResponse.body);
        return null;
      } catch (e) {
        print(e);
        return e;
      }
    } on SocketException catch (_) {
      noConnection(context);
    }
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

  wrongCode(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Invalid Code."),
      content: Text("The pin you provided was invalid"),
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

  wrongSize(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Invalid Code."),
      content: Text("The pin must be 4 characters"),
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
