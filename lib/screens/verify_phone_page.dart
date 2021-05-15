import 'package:flutter/material.dart';
import 'package:loosechange/components/reusable_bg.dart';
import 'package:loosechange/components/custom_positioning.dart';
import 'package:loosechange/components/appbar_widget.dart';
import 'package:loosechange/components/reusable_text.dart';
import 'package:loosechange/components/divider.dart';
import 'package:loosechange/components/auth_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:country_code_picker/country_code_picker.dart';

import '../globals.dart' as globals;
import 'package:http/http.dart';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VerifyPhonePage extends StatefulWidget {
  @override
  _VerifyPhonePageState createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends State<VerifyPhonePage> {
  String phoneNumber;
  String dialCode;
  static List verificationsList;
  static List profileList;

  ProgressDialog pr;

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileList = globals.profileDetails.values.toList();
    verificationsList =  globals.verifyDetails.values.toList();
    print(verificationsList);

  }

  @override
  Widget build(BuildContext context) {

    pr = new ProgressDialog(context, 
    isDismissible: false
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
                appbarTextTwo: 'Verify Phone',
              ),
            ),
            BuildDivider(
              dividerTop: 200.0,
            ),
            new CustomPositioning(
              customBottom: 50.0,
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
                    //color: Colors.yellow,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Verify Phone Number",
                            style: TextStyle(
                              fontSize: 40.0,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: CountryCodePicker(
                                onChanged: (code){
                                  this.dialCode = code.dialCode;
                                },
                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                initialSelection: 'NG',
                                favorite: ['+234', 'NG'],
                                //Get the country information relevant to the initial selection
                                onInit: (code) => {
                                  this.dialCode = '$code'
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Expanded(
                                flex: 1,
                                child: Container(
                                  //color: Colors.yellow,
                                  height: 70.0,
                                  width: 220,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20.0),
                                      topLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(20.0),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                      border: InputBorder.none,
                                    ),
                                    keyboardType: TextInputType.number,
                                    initialValue: '',
                                    style: TextStyle(
                                        // color: Colors.white,
                                        fontWeight: FontWeight.w300),
                                    onChanged: (text){
                                      phoneNumber = text;
                                       print(phoneNumber);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 20.0),
                          child: AuthButton(
                            onPressed: () {
                              addPhone();
                            },
                            buttontext: 'PROCEED',
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

  Future<void> addPhone() async {
    this.phoneNumber = dialCode + phoneNumber;
    print(phoneNumber);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      
      pr.show();
      int min = 100000; //min and max values act as your 6 digit range
      int max = 999999;
      var randomizer = new Random(); 
      var rNum = min + randomizer.nextInt(max - min);
      
      var url = "https://api.twilio.com/2010-04-01/Accounts/ACab33d89a516b5f4f3ba7e52249459f76/Messages.json";

      Map text = {
        "Body" : rNum.toString(),
         "From" : 'MG2674c1fab703733c203747e4e71d70bf',
        "To" : phoneNumber,
      };

    var key = base64.encode(utf8.encode('ACab33d89a516b5f4f3ba7e52249459f76' + ':' + 'ff66821b1f27f88a538ad4f5e37fe93d'));
    // print(key);

    var body = json.encode(text);
    var client = http.Client();

    var response = await client.post(url, headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        HttpHeaders.authorizationHeader: 'Basic ' + key
      }, 
      body: text
    ).timeout(Duration(seconds: 10));
    print(body);
    var textArray;
    textArray = json.decode(response.body);
    print(textArray);

    if(textArray["account_sid"] == "ACab33d89a516b5f4f3ba7e52249459f76"){
      final file = await _localTokenFile;
      // Read the file
      String contents = await file.readAsString();
      var date = DateTime.now();
      Map vTable = {
        "code" : rNum.toString(),
        "date_created" : date.toIso8601String(),
      };
      globals.vCode = rNum;
      globals.vPhone = phoneNumber;
      // globals.setvPhone(phoneNumber);
      // globals.setvCode(rNum);
      var vbody = json.encode(vTable);
      print("the verif: "+verificationsList[0].toString());
      Response verResponse = await put(
        'https://lcapi.loosechangeng.com/api/verifications/' + verificationsList[0].toString() + '/',
        headers: {
          HttpHeaders.authorizationHeader: "JWT " + contents,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: vbody,
      ).timeout(Duration(seconds: 10));

      if(verResponse.statusCode == 200){
        Map pTable = {
          "phone_number" : phoneNumber,
        };
        var pbody = json.encode(pTable);

        Response profileResponse = await put(
          'https://lcapi.loosechangeng.com/api/profiles/' + profileList[0].toString() + '/',
          headers: {
            HttpHeaders.authorizationHeader: "JWT " + contents,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: pbody,
        );
        if(profileResponse.statusCode == 200){
          pr.hide();
          Navigator.pushReplacementNamed(context, '/verify-code');
        }else{
          pr.hide();
          errorSendWithMessage(context,'Error Verifying PhoneNumber','Sms not sent');
        }

      }else{
        pr.hide();
        errorSend(context);

      }
      
    }else{
      pr.hide();
     // errorSend(context);
      errorSendWithMessage(context,'Error Verifying PhoneNumber','Short Message not sent,please try again later.');

    }

    pr.hide();
    
      }
    } on SocketException catch (_) {
      pr.hide();
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
      title: Text("Error Verifying Number"),
      content: Text("Please check if your number contains the +234 prefix and your number is correct."),
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

  errorSendWithMessage(BuildContext context, String heading, String message) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(heading),
      content: Text(message),
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
