import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loosechange/components/reusable_bg.dart';
import 'package:loosechange/components/custom_positioning.dart';
import 'package:loosechange/components/appbar_widget.dart';
import 'package:loosechange/components/reusable_text.dart';
import 'package:loosechange/components/divider.dart';
import 'package:loosechange/components/auth_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
// import 'package:flutter_socket_io/flutter_socket_io.dart';
// import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

import '../globals.dart' as globals;
import 'package:http/http.dart';
import 'dart:io';
import 'dart:convert';

class TransferPage extends StatefulWidget {
  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  static List userList;
  static List profileList;
  static List transactionsList;
  String result = "Hey there !";
  double amount;
  int cardAmount;
  Map receiver;
  Map userMain;
  String cardNumber;
  String cvv;
  int expiryMonth;
  int expiryYear;

  SocketIO socket;

  double ammt;

  ProgressDialog pr;

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  // SocketIO socketIO;

  var publicKey = 'pk_live_aaa426a4a733efaa95d4a10a4aa2941d536ee98b';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userList = globals.userDetails.values.toList();

    profileList = globals.profileDetails.values.toList();

    print(globals.receiverUsername);
    socketConfig();

    // socketIO = SocketIOManager().createSocketIO(
    //   'https://node.loosechangeng.com',
    //   '/',
    // );
    // socketIO.init();
    // socketIO.connect();

