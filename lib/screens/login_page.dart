import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loosechange/components/reusable_bg.dart';
import 'package:loosechange/components/reusable_text.dart';
import 'package:loosechange/components/auth_button.dart';
import 'package:loosechange/components/form_auth_field.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../globals.dart' as globals;
import 'dart:developer' as debug;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  ProgressDialog pr;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, isDismissible: false);
    // ignore: unnecessary_statements
    DiagnosticLevel.debug;
    return Scaffold(
      body: Container(
        decoration: bodyGradientColor(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Image(
                image: AssetImage('images/logo.png'),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 32.0, right: 32.0, top: 16.0),
                      child: new FormAuthField(
                        controller: usernameController,
                        customhinttext: 'Username',
                        customicon: Icons.person,
                        customtextinputaction: TextInputAction.next,
                        customkeyboardinputtype: TextInputType.text,
                        // initialValue: '',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 32.0, right: 32.0, top: 16.0),
                      child: new FormAuthField(
                        controller: passwordController,
                        customhinttext: 'Password',
                        customicon: Icons.lock,
                        customtextinputaction: TextInputAction.done,
                        customkeyboardinputtype: TextInputType.text,
                        customobstextvalue: true,
                        // initialValue: '',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 70.0, right: 32.0, top: 20.0),
                      child: new AuthButton(
                        // onPressed: () {
                        //   pr.show();

                        // },
                        onPressed: () {
                          debug.log('message', name: '');
                        // create logic for finger
                          performLogin();
                        },
                        buttontext: 'SIGN IN',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ReusableText(
                                customtext: 'Forgot your password? ',
                                colour: Colors.white.withOpacity(0.5),
                                customFontSize: 14.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/forgot-password');
                                },
                                child: ReusableText(
                                  customtext: 'Reset',
                                  colour: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 32.0, horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ReusableText(
                          customtext: 'Don\'t have an account? ',
                          colour: Colors.white.withOpacity(0.5),
                          customFontSize: 14.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: ReusableText(
                            customtext: 'Register',
                            colour: Colors.white,
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
    );
  }

  Future<http.Response> performLogin() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());

      debug.log('message', name: '');

      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        pr.show();
        print('about to login');
        String username = usernameController.text;
        String password = passwordController.text;
        Map credentials = {'username': username, 'password': password};
        // var credentials = {'username': username, 'password': password};
        print('login attempt: $username with $password');

        var body = json.encode(credentials);

        var response = await http.post(
          'https://lcapi.loosechangeng.com/auth/',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        );

        String data = response.body;
        var x = json.decode(data);

        if (response.statusCode == 200) {
          saveToken(x["token"]);
          saveUsername(username);
          pr.hide();

          Navigator.pushReplacementNamed(context, '/loader-page-two');
        } else {
          pr.hide();
          invalidCredentials(context);
        }
        pr.hide();
        return response;
      }
    } on Exception catch (exception) {
      print('Login Exception $exception');
      pr.hide();
      noConnection(context);
    }
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

  Future<File> get _localUsernameFile async {
    final path = await _localPath;
    return File('$path/username.txt');
  }

  Future<File> saveToken(token) async {
    final file = await _localTokenFile;
    // Write the file
    return file.writeAsString(token);
  }

  Future<File> saveUsername(username) async {
    final file = await _localUsernameFile;
    // Write the file
    return file.writeAsString(username);
  }

  invalidCredentials(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Invalid Credentials"),
      content: Text("Please re-enter username and password"),
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

  void _openLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<String> checkLogin() async {
    try {
      final file = await _localUsernameFile;
      // Read the file
      String contents = await file.readAsString();

      if (globals.verifyDetails != null) {
        if (globals.verifyDetails.values.toList()[3] != false) {
          Navigator.pushReplacementNamed(context, '/verify-phone');
        } else {
          Navigator.pushReplacementNamed(context, '/homepage');
        }
      }

      return contents;
    } catch (e) {
      // If there is an error reading, return a default String
      print(e);
      return 'Error';
    }
  }
}
