import 'package:flutter/material.dart';
import 'package:loosechange/components/reusable_bg.dart';
import 'package:loosechange/components/appbar_widget.dart';
import 'package:loosechange/components/auth_button.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../globals.dart' as globals;
import 'package:http/http.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math';

class CardPage extends StatefulWidget {
  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  int amount;
  var updatedBalance;
  var differr;
  int count = 0;
  int transCounter = 0;
  var enteredProf;

  static List userList;
  static List profileList;

  // ProgressDialog pr;
  bool _saving = false;
  Timer timer;

  var publicKey = 'pk_live_aaa426a4a733efaa95d4a10a4aa2941d536ee98b';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userList = globals.userDetails.values.toList();

    profileList = globals.profileDetails.values.toList();

    PaystackPlugin.initialize(publicKey: publicKey);

    checkPBalance();
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

  checkPBalance() {
    if (globals.confirmedBankTransfer == true) {
      // Future.delayed(const Duration(milliseconds: 15000), () {
      setState(() {
        _saving = true;
      });
      timer = Timer.periodic(
        Duration(seconds: 10),
        (Timer t) => setState(() async {
          if (count >= 60) {
            t.cancel();
          } else {
            setState(() {
              count = count + 1;
            });
            print(count);
            Response response = await get(
              'https://api.paystack.co/balance',
              headers: {
                HttpHeaders.authorizationHeader:
                    "Bearer sk_live_866ce814af14820edc21b03791910ae288c5ce92",
                'Content-Type': 'application/json; charset=UTF-8',
              },
            );

            String data = response.body;
            // print(data);
            var datt = json.decode(data);
            // print(datt);
            // print(datt["data"][0]["balance"]);
            if (datt != null) {
              updatedBalance = datt["data"][0]["balance"];
              differr = updatedBalance - globals.payBal;
              differr = differr / 100;
              // print(differr / 100);
              if (differr == double.parse(globals.bankTransferAmount)) {
                var date;
                final file = await _localTokenFile;
                String contents;
                Map details;
                var body;
                Response responsel;
                var newB;

                dynamic myEncode(dynamic item) {
                  if (item is DateTime) {
                    return item.toIso8601String();
                  }
                  return item;
                }

                Map pDetails;
                var pBody;
                Response profResponse;

                getUserUpdatedDetails().then((value) async => {
                      date = DateTime.now(),

                      // Read the file
                      contents = await file.readAsString(),

                      details = {
                        'sender': userList[0],
                        'receiver': userList[0],
                        'amount': amount,
                        'date_created': date,
                      },

                      setState(() {
                        transCounter = transCounter + 1;
                      }),

                      body = json.encode(details, toEncodable: myEncode),

                      if (transCounter <= 1)
                        {
                          responsel = await post(
                              'https://lcapi.loosechangeng.com/api/create-transaction/',
                              headers: {
                                HttpHeaders.authorizationHeader:
                                    "JWT " + contents,
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                              },
                              body: body),
                          print(responsel.body),
                        },

                      newB = profileList[3] != null ? profileList[3] : 0,
                      newB = double.parse(newB),

                      pDetails = {
                        'balance':
                            profileList[3] != null ? newB + amount : amount,
                      },

                      pBody = json.encode(pDetails),

                      if (enteredProf == null)
                        {
                          profResponse = await put(
                              'https://lcapi.loosechangeng.com/api/profiles/' +
                                  profileList[0].toString() +
                                  '/',
                              headers: {
                                HttpHeaders.authorizationHeader:
                                    "JWT " + contents,
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                              },
                              body: pBody),
                          print(profResponse.body),
                        },

                      enteredProf = 'entered',

                      setState(() {
                        _saving = false;
                      }),

                      // if (_saving == false) {
                      t.cancel(),
                      count = 0,
                      differr = null,
                      datt = null,
                      globals.transfercomplete = true,
                      globals.confirmedBankTransfer = false,
                      Navigator.pushReplacementNamed(
                          context, '/loader-page-two'),
                      // }
                    });
              } else {
                if (count >= 60) {
                  setState(() {
                    // globals.payBal = datt["data"][0]["balance"];
                    globals.confirmedBankTransfer = false;
                    _saving = false;
                  });
                  count = 0;
                  differr = null;
                  datt = null;
                  globals.transferTimeElapsed = true;
                  Navigator.pushReplacementNamed(context, '/loader-page-two');
                  print('timed out');
                }
                setState(() {
                  globals.payBal = updatedBalance;
                });
              }
            }
          }
        }),
      );
      // });
    }
  }

