import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loosechange/components/reusable_bg.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../globals.dart' as globals;

class LoaderPage extends StatefulWidget {
  @override
  _LoaderPageState createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkLoginD();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // backgroundColor: Colors.grey[800],
        body: Container(
          decoration: bodyGradientColor(),
          child: Center(
            child:
                SpinKitWave(color: Colors.white, type: SpinKitWaveType.start),
          ),
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

  Future<File> get _localUserFile async {
    final path = await _localPath;
    return File('$path/user.txt');
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

  Future<String> checkLoginD() async {
    try {
      final file = await _localUsernameFile;
      // Read the file

      String contents = await file.readAsString();

      getUsername();

      return contents;
    } catch (e) {
      // If there is an error reading, return a default String
      Navigator.pushReplacementNamed(context, '/login');
      return 'Error';
    }
  }

  Future<Map> getUsername() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          final file = await _localTokenFile;
          // Read the file

          String contents = await file.readAsString();

          final usernamefile = await _localUsernameFile;
          // Read the file

          String usernamecontents = await usernamefile.readAsString();
          // print(usernamecontents);

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

          print(user["id"]);

          if (user["id"] == null) {
            logout();
          }

          globals.userDetails = user;

          Map profile = user["profile"];
          globals.profileDetails = profile;

          List transactions = user["sender"] + user["receiver"];

          transactions.sort((a, b) {
            var adate = a['id']; //before -> var adate = a.expiry;
            var bdate = b['id']; //var bdate = b.expiry;
            return -adate.compareTo(bdate);
          });

          globals.transactionsDetails = transactions;

          Map account = user["account"];
          globals.accountDetails = account;

          List card = user["card_set"] != [] ? user["card_set"] : [];
          globals.cardDetails = card;
          // print(globals.cardDetails);

          List withdrawals = user["withdrawal_set"];
          withdrawals.sort((c, d) {
            var wadate = c['id']; //before -> var adate = a.expiry;
            var wbdate = d['id']; //var bdate = b.expiry;
            return -wadate.compareTo(wbdate);
          });
          globals.withDetails = withdrawals;
          // print(globals.withDetails);

          Map verify = user["verify"];
          globals.verifyDetails = verify;
          // print(globals.verifyDetails);

          if (verify["verified"] == false) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/verify-code', (route) => false);
          } else {
            Navigator.pushReplacementNamed(context, '/check-code');
          }

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

  Future<String> logout() async {
    try {
      final file = await _localUsernameFile;
      file.delete();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      Navigator.pushReplacementNamed(context, '/login');
      return 'Error';
    }
  }

  noConnection(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("TRY AGAIN"),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/');
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
