import 'package:flutter/material.dart';
import 'package:loosechange/components/reusable_bg.dart';
import 'package:loosechange/components/appbar_widget.dart';
import 'package:loosechange/components/form_auth_field.dart';
import 'package:loosechange/components/auth_button.dart';
import 'package:loosechange/components/reusable_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:convert';
import 'dart:io';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final usernameController = TextEditingController();
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String exists;

  ProgressDialog pr;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    fNameController.dispose();
    lNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                appbarTextTwo: 'Signup',
                appbarFontSizeTwo: 22.0,
              ),
            ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Form(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FormAuthField(
                          customicon: Icons.person_add,
                          customhinttext: 'Username',
                          customtextinputaction: TextInputAction.next,
                          customkeyboardinputtype: TextInputType.text,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: usernameController,
                          validator: (value){
                            if(value.isEmpty){
                              return "* Username is required";
                            }else
                              return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0), 
                        child: FormAuthField(
                          customicon: Icons.person_outline,
                          customhinttext: 'First Name',
                          customtextinputaction: TextInputAction.next,
                          customkeyboardinputtype: TextInputType.text,
                          controller: fNameController,
                          validator: validateNames, autovalidateMode: AutovalidateMode.onUserInteraction
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0), 
                        child: FormAuthField(
                          customicon: Icons.person_pin,
                          customhinttext: 'Last Name',
                          customtextinputaction: TextInputAction.next,
                          customkeyboardinputtype: TextInputType.text,
                          controller: lNameController,
                          validator: validateNames,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0), 
                        child: FormAuthField(
                          customicon: Icons.email,
                          customhinttext: 'Email',
                          customtextinputaction: TextInputAction.next,
                          customkeyboardinputtype: TextInputType.emailAddress,
                          controller: emailController,
                          validator: validateEmail,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FormAuthField(
                          customicon: Icons.lock,
                          customhinttext: 'Password',
                          customtextinputaction: TextInputAction.next,
                          customkeyboardinputtype: TextInputType.text,
                          customobstextvalue: true,
                          validator: validatePassword,
                          controller: passwordController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40.0, right: 16.0),
                        child: new AuthButton(
                          onPressed: () {
                            performRegister();
                          },
                          buttontext: 'Sign Up',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ReusableText(
                                    customtext: 'By registering, you agree to our ',
                                    colour: Colors.white.withOpacity(0.5),
                                    customFontSize: 14.0,
                                  ),
                                GestureDetector(
                                  onTap: () {
                                    _launchURL();
                                  },
                                  child: ReusableText(
                                      customtext: 'T\'s & C\'s',
                                      colour: Colors.white,
                                    ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return "* Required";
    } else if (value.length < 6) {
      return "Password should be at least 6 characters";
    } else if (value.length > 15) {
      return "Password should not be greater than 15 characters";
    } else
      return null;
  }

  String validateNames(String value) {
    if (value.isEmpty) {
      return "* Required";
    } else if (value.length < 2) {
      return "Should be at least 2 characters";
    } else if (value.length > 15) {
      return "Should not be greater than 15 characters";
    } else
      return null;
  }

  String validateEmail(String value) {
    if (value.isEmpty) {
      return "* Required";
    } else if (!value.contains("@") || !value.contains(".")) {
      return "Please enter a valid email address";
    } else
      return null;
  }
  _launchURL() async {
    const url = 'https://loosechangeng.com/docs/lc.pdf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<http.Response> performRegister() async{

    if (this.formkey.currentState.validate()) {
      print("Validated");
    }else{
      print("Not Validated");
      Future.delayed(
        Duration(seconds: 2),
            () => 'Error on validation',
      );
    }
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      
    String username = usernameController.text.toLowerCase();
    String first_name = fNameController.text;
    String last_name =  lNameController.text;
    String email = emailController.text;
    String password = passwordController.text;
 
    print(email);

    print(username + " " + first_name + " " + last_name + " " + email + " " + password);

    if(email != null && email != '' && first_name != null && first_name != '' && last_name != null && last_name != ''){
      if(username != null){
        username = username.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
      }
      pr.show();
      Map credentials = {
        'username': username, 
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
        'is_staff': false,
        'is_superuser': false,
        'password': password,
        'password2': password,
      };

      var body = json.encode(credentials);
      
      var response = await http.post(
        'https://lcapi.loosechangeng.com/api/create-users/',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      String data = response.body;
      if(response.statusCode != 200){
        pr.hide();  
        emailExists(context);
      }
      // print(data);
      var x = json.decode(data);

      // print(x);
      if(x['username'] != null){
        exists = x['username'][0].toString();
      }
      // print(exists);

        if(x["response"] == "Successfully Registered New User"){
           Map credentials = {
              'username': username, 'password': password
            };
            // print('login attempt: $username with $password');

            var body = json.encode(credentials);
            
            var lresponse = await http.post(
              'https://lcapi.loosechangeng.com/auth/',
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: body,
            );

            String data = lresponse.body;
            var x = json.decode(data);

            if(lresponse.statusCode == 200){
              saveToken(x["token"]);
              saveUsername(username);
              new Future.delayed(const Duration(seconds: 1))
              .then((_) => {
                pr.hide(),
                //Navigator.pushReplacementNamed(context, '/')
                //print('about to navigate'),

               Navigator.pushNamedAndRemoveUntil(
                   context, '/verify-phone', (route) => false)
              });
              
            }else{
              pr.hide();
              invalidCredentials(context);
            }
        }else{
          if(exists == "A user with that username already exists."){
            pr.hide();
            exists = null;
            usernameExists(context);
          } else{
            pr.hide();
            invalidCredentials(context);
          }
        }
      }else{
        pr.hide();
        invalidCredentials(context);
      }
       pr.hide();
    return null;
    }
    } on SocketException catch (_) {
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
      content: Text("Please re-enter valid credentials"),
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

  usernameExists(BuildContext context) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
       },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Username Already Exists"),
      content: Text("Please try another username"),
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

  emailExists(BuildContext context) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
       },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Email Already Exists"),
      content: Text("Please try another email"),
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
      
      Navigator.pushReplacementNamed(context, '/homepage');
      return contents;
    } catch (e) {
      // If there is an error reading, return a default String
      return 'Error';
    }
  }
}

class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
}