  doCheck() async {
    // print(double.parse(globals.bankTransferAmount));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // pr = new ProgressDialog(context, isDismissible: false);
    return Scaffold(
      body: ModalProgressHUD(
        opacity: 0.3,
        color: Color(0xFF9DCCB3B),
        inAsyncCall: _saving,
        child: Container(
          decoration: bodyGradientColor(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: CustomAppBar(
                  appbarTextOne: '',
                  appbarTextTwo: 'Cards',
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
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: CreditCardWidget(
                      //     cardNumber: cardNumber,
                      //     expiryDate: expiryDate,
                      //     cardHolderName: cardHolderName,
                      //     cvvCode: cvvCode,
                      //     showBackView: isCvvFocused,
                      //     height: 175,
                      //     textStyle: TextStyle(color: Colors.yellowAccent),
                      //     width: MediaQuery.of(context).size.width,
                      //     animationDuration: Duration(milliseconds: 1000),
                      //   ),
                      // ),
                      if (globals.confirmedBankTransfer == false) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
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
                                keyboardType: TextInputType.number,
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AuthButton(
                            onPressed: () {
                              if (amount != null) {
                                if (amount >= 100) {
                                  getBalance();
                                } else {
                                  errorNoAmt(context);
                                }
                              } else {
                                errorNoAmt(context);
                              }
                            },
                            buttontext: 'Make Bank Transfer',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AuthButton(
                            onPressed: () {
                              fundAccount();
                            },
                            buttontext: 'Fund Account via Paystack',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Funding via Paystack will attract a 1.5% + ₦100 charge',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ] else ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Please Wait! We are verifying your transfer. This may take up to 10 minutes. Please do not leave this page',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          setState(() {
            _saving = true;
          });
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

  PaymentCard getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: '',
      cvc: '',
      expiryMonth: 01,
      expiryYear: 20,
    );
  }

  getReference() {
    var text = "";
    var rng = new Random();

    for (var i = 0; i < 10; i++) text += rng.nextInt(100).toString();

    return text;
  }

  fundAccount() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}

      var perc = amount.toDouble() * 0.015;

      if (amount > 0) {
        Charge charge = Charge();
        setState(() {
          _saving = true;
        });

        charge.card = getCardFromUI();
        charge
          ..amount = (amount + perc.toInt() + 100) * 100
          ..email = userList[4]
          ..reference = getReference()
          ..putCustomField('Charged From', 'LooseChange Mobile App');
        PaystackPlugin.chargeCard(
          context,
          charge: charge,
          beforeValidate: (Transaction transaction) {},
          onError: (Object e, Transaction transaction) {
            print(e);
            setState(() {
              _saving = false;
            });
            errorCard(context);
          },
          onSuccess: (Transaction transaction) {
            cardPay();
          },
        );
      } else {
        setState(() {
          _saving = false;
        });
        errorNoPayAmt(context);
      }
    } on SocketException catch (_) {
      noConnection(context);
    }
  }

  cardPay() async {
    try {
      var date;
      final file = await _localTokenFile;
      // Read the file
      String contents = await file.readAsString();
      Map details;

      dynamic myEncode(dynamic item) {
        if (item is DateTime) {
          return item.toIso8601String();
        }
        return item;
      }

      var body;
      Response response;
      var newB;
      Map pDetails;
      var pBody;
      Response profResponse;

      getUserUpdatedDetails().then((fll) async => {
            setState(() {
              _saving = true;
            }),

            date = DateTime.now(),

            details = {
              'sender': userList[0],
              'receiver': userList[0],
              'amount': amount,
              'date_created': date,
            },

            body = json.encode(details, toEncodable: myEncode),

            response = await post(
                'https://lcapi.loosechangeng.com/api/create-transaction/',
                headers: {
                  HttpHeaders.authorizationHeader: "JWT " + contents,
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: body),

            newB = profileList[3] != null ? profileList[3] : 0,
            newB = double.parse(newB),

            pDetails = {
              'balance': profileList[3] != null ? newB + amount : amount,
            },

            pBody = json.encode(pDetails),

            profResponse = await put(
                'https://lcapi.loosechangeng.com/api/profiles/' +
                    profileList[0].toString() +
                    '/',
                headers: {
                  HttpHeaders.authorizationHeader: "JWT " + contents,
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: pBody),

            setState(() {
              _saving = false;
            }),

            // if (_saving == false) {
            globals.transfercomplete = true,
            Navigator.pushReplacementNamed(context, '/loader-page-two'),
            // }
            // return null;
          });
    } catch (e) {
      print(e);
      return e;
    }
  }

  getBalance() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
      setState(() {
        _saving = true;
      });
      Response response = await get(
        'https://api.paystack.co/balance',
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer sk_live_866ce814af14820edc21b03791910ae288c5ce92",
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      String data = response.body;
      // print(data);
      var datt = json.decode(data);
      // print(datt);
      // print(datt["data"][0]["balance"]);
      if (datt != null) {
        globals.bankTransferAmount = amount.toString();
        globals.payBal = datt["data"][0]["balance"];
        setState(() {
          _saving = false;
        });
        Navigator.pushNamed(context, '/bank-transfer')
            .then((value) => setState(() {
                  globals.confirmedBankTransfer = globals.confirmedBankTransfer;
                  checkPBalance();
                }));
      }
    } on SocketException catch (_) {
      noConnection(context);
    }
  }

  errorCard(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error Processing Request!"),
      content: Text(
          "Please verify if your card has sufficient balance then try again."),
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

  errorNoAmt(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Invalid Amount!"),
      content: Text("A minimum of ₦100 is required."),
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

  errorNoPayAmt(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Invalid Amount!"),
      content: Text("A minimum of ₦100 is required."),
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
