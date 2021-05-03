import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'dart:convert';

class WithdrawPage extends StatefulWidget {
  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  static List userList;
  static List profileList;
  static List accountList;
  int amount;
  Map receiver;
  Map userMain;
  String chargeFrom = "Balance";

  ProgressDialog pr;

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userList = globals.userDetails.values.toList();
    profileList = globals.profileDetails.values.toList();
    accountList = globals.accountDetails.values.toList();

    // print(accountList);
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(
      context,
      // isDismissible: false
    );

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
                appbarTextTwo: 'Withdraw',
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
                                  customtext: profileList[3] != null
                                      ? profileList[3]
                                          .toString()
                                          .replaceAllMapped(reg, mathFunc)
                                      : '0',
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
                                "Make Withdrawal",
                                style: TextStyle(
                                  fontSize: 40.0,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Text(
                                  "Note: LooseChange charges ₦100 for every withdrawal made.",
                                  style: TextStyle(
                                    // fontSize: 40.0,
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
                                        labelText: 'Amount',
                                        border: InputBorder.none,
                                      ),
                                      inputFormatters: [
                                        WhitelistingTextInputFormatter
                                            .digitsOnly
                                      ],
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                        decimal: false,
                                      ),
                                      style: TextStyle(
                                          // color: Colors.white,
                                          fontWeight: FontWeight.w300),
                                      onChanged: (text) {
                                        amount = int.parse(text);
                                        // print(amount);
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: AuthButton(
                                    onPressed: () {
                                      withdraw(context);
                                    },
                                    buttontext: 'PROCEED',
                                  ),
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

  Future<File> get _localUsernameFile async {
    final path = await _localPath;
    return File('$path/username.txt');
  }

  withdraw(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        completeWithdrawal();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Take Charges From"),
      content: RadioButtonGroup(labels: <String>[
        "Balance",
        "Withdrawal Funds",
      ], onSelected: (String selected) => chargeFrom = selected),
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

  completeWithdrawal() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}

      var charge;
      var pCharge;
      var date;
      var pBal;
      Map bTransfer;
      Map bWithTrans;
      Map wTransfer;
      Map wWithTrans;

      getUserUpdatedDetails().then((value) async => {
            charge = 100,
            pCharge = amount != null ? amount + charge : charge,
            date = DateTime.now(),
            pBal = profileList[3] != null ? profileList[3] : 0,
            pBal = double.tryParse(pBal),
            print(pBal),
            print(amount),
            if (amount == null)
              {
                pr.hide(),
                errorWith(context),
              },
            if (amount > pBal)
              {
                pr.hide(),
                errorBalance(context),
              }
            else
              {
                if (amount < 2000)
                  {
                    pr.hide(),
                    errorLimit(context),
                  }
                else
                  {
                    if (chargeFrom == "Balance")
                      {
                        if (pBal < pCharge)
                          {
                            pr.hide(),
                            errorAmtCharge(context),
                          }
                        else
                          {
                            bTransfer = {
                              "source": "balance",
                              "amount": amount * 100,
                              "currency": "NGN",
                              "recipient": accountList[5],
                            },
                            bWithTrans = {
                              "user": userList[0],
                              "amount": pCharge,
                              "date_created": date.toIso8601String(),
                            },
                            withDetails(bTransfer, bWithTrans),
                          },
                      }
                    else
                      {
                        //Charge From Withdrawal Funds
                        wTransfer = {
                          "source": "balance",
                          "amount": (amount - charge) * 100,
                          "currency": "NGN",
                          "recipient": accountList[5],
                        },

                        wWithTrans = {
                          "user": userList[0],
                          "amount": amount,
                          "date_created": date.toIso8601String(),
                        },
                        withDetails(wTransfer, wWithTrans),
                      }
                  }
              }
          });
    } on SocketException catch (_) {
      noConnection(context);
    }
  }