    PaystackPlugin.initialize(publicKey: publicKey);
  }

  Future<void> socketConfig() async {
    SocketIOManager manager = SocketIOManager();
    // setState(() async{
    socket = await manager
        .createInstance(SocketOptions('https://node.loosechangeng.com'));
    socket.onConnect((data) {
      print("connectedzzz...");
      print(data);
      // });
    });
    socket.connect();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, isDismissible: false);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                  appbarTextTwo: 'Transfer',
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
                  child: TabBarView(
                    children: [
                      Padding(
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
                                      "Wallet Transfer",
                                      style: TextStyle(
                                        fontSize: 40.0,
                                        // height: 2.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Make Transfer to " +
                                          globals.rDetails["username"],
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        height: 2.0,
                                        color: Colors.white,
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
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true),
                                            style: TextStyle(
                                                // color: Colors.white,
                                                fontWeight: FontWeight.w300),
                                            onChanged: (text) {
                                              amount = double.parse(text);
                                              // print(amount);
                                            },
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: AuthButton(
                                          onPressed: () {
                                            balancePay();
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
                      Padding(
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
                                      "Card Transfer",
                                      style: TextStyle(
                                        fontSize: 40.0,
                                        // height: 2.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Make Transfer to " +
                                          globals.rDetails["username"],
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        height: 2.0,
                                        color: Colors.white,
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
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true),
                                            style: TextStyle(
                                                // color: Colors.white,
                                                fontWeight: FontWeight.w300),
                                            onChanged: (text) {
                                              cardAmount = int.parse(text);
                                              // print(amount);
                                            },
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: AuthButton(
                                          onPressed: () {
                                            connectPaystack();
                                          },
                                          buttontext: 'PAY VIA PAYSTACK',
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
                                    ],
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
              ),
            ],
          ),
        ),
        bottomNavigationBar: new TabBar(
          tabs: [
            Tab(
              icon: new Icon(Icons.account_balance_wallet),
            ),
            Tab(
              icon: new Icon(Icons.credit_card),
            ),
          ],
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.all(5.0),
          indicatorColor: Colors.blue,
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

  Future<Map> getReceiverUser() async {
    try {
      final file = await _localTokenFile;
      // Read the file

      String contents = await file.readAsString();

      Response response = await get(
        'https://lcapi.loosechangeng.com/api/users/' +
            globals.receiverUsername +
            "/",
        headers: {
          HttpHeaders.authorizationHeader: "JWT " + contents,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      String data = response.body;
      userMain = json.decode(data);
      // print(userMain);

      return userMain;
    } catch (e) {
      return e;
    }
  }

  Future<Map> getReceiverProfile(userId) async {
    try {
      receiver = userMain["profile"];

      // print(receiver);
      // print('llllngjektgntkl');
      return receiver;
    } catch (e) {
      return e;
    }
  }

  Future<Map> updateSenderBalance(int profileId, double balance) async {
    try {
      final file = await _localTokenFile;
      // Read the file
      String contents = await file.readAsString();

      Map details = {'balance': balance.toStringAsFixed(2)};

      var body = json.encode(details);

      Response response = await put(
          'https://lcapi.loosechangeng.com/api/profiles/' +
              profileId.toString() +
              '/',
          headers: {
            HttpHeaders.authorizationHeader: "JWT " + contents,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);

      // print(response.body);
      // return null;

    } catch (e) {
      print(e);
      return e;
    }
  }

  Future<Map> updateReceiverBalance(int profileId, double balance) async {
    try {
      final file = await _localTokenFile;
      // Read the file
      String contents = await file.readAsString();

      Map details = {'balance': balance.toStringAsFixed(2)};

      var body = json.encode(details);

      Response response = await put(
          'https://lcapi.loosechangeng.com/api/profiles/' +
              profileId.toString() +
              '/',
          headers: {
            HttpHeaders.authorizationHeader: "JWT " + contents,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);

      // pr.hide();

      // print(response.body);
      // return null;

    } catch (e) {
      print(e);
      return e;
    }
  }

  Future makeTransaction(
      int senderId, int receiverId, double amount, DateTime date) async {
    try {
      final file = await _localTokenFile;
      // Read the file
      String contents = await file.readAsString();

      Map details = {
        'sender': senderId,
        'receiver': receiverId,
        'amount': amount.toStringAsFixed(2),
        'date_created': date,
      };

      dynamic myEncode(dynamic item) {
        if (item is DateTime) {
          return item.toIso8601String();
        }
        return item;
      }

      var body = json.encode(details, toEncodable: myEncode);

      Response response =
          await post('https://lcapi.loosechangeng.com/api/create-transaction/',
              headers: {
                HttpHeaders.authorizationHeader: "JWT " + contents,
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: body);

      Map sodetails = {
        'sender': senderId,
        'receiver': receiverId,
        'amount': amount.toStringAsFixed(2),
        'date_created': date.toIso8601String(),
      };

      socket.emit("new_transaction", [
        {'transaction': sodetails}
      ]);
      // socket.connect();

      // socketIO.sendMessage('new_transaction', json.encode({'transaction': sodetails}));

      pr.hide().then((value) => {
            globals.transfercomplete = true,
          });
      print(response.body);
      // return null;

    } catch (e) {
      print(e);
      return e;
    }
  }

  Future<double> balancePay() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var amt;
        var balance;
        var receiverBalance;
        var date = DateTime.now();
        var rcb;
        try {
          getUserUpdatedDetails().then((response) => {
                // print(amount);
                // print('fjskgkldfjsgsfd');
                amt = profileList[3] != null ? profileList[3] : 0,
                ammt = double.tryParse(amt),
                // print(ammt);
                if (amount <= ammt)
                  {
                    print(true),
                    if (amount >= 0.01 && amount <= 10000000)
                      {
                        pr.show(),
                        balance = profileList[3] != null ? profileList[3] : 0,
                        balance = double.tryParse(balance),
                        balance = balance - amount,
                        print(balance),
                        getReceiverUser().then((response) => {
                              getReceiverProfile(userMain.values.toList()[0])
                                  .then((response) => {
                                        rcb =
                                            receiver.values.toList()[3] != null
                                                ? receiver.values.toList()[3]
                                                : 0,
                                        rcb = double.tryParse(rcb),
                                        print(balance),
                                        receiverBalance =
                                            receiver.values.toList()[3] != null
                                                ? rcb + amount
                                                : amount,
                                        updateSenderBalance(
                                            profileList[0], balance),
                                        updateReceiverBalance(
                                            receiver.values.toList()[0],
                                            receiverBalance),
                                        makeTransaction(
                                                userList[0],
                                                userMain.values.toList()[0],
                                                amount,
                                                date)
                                            .then((value) =>
                                                Navigator.pushReplacementNamed(
                                                    context,
                                                    '/loader-page-two'))
                                      }),
                            }),
                      }
                    else
                      {
                        pr.hide(),
                        transferDenied(context),
                      }
                  }
                else
                  {
                    pr.hide(),
                    insufficientBalance(context),
                    // print('false');
                  }
              });
          // Navigator.pushReplacementNamed(context, '/login');
        } catch (e) {
          print(e);
          // Navigator.pushReplacementNamed(context, '/login');
          return e;
        }
      }
    } on SocketException catch (_) {
      noConnection(context);
    }
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

  PaymentCard getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: '',
      cvc: '',
      expiryMonth: 01,
      expiryYear: 20,
    );
  }

  connectPaystack() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}

      var perc = cardAmount.toDouble() * 0.015;

      if (cardAmount >= 10 && cardAmount <= 10000000) {
        pr.show();
        Charge charge = Charge();
        charge.card = getCardFromUI();
        charge
          ..amount = (cardAmount + perc.toInt() + 100) * 100
          ..email = userList[4]
          ..reference = getReference()
          ..putCustomField('Charged From', 'LooseChange Mobile App');
        PaystackPlugin.chargeCard(
          context,
          charge: charge,
          beforeValidate: (Transaction transaction) {},
          onError: (Object e, Transaction transaction) {
            print(e);
            pr.hide();
            errorCard(context);
          },
          onSuccess: (Transaction transaction) {
            cardPay();
          },
        );
      } else {
        transferDenied(context);
      }
    } on SocketException catch (_) {
      noConnection(context);
    }
  }

  Future<String> cardPay() async {
    try {
      if (cardAmount >= 10 && cardAmount <= 10000000) {
        var receiverBalance;
        var date = DateTime.now();
        var rcb;
        getReceiverUser().then((response) => {
              getReceiverProfile(userMain.values.toList()[0])
                  .then((response) => {
                        rcb = receiver.values.toList()[3] != null
                            ? receiver.values.toList()[3]
                            : 0,
                        rcb = double.tryParse(rcb),
                        receiverBalance = receiver.values.toList()[3] != null
                            ? rcb + cardAmount
                            : cardAmount,
                        updateReceiverBalance(
                            receiver.values.toList()[0], receiverBalance),
                        makeTransaction(
                                userList[0],
                                userMain.values.toList()[0],
                                cardAmount.toDouble(),
                                date)
                            .then((value) => Navigator.pushReplacementNamed(
                                context, '/loader-page-two'))
                      }),
            });
      } else {
        pr.hide();
        transferDeniedCard(context);
      }
    } catch (e) {
      return 'Error';
    }
  }

  getReference() {
    var text = "";
    var rng = new Random();

    for (var i = 0; i < 10; i++) text += rng.nextInt(100).toString();

    return text;
  }

  insufficientBalance(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Insufficient Funds!"),
      content: Text(
          "Your LooseChange balance is insufficient for this transaction. Kindly fund your account or make a card transfer."),
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

  transferDenied(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Transfer Denied!"),
      content: Text(
          "Amount limit not reached. Send amounts between ₦0.01 and ₦10 Million"),
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

  transferDeniedCard(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Transfer Denied!"),
      content: Text(
          "Amount limit not reached. Send amounts between ₦10 and ₦10 Million"),
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
