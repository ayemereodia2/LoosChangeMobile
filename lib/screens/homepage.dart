import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loosechange/components/reusable_bg.dart';
import 'package:loosechange/components/custom_positioning.dart';
import 'package:loosechange/components/appbar_widget.dart';
import 'package:loosechange/components/custom_walletbalance.dart';
import 'package:loosechange/components/custom_walletbalance.dart' as wallet;
import 'package:loosechange/components/camera_icon.dart';
import 'package:loosechange/components/reusable_text.dart';
import 'package:loosechange/components/circle_icon.dart';
import 'package:loosechange/components/divider.dart';
import 'package:loosechange/components/custom_button.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_socket_io/flutter_socket_io.dart';
// import 'package:flutter_socket_io/socket_io_manager.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:quiver/core.dart';
import 'package:loosechange/screens/login_page.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../globals.dart' as globals;
import 'dart:async';
import 'dart:math';
import 'dart:convert';
import "../components/string_extension.dart";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List userList;
  static List profileList;
  static List transactionsList;
  String result = "Hey there !";
  int fName;
  int lName;
  bool called = false;

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  // SocketIO socketIO;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  bool _saving = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userList = globals.userDetails.values.toList();

    profileList = globals.profileDetails.values.toList();

    if (globals.transactionsDetails != [] ||
        globals.transactionsDetails != null) {
      transactionsList = globals.transactionsDetails;
    } else {
      transactionsList = ['', '', '', ''];
    }

    final set = Set<Trans>.from(transactionsList.map<Trans>((trans) => Trans(
        trans['id'],
        trans['sender_username'],
        trans['receiver_username'],
        trans['amount'],
        trans['date_created'])));

    final result = set.map((trans) => trans.toMap()).toList();
    print(result);
    transactionsList = result;

    print(fName);

    if (userList[1] != null && userList[1] != '') {
      fName = userList[1].length;
      lName = userList[2].length;
    } else {
      fName = null;
    }

    // print('kjhgjkjhg');
    print(fName);

    new Future.delayed(const Duration(seconds: 1))
        .then((_) => successTransaction());

    new Future.delayed(const Duration(seconds: 1))
        .then((_) => bankTransferTimeElapsed());

    new Future.delayed(const Duration(seconds: 1))
        .then((_) => successUpdateProfile());

    new Future.delayed(const Duration(seconds: 1))
        .then((_) => successWithdrawal());
    print(called);

    // socketIO = SocketIOManager().createSocketIO(
    //   'https://node.loosechangeng.com',
    //   '/',
    // );
    // socketIO.init();
    // socketIO.subscribe('transaction', (jsonData) {
    //   //Convert the JSON data received into a Map
    //   Map<String, dynamic> data = json.decode(jsonData);
    //   if (data['transaction']['receiver'] == userList[0]) {
    //     getTransDetails(
    //         data['transaction']['sender'], data['transaction']['amount']);

    //     socketIO.unSubscribesAll();
    //   }
    // });
    // socketIO.connect();

    socketConfig();

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> socketConfig() async {
    SocketIOManager manager = SocketIOManager();
    String soc_date = "";

    SocketIO socket = await manager
        .createInstance(SocketOptions('https://node.loosechangeng.com'));
    socket.onConnectError((data) {
      print(data);
      print('aa');
    });
    socket.onConnectTimeout((data) {
      print(data);
      print('fjhsdafjakd');
    });
    socket.onError((data) {
      print(data);
      print('22');
    });
    socket.onDisconnect((data) {
      print(data);
    });
    socket.onConnect((data) {
      print("connected...");
      print(data);
      // socket.emit("message", ["Hello world!"]);
    });
    print('hg');
    socket.on("transaction", (data) {
      print(data);
      print('kfds');
      print(soc_date);
      if (soc_date != data['transaction']['date_created']) {
        if (data['transaction']['receiver'] == userList[0]) {
          setState(() {
            soc_date = data['transaction']['date_created'];
          });

          print(soc_date);
          getTransDetails(
              data['transaction']['sender'], data['transaction']['amount']);
          socket.off('transaction');
        }
      }

      print(data);
      socket.off('transaction');
      manager.clearInstance(socket);
      socket.connect();
    });
    socket.connect();

    ///disconnect using
    ///manager.
  }

  Future onSelectNotification(String payload) {
    debugPrint("Payload : $payload");
    print(called);
    if (called == true) {
      called = false;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text('New Transaction'),
              content: new Text('$payload'),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.cancel,
                  ),
                ),
              ],
            );
          });
    }
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {

    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return Scaffold(
      key: key,
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: ListTile.divideTiles(
              context: context,
              tiles: [
                UserAccountsDrawerHeader(
                  decoration: bodyGradientColor(),
                  accountName: ReusableText(
                    customtext: userList[1] + " " + userList[2],
                  ),
                  accountEmail: ReusableText(
                    customtext: userList[3],
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(profileList[1]),
                    radius: 30.0,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/profile');
                  },
                  title: ReusableText(
                    customtext: 'Profile',
                    colour: Color(0xFF4A4A4A),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/accounts');
                  },
                  title: ReusableText(
                    customtext: 'Accounts',
                    colour: Color(0xFF4A4A4A),
                  ),
                ),
                // ListTile(
                //   title: ReusableText(
                //     customtext: 'Transfer',
                //     colour: Color(0xFF4A4A4A),
                //   ),
                // ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/cards');
                  },
                  title: ReusableText(
                    customtext: 'Cards',
                    colour: Color(0xFF4A4A4A),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/support');
                  },
                  title: ReusableText(
                    customtext: 'Support',
                    colour: Color(0xFF4A4A4A),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/about');
                  },
                  title: ReusableText(
                    customtext: 'About',
                    colour: Color(0xFF4A4A4A),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new CustomButton(
                    onPressed: () {
                      logout();
                      print('Logout Button Pressed');
                    },
                    startColor: Color(0xFFF5515F),
                    endColor: Color(0xFF9F041B),
                    buttonText: 'LOG OUT',
                  ),
                ),
              ],
            ).toList(),
          ),
        ),
      ),
      body: SlidingUpPanel(
        renderPanelSheet: true,
        borderRadius: radius,
        panelBuilder: (ScrollController sc) => _scrollingList(sc),
        body: ModalProgressHUD(
          opacity: 0.3,
          color: Color(0xFF9DCCB3B),
          inAsyncCall: _saving,
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: WaterDropMaterialHeader(),
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text("pull up load");
                } else if (mode == LoadStatus.loading) {
                  body = SpinKitWave(
                      color: Colors.lightGreen, type: SpinKitWaveType.start);
                } else if (mode == LoadStatus.failed) {
                  body = Text("Load Failed!Click retry!");
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("release to load more");
                } else {
                  body = Text("No more Data");
                }
                return Container(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: Container(
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
                      appbarTextOne: 'ID: ' + userList[0].toString(),
                      appbarTextTwo: fName != null
                          ? fName >= 8
                              ? 'Hello, ' +
                                  userList[1]
                                      .toString()
                                      .substring(0, 7)
                                      .capitalize() +
                                  "..."
                              : 'Hello, ' + userList[1].toString().capitalize()
                          : '',
                      // appbarTextThree: lName >= 8
                      //     ? " " + userList[2].toString().substring(0, 8) + ".."
                      //     : " " + userList[2],
                    ),
                  ),
                  new CustomPositioning(
                    customTop: 90.0,
                    customChild: new CustomWalletBalance(
                        customtext: profileList[3] != null
                            ? profileList[3]
                                .toString()
                                .replaceAllMapped(reg, mathFunc)
                            : '0',
                        onQRTap: () {
                          Navigator.pushNamed(context, '/qr');
                        }),
                  ),
                  BuildDivider(
                    dividerTop: 200.0,
                  ),
                  new CustomPositioning(
                    customTop: 210.0,
                    customChild: Center(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: 200.0,
                            height: 200.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(stops: [
                                0.5,
                                0.7,
                                0.9
                              ], colors: [
                                Color(0xFF9DCB3B),
                                Colors.blueGrey,
                                Colors.white12
                              ]),
                            ),
                            child: FlatButton(
                              highlightColor: Colors.transparent,
                              onPressed: _scanQR,
                              child: CameraIcon(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  new CustomPositioning(
                    customTop: 400.0,
                    customChild: Center(
                      child: ReusableText(
                        customtext: 'Tap to scan QR code',
                        colour: Colors.blueGrey,
                        customFontSize: 14.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  new CustomPositioning(
                    customTop: 450,
                      customChild: ButtonBar(
                        buttonHeight: 50,
                        alignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max, // this will take space as minimum as posible(to center)
                        children: <Widget>[
                          new RaisedButton(
                            child: new Text('Pay'),
                            onPressed: null,
                          ),
                          new RaisedButton(
                            child: new Text('Save'),
                            onPressed: null,
                          ),
                          new RaisedButton(
                            child: new Text('Gets'),
                            onPressed: null,
                          ),
                          new RaisedButton(
                            child: new Text('Bills'),
                            onPressed: null,
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
        panel: getMyListView(),
        collapsed: Container(
          decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: radius
          ),
          child: Center(
            child: Text(
              "Wallet History",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        panelSnapping: false,
        isDraggable: true,
        maxHeight: 800,
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

  Future<String> logout() async {
    try {
      final file = await _localUsernameFile;
      file.delete();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          ModalRoute.withName("/login"));
    } catch (e) {
      final file = await _localUsernameFile;
      file.delete();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          ModalRoute.withName("/login"));
      return 'Error';
    }
  }

  Color getMyColor(String sender, String receiver) {
    if (sender == userList[3] && receiver != userList[3]) {
      return Color(0xFFDE4C5E);
    } else if (sender == userList[3] && receiver == userList[3]) {
      return Color(0xFF00BDB5);
    } else {
      return Color(0xFF00BDB5);
    }
  }

  Widget _scrollingList(ScrollController sc){
    return ListView.builder(
      controller: sc,
      itemCount: 50,
      itemBuilder: (BuildContext context, int i){
        return Container(
          padding: const EdgeInsets.all(5.0),
          child: Text('$i'),
        );
      },
    );
  }

  ListView getMyListView() {
    // print(globals.transactionsDetails);
    if (globals.transactionsDetails != null &&
        globals.transactionsDetails != []) {
      if (globals.transactionsDetails?.isEmpty ?? true) {
        return ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Container(
              height: 50,
              color: Colors.white,
              child: const Center(
                child: Text(
                  'No Transactions Yet',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        );
      }
      // if(globals.transactionsDetails[0] != null && globals.transactionsDetails[0] != ''){
      // print(transactionsList);
      return ListView.separated(
        padding: EdgeInsets.all(16.0),
        itemCount: transactionsList.length,
        separatorBuilder: (BuildContext context, index) => Divider(),
        itemBuilder: (BuildContext context, index) {
          return ListTile(
            leading: getCircleIcon(
                transactionsList[index]['sender_username'].toString(),
                transactionsList[index]['receiver_username'].toString()),
            title: ReusableText(
              colour: Colors.black,
              customtext:
                  transactionsList[index]['sender_username'].toString() +
                      ' to ' +
                      transactionsList[index]['receiver_username'].toString() +
                      ' on ' +
                      DateFormat('yyyy-MM-dd – kk:mm')
                          .format(DateTime.tryParse(
                              transactionsList[index]['date_created']))
                          .toString(),
            ),
            trailing: ReusableText(
              customtext: '₦' +
                  transactionsList[index]['amount']
                      .toString()
                      .replaceAllMapped(reg, mathFunc),
              colour: getMyColor(
                  transactionsList[index]['sender_username'].toString(),
                  transactionsList[index]['receiver_username'].toString()),
            ),
            onTap: () {
              globals.transferUsername =
                  transactionsList[index]['receiver_username'].toString();
              globals.transferAmount =
                  transactionsList[index]['amount'].toString();
              globals.transferDate = DateFormat('yyyy-MM-dd – kk:mm')
                  .format(DateTime.tryParse(
                      transactionsList[index]['date_created']))
                  .toString();
              Navigator.pushNamed(context, '/transaction');
            },
          );
        },
      );
      // } else {
      //   return ListView();
      // }
    } else {
      return ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Container(
            height: 50,
            color: Colors.black,
            child: const Center(
              child: Text(
                'No Transactions Yet',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      );
    }
  }

  Icon getCircleIcon(String sender, String receiver) {
    if (sender == userList[3] && receiver != userList[3]) {
      return Icon(
        Icons.arrow_upward,
        color: Color(0xFFDE4C5E),
      );
      // return CircleIcon(
      //     gradientStart: Color(0xFFDE4C5E), gradientStop: Color(0xFFDE4C5E));
    } else if (sender == userList[3] && receiver == userList[3]) {
      return Icon(
        Icons.arrow_downward,
        color: Color(0xFF00BDB5),
      );
      // return CircleIcon(
      //     gradientStart: Color(0xFF00BDB5), gradientStop: Color(0xFF00BDB5));
    } else {
      return Icon(
        Icons.arrow_downward,
        color: Color(0xFF00BDB5),
      );
      // return CircleIcon(
      //     gradientStart: Color(0xFF00BDB5), gradientStop: Color(0xFF00BDB5));
    }
  }

  Future _scanQR() async {
    try {
      print('INSIDE SCANQR TRY BLOCK');
      String qrResult = await BarcodeScanner.scan();
      print('qrResult' + qrResult);
      setState(() async {
        print("INSIDE SCANQR SETSTATE ASYNC BLOCK");
        result = qrResult;
        print('result' + result);
        setState(() {
          _saving = true;
        });
        if (result == userList[0].toString()) {
          errorSend(context);
          setState(() {
            _saving = false;
          });
        } else {
          print("INSIDE SCANQR ELSE BLOCK");
          verifyTransferReceiver(result);
        }
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
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
      title: Text("Request Denied!"),
      content: Text(
          "You cannot send money to yourself! Fund your LooseChange account instead."),
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

  errorNoUser(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Request Denied!"),
      content: Text(
          "Invalid QRCode! No user exists on LooseChange with that code. Please try another code."),
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

  bankTransferTimeElapsed() async {
    if (globals.transferTimeElapsed == true) {
      // globals.transfercomplete = false;

      key.currentState.showSnackBar(new SnackBar(
        content: new Text(
            "Error Verifying Transfer. Kindly Contact LooseChange Support."),
      ));
      globals.transferTimeElapsed = false;
    } else {
      print('none');
    }
  }

  successTransaction() async {
    if (globals.transfercomplete == true) {
      // globals.transfercomplete = false;
      getUserUpdatedDetails();

      key.currentState.showSnackBar(new SnackBar(
        content: new Text("Transaction Successful!"),
      ));
      globals.transfercomplete = false;
    } else {
      print('none');
    }
  }

  successUpdateProfile() async {
    if (globals.profileUpdateComplete == true) {
      key.currentState.showSnackBar(new SnackBar(
        content: new Text("Profile Has Been Updated!"),
      ));
      getUserUpdatedDetails();
      globals.profileUpdateComplete = false;
    } else {
      print('none');
    }
  }

  successWithdrawal() async {
    if (globals.withdrawalComplete == true) {
      key.currentState.showSnackBar(new SnackBar(
        content: new Text("A Successful Withdrawal Was Made!"),
      ));
      getUserUpdatedDetails();
      globals.withdrawalComplete = false;
    } else {
      print('none');
    }
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    getUserUpdatedDetails();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    getUserUpdatedDetails();

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  void verifyTransferReceiver(receiver) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final file = await _localTokenFile;

        print('----INSIDE VERIFYTRANSACTIONRECEIVER----');
        // Read the file

        String contents = await file.readAsString();
        String data;

        try {
          print("INSIDE VERIFYTRANSACTION TRY BLOCK");
          print(receiver);

          Response response = await get(
            'https://lcapi.loosechangeng.com/api/users/' + receiver + "/",
            headers: {
              HttpHeaders.authorizationHeader: "JWT " + contents,
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );

          // print(response.body);
          data = response.body;
          var user = json.decode(data);
          // print(user);

          if (user["id"] == null) {
            setState(() {
              _saving = false;
            });
            errorNoUser(context);
          } else {
            setState(() {
              _saving = false;
            });

            globals.rDetails = user;

            globals.receiverUsername = receiver;
            receiver = null;
            Navigator.pushNamed(context, '/transfer');
          }
        } catch (e) {
          print("INSIDE VERIFY TRANSACTION CATCH BLOCK");
          // data = "error";
          // print(data);
          setState(() {
            _saving = false;
          });
          errorNoUser(context);
          print(e);
          // return e;
        }

        // print(data);

      }
    } on SocketException catch (_) {
      noConnection(context);
      setState(() {
        _saving = false;
      });
    }
  }

  showNotification(r_username, amount) async {
    var amt = amount;
    amt = amt.toString().replaceAllMapped(reg, mathFunc);
    getUserUpdatedDetails();
    // print('started');
    var rng = new Random();
    var android = new AndroidNotificationDetails(
        'Transaction Id', 'Transaction Name', 'Transaction Description');
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(rng.nextInt(100),
        'New Transaction', '$r_username sent you ₦$amt', platform,
        payload: '$r_username sent you ₦$amt');
  }

  Future getTransDetails(r_id, amount) async {
    try {
      final file = await _localTokenFile;
      // Read the file
      String contents = await file.readAsString();

      Response senderresponse = await get(
        'https://lcapi.loosechangeng.com/api/users/' + r_id.toString() + "/",
        headers: {
          HttpHeaders.authorizationHeader: "JWT " + contents,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      String senderData = senderresponse.body;
      var sender = json.decode(senderData);

      showNotification(sender['username'], amount);
      getUserUpdatedDetails();

      print(sender);
    } catch (e) {
      return e;
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
            globals.withDetails = withdrawals;
            // print(globals.withDetails);

            Map verify = user["verify"];
            globals.verifyDetails = verify;

            // Navigator.pushReplacementNamed(context, '/homepage');

            userList = globals.userDetails.values.toList();

            profileList = globals.profileDetails.values.toList();

            if (globals.transactionsDetails != [] ||
                globals.transactionsDetails != null) {
              transactionsList = globals.transactionsDetails;
            } else {
              transactionsList = ['', '', '', ''];
            }

            final set = Set<Trans>.from(transactionsList.map<Trans>((trans) =>
                Trans(
                    trans['id'],
                    trans['sender_username'],
                    trans['receiver_username'],
                    trans['amount'],
                    trans['date_created'])));

            final result = set.map((trans) => trans.toMap()).toList();
            print(result);
            transactionsList = result;
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

class Trans {
  const Trans(this.id, this.sender_username, this.receiver_username,
      this.amount, this.date_created);

  final int id;
  final String sender_username;
  final String receiver_username;
  final amount;
  final date_created;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender_username': sender_username,
      'receiver_username': receiver_username,
      'amount': amount,
      'date_created': date_created
    };
  }

  bool operator ==(other) => other is Trans && other.id == id;
  // int get hashCode => hash2(name.hashCode, age.hashCode);
  int get hashCode => id.hashCode;
}
