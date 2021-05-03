import 'package:flutter/material.dart';
import 'package:loosechange/components/reusable_bg.dart';
import 'package:loosechange/components/appbar_widget.dart';
import 'package:loosechange/components/card_widget.dart';
import 'package:loosechange/components/auth_button.dart';
import 'package:path_provider/path_provider.dart';
import '../globals.dart' as globals;

import 'package:http/http.dart';
import 'dart:io';
import 'dart:convert';


class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  static List userList;
  static List profileList;
  static List accountList;
  String secretKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userList = globals.userDetails.values.toList();
    profileList = globals.profileDetails.values.toList();
    accountList = globals.accountDetails.values.toList();

    print(profileList);
    
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

  successUpdateAccount() async {
    if (globals.accountUpdateComplete == true) {
      final file = await _localTokenFile;
      String contents = await file.readAsString();

      Response accountResponse = await get(
        'https://lcapi.loosechangeng.com/api/accounts/',
        headers: {
          HttpHeaders.authorizationHeader: "JWT " + contents,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      String accountData = accountResponse.body;
      var acc = json.decode(accountData);

      Map account;

      for (var i in acc) {
        if (i["user"] == userList[0]) {
          account = i;
        }
      }

      globals.accountDetails = account;
      
      setState(() {
        userList = globals.userDetails.values.toList();
        profileList = globals.profileDetails.values.toList();
        accountList = globals.accountDetails.values.toList();
      });
      print(accountList);
      globals.accountUpdateComplete = false;
    }
  }

  enterSecret(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        print(secretKey);
        if(secretKey == profileList[4].toString()){
          Navigator.pushNamed(context, '/withdraw').then((value) {
            if (value != null){
              Navigator.of(context).pop();
            }
          });
        }else{
          // print('Not the same');
          Navigator.of(context).pop();
          errorSCode(context);
        }
        
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Enter Secret Code!"),
      content: TextField(
        onChanged: (text){
          secretKey = text;
        },
      ),
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

  errorSCode(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Invalid Secret Code!"),
      content: Text("Please check code and try again. If you do not remember your code, kindly contact our customer service."),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: bodyGradientColor(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: CustomAppBar(
                appbarTextOne: '',
                appbarTextTwo: 'Account',
                appbarFontSizeTwo: 20.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Divider(
                color: Colors.white,
                height: 24.0,
              ),
            ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CardWidget(
                        customName: accountList[2] == null ? 'Account Name' : accountList[2],
                        customGradientStart: Color(0xFFFFFFFF),
                        customGradientStop: Color(0xFFFFFFFF),
                        customBankName: accountList[4] != null ? 'BVN: ' + '****' + accountList[4].toString().substring(7) : 'Bank Verification Number',
                        customAccountNumber: accountList[1] != null ? 'Account No: ' + accountList[1].toString() : 'Account Number',
                        customBottomText: 'Bank Account Information',
                        onTap: () {
                          Navigator.pushNamed(context, '/edit-account').then((value) {
                            if (value != null){
                              new Future.delayed(const Duration(seconds: 1))
                                .then((_) => successUpdateAccount());
                            } // if true and you have come back to your Settings screen 
                              
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: new AuthButton(
                        onPressed: () {
                          enterSecret(context);
                        },
                        buttontext: 'Withdraw Funds',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        color: Colors.transparent,
                        child: FlatButton(
                          color: Colors.transparent,
                          onPressed: () {
                            Navigator.pushNamed(context, '/withdrawals');
                          }, 
                          child: Text(
                            'View Withdrawals',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
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
}
