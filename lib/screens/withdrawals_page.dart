import 'package:flutter/material.dart';
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

class WithdrawalsPage extends StatefulWidget {
  @override
  _WithdrawalsPageState createState() => _WithdrawalsPageState();
}

class _WithdrawalsPageState extends State<WithdrawalsPage> {
  static List userList;
  static List profileList;
  static List accountList;
  static List withdrawalsList;
  final List<String> entries = <String>['No Withdrawals Yet'];

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
    if (globals.withDetails != {} ||
        globals.withDetails != null) {
      withdrawalsList = globals.withDetails;
    } else {
      withdrawalsList = [];
    }
    

    print(withdrawalsList);

  }

  @override
  Widget build(BuildContext context) {

    pr = new ProgressDialog(context, isDismissible: false);

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
                appbarTextTwo: 'Withdrawals',
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
                  child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: withdrawalsList != [] ? withdrawalsList.length : entries.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 50,
                        color: Colors.grey[100],
                        child: withdrawalsList != [] ? Center(child: Text('₦${withdrawalsList[index]["amount"].toString().replaceAllMapped(reg, mathFunc)} on ${withdrawalsList[index]["date_created"]}')) :
                         Center(child: Text('${entries[index]}')),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
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



}
