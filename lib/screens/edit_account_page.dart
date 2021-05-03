import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loosechange/components/reusable_bg.dart';
import 'package:loosechange/components/appbar_widget.dart';
import 'package:loosechange/components/form_auth_field.dart';
import 'package:loosechange/components/auth_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../globals.dart' as globals;
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class EditAccountPage extends StatefulWidget {
  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  var bankArray;
  static List userList;
  static List profileList;
  static List accountList;
  String bvn;
  String accountNumber;
  String bankName;
  String accountName;
  String recepientId;
  Map<String, String> codeName;
  List<String> a = [], b = [];
  bool _saving = false;

  ProgressDialog pr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userList = globals.userDetails.values.toList();
    profileList = globals.profileDetails.values.toList();
    accountList = globals.accountDetails.values.toList();

    bankName = accountList[3] != null ? accountList[3].toString() : '044';

    // print(accountList);
    getBankDetails();
    
  }

  getBankDetails() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    
    _saving = true;
    
    Response response = await get(
      'https://api.paystack.co/bank',
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer sk_live_866ce814af14820edc21b03791910ae288c5ce92",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    bankArray = response.body;

    bankArray = json.decode(bankArray);
    // print(bankArray.length);
    // print(bankName);
    
    getCodeName();

    } on SocketException catch (_) {
      noConnection(context);
    }
   
  }

  void getCodeName() {
    
    var i;
    String key, value;
    for (i = 0; i < bankArray['data'].length; i++) {
      key = bankArray["data"][i]["name"].toString();
      value = bankArray["data"][i]["code"].toString();

      try {
        // print(key);
        a.add(key);
        b.add(value);
        // pr.hide();
      } catch (e) {
        // print(e);
        // pr.hide();
      }
    }
    
    updateCodeName(a, b);
     _saving = false;
    
    // print(codeName);
  }

  void updateCodeName(a, b) {
    setState(() {
      codeName = Map.fromIterables(a, b);
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(bankArray);
    // print(a);
    pr = new ProgressDialog(context, isDismissible: false);
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
                  appbarTextTwo: 'Edit Account',
                  appbarFontSizeTwo: 20.0,
                ),
              ),
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FormAuthField(
                          customicon: Icons.person_add,
                          // customhinttext: 'First Name',
                          customtextinputaction: TextInputAction.next,
                          customkeyboardinputtype: TextInputType.text,
                          initialValue: accountList[4] != null ? accountList[4].toString() : '',
                          customhinttext: 'BVN',
                          onChanged: (text) {
                            bvn = text;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FormAuthField(
                          customicon: Icons.person_outline,
                          customhinttext: 'Account Number',
                          customtextinputaction: TextInputAction.next,
                          customkeyboardinputtype: TextInputType.emailAddress,
                          initialValue: accountList[1] != null ? accountList[1].toString() : '',
                          onChanged: (text) {
                            accountNumber = text;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          margin: EdgeInsets.only(left: 40.0),
                          child: DropdownButton(
                            isExpanded: true,
                            isDense: true,
                            dropdownColor: Colors.black,
                            icon: Icon(Icons.arrow_drop_down, color: Colors.white,),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            underline: Container(
                              height: 2,
                              color: Colors.white,
                            ),
                            value: bankName,
                            onChanged: (String newValue) {
                              setState(() {
                                bankName = newValue;
                                print(bankName);
                              });
                              
                              // print(bankName);
                            },
                            items: codeName != null ? codeName.entries
                                    .map<DropdownMenuItem<String>>(
                                      (MapEntry<String, String> e) =>
                                          DropdownMenuItem<String>(
                                        child: Text(e.key,),
                                        value: e.value,
                                      ),
                                    )
                                    .toList() :  
                                    <String>[bankName, 'Two', 'Free', 'Four']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40.0, right: 16.0),
                        child: new AuthButton(
                          onPressed: () {
                            updateAccount();
                          },
                          buttontext: 'Update Account',
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

  void updateAccount() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      }
    
    try {
      pr.show();

      final file = await _localTokenFile;
      // Read the file
      String contents = await file.readAsString();

      if(bvn == null){
        bvn = accountList[4].toString();
      }

      if(accountNumber == null){
        accountNumber = accountList[1].toString();
      }

      if(bankName == null){
        bankName = accountList[3].toString();
      }

      Response bvnResponse = await get(
        'https://api.paystack.co/bank/resolve_bvn/' + bvn.toString(),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer sk_live_866ce814af14820edc21b03791910ae288c5ce92",
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var bvnArr = json.decode(bvnResponse.body);
      if(bvnArr["message"] == "BVN resolved"){
        Response accResponse = await get(
          'https://api.paystack.co/bank/resolve?account_number=' + accountNumber.toString() + "&bank_code=" + bankName.toString(),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer sk_live_866ce814af14820edc21b03791910ae288c5ce92",
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        var accArr = json.decode(accResponse.body);
        // print(accArr);
        if(accArr["message"] == "Account number resolved"){
          accountName = accArr["data"]["account_name"];
          Map recepient = {
            'type': "nuban",
            'name': userList[1] + " " + userList[2],
            'account_number': accountNumber.toString(),
            'bank_code': bankName.toString(),
            'currency': 'NGN',
          };
          var body = json.encode(recepient);

          Response recResponse = await post(
            'https://api.paystack.co/transferrecipient',
            headers: {
              HttpHeaders.authorizationHeader: "Bearer sk_live_866ce814af14820edc21b03791910ae288c5ce92",
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: body
          );
          var recArr = json.decode(recResponse.body);
          // print(recArr);
          if(recArr["message"] == "Transfer recipient created successfully"){
            recepientId = recArr["data"]["recipient_code"];

            Map account = {
              'account_number': int.parse(accountNumber),
              'account_name': accountName,
              'bank_name': bankName.toString(),
              'bvn': bvn.toString(),
              'recepient_id': recepientId.toString(),
            };

            var lcbody = json.encode(account);

            Response lcaccResponse = await put(
              'https://lcapi.loosechangeng.com/api/accounts/'+ accountList[0].toString() +'/',
              headers: {
                HttpHeaders.authorizationHeader: "JWT " + contents,
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: lcbody
            );
            var lcArr = json.decode(lcaccResponse.body);
            print(lcArr);
            if(lcArr["account_number"] != null){
              globals.accountUpdateComplete = true;
              pr.hide().then((value) => {
                Navigator.pop(context, true)
              });
            }else{
              pr.hide();
              errorAccountNumber(context);
            }
          }else{
            pr.hide();
            errorAccountNumber(context);
          }
        }else{
          pr.hide();
          errorAccountNumber(context);
        }
      }else{
        pr.hide();
        errorBVN(context);
      }

    } catch (e) {
      print(e);
      //return e;
    }
    } on SocketException catch (_) {
      noConnection2(context);
    }
  }

  errorBVN(BuildContext context) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
       },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error Resolving BVN!"),
      content: Text("Your BVN could not be resolved. Please check to see if it is correct then try again"),
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

  errorAccountNumber(BuildContext context) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
       },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error Resolving Account Number!"),
      content: Text("Your Account Number could not be resolved. Please check to see if it is correct then try again"),
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

  noConnection2(BuildContext context) {

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
