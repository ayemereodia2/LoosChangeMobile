library my_prj.globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as json;

Map userDetails;
Map profileDetails;
Map verifyDetails;
List transactionsDetails;
Map accountDetails;
List cardDetails;
List withDetails;
String receiverUsername;
Map rDetails;
bool transfercomplete = false;
bool profileUpdateComplete = false;
bool accountUpdateComplete = false;
bool withdrawalComplete = false;
String transferUsername;
String transferAmount;
String transferDate;
int vCode;
String vPhone;
String bankTransferAmount;
int payBal;
bool confirmedBankTransfer = false;
bool transferTimeElapsed = false;


void setVerifyDetails(Map verifyDetails) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var result = json.jsonEncode(verifyDetails);
  //int counter = (prefs.getInt('counter') ?? 0) + 1;
  //print('Pressed $counter times.');
  await prefs.setString('verifyDetails', result);
}


Future<Map> getVerifyDetails() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String counter = prefs.getString('verifyDetails');

  //print('Pressed $counter times.');
  //await prefs.setString('verifyDetails', verifyDetails.toString());
  return json.jsonDecode(counter);
}

void setvCode(int vCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //int counter = (prefs.getInt('counter') ?? 0) + 1;
  //print('Pressed $counter times.');
  await prefs.setInt('vCode', vCode);
}

Future<int> getvCode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int vCode = (prefs.getInt('vCode') ?? 0) ;
  return vCode;
  //print('Pressed $counter times.');
  //await prefs.setInt('vCode', vCode);
}

void setvPhone(String vPhone) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //int counter = (prefs.getInt('counter') ?? 0) + 1;
  //print('Pressed $counter times.');
  await prefs.setString('vPhone', vPhone);
}

Future<String> getvPhone() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String vPhone = prefs.getString('vPhone') ;
  return vPhone;
  //print('Pressed $counter times.');
  //await prefs.setInt('vCode', vCode);
}