  withDetails(tr, wt) async {
    pr.show();
    final file = await _localTokenFile;
    // Read the file
    String contents = await file.readAsString();

    var body = json.encode(tr);
    var wtBody = json.encode(wt);

    Response response;
    var transArray;
    var bb;
    var ammt;
    Response wResponse;
    Map profileUpdate;
    var pBody;
    Response pResponse;

    getUserUpdatedDetails().then((value) async => {
          response = await post('https://api.paystack.co/transfer',
              headers: {
                HttpHeaders.authorizationHeader:
                    "Bearer sk_live_866ce814af14820edc21b03791910ae288c5ce92",
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: body),

          transArray = json.decode(response.body),
          print(transArray),
          bb = profileList[3],
          bb = double.tryParse(bb),
          ammt = wt["amount"],
          ammt = ammt.toDouble(),
          // print(profileList[3] - int.parse(wt["amount"]));
          print(ammt),
          print(bb - ammt),

          if (transArray["status"] == true)
            {
              // print('true');
              wResponse = await post(
                  'https://lcapi.loosechangeng.com/api/create-withdrawal/',
                  headers: {
                    HttpHeaders.authorizationHeader: "JWT " + contents,
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: wtBody),
              profileUpdate = {"balance": (bb - ammt).toStringAsFixed(2)},

              pBody = json.encode(profileUpdate),

              pResponse = await put(
                  'https://lcapi.loosechangeng.com/api/profiles/' +
                      profileList[0].toString() +
                      "/",
                  headers: {
                    HttpHeaders.authorizationHeader: "JWT " + contents,
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: pBody),

              print(pResponse.body),

              globals.withdrawalComplete = true,
              pr.hide(),
              Navigator.pushReplacementNamed(context, '/loader-page-two'),
            }
          else
            {
              // print('false');
              pr.hide(),
              errorWith(context),
              pr.hide(),
            }
        });
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  Future<Map> getUserUpdatedDetails() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          pr.show();
          final file = await _localTokenFile;
          // Read the file

          String contents = await file.readAsString();

          final usernamefile = await _localUsernameFile;
          // Read the file

          String usernamecontents = await usernamefile.readAsString();
          print(usernamecontents);

          // print(contents);
          final parts = contents.split('.');
          if (parts.length != 3) {
            throw Exception('invalid token');
          }

          final payload = _decodeBase64(parts[1]);
          final payloadMap = json.decode(payload);
          if (payloadMap is! Map<String, dynamic>) {
            throw Exception('invalid payload');
          }

          print(payloadMap["user_id"]);

          Response response = await get(
            'https://lcapi.loosechangeng.com/api/users/' +
                payloadMap["user_id"].toString() +
                "/",
            headers: {
              HttpHeaders.authorizationHeader: "JWT " + contents,
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );

          String data = response.body;
          var user = json.decode(data);

          setState(() {
            globals.userDetails = user;
            // print(globals.userDetails);

            Map profile = user["profile"];
            globals.profileDetails = profile;

            // Navigator.pushReplacementNamed(context, '/homepage');

            userList = globals.userDetails.values.toList();

            profileList = globals.profileDetails.values.toList();
          });

          return user;
        } catch (e) {
          // If there is an error reading, return a default String
          return null;
        }
      }
    } on SocketException catch (_) {
      noConnection(context);
    }
  }

  errorBalance(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Insufficient Balance!"),
      content: Text(
          "Your LooseChange balance is not sufficient to make this transaction. Try a lower amount."),
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

  errorLimit(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Limit Not Met!"),
      content: Text("You cannot withdraw less than ₦2,000."),
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

  errorAmtCharge(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Insufficient Balance!"),
      content: Text(
          "Your LooseChange balance is not sufficient to make this transaction. You need to have ₦100 + withdrawal amount to use this option. Try charge from withdrawal funds instead."),
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

  errorWith(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error Processing!"),
      content: Text("There was an error processing your request"),
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
