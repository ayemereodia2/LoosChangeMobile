import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loosechange/components/reusable_bg.dart';
import 'package:loosechange/components/appbar_widget.dart';
import 'package:loosechange/components/form_auth_field.dart';
import 'package:loosechange/components/auth_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:loosechange/components/reusable_text.dart';

import '../globals.dart' as globals;
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static List userList;
  static List profileList;
  String firstName;
  String lastName;
  String phoneNumber;

  File _image;

  ProgressDialog pr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userList = globals.userDetails.values.toList();

    profileList = globals.profileDetails.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, isDismissible: false);
    return Scaffold(
      body: Container(
        decoration: bodyGradientColor(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: CustomAppBar(
                appbarTextOne: '',
                appbarTextTwo: 'Profile',
                appbarFontSizeTwo: 20.0,
              ),
            ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _image == null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(profileList[1]),
                              radius: 50.0,
                              child: Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(40.0)),
                                child: FlatButton(
                                    onPressed: getImage,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 30.0,
                                    )),
                              ),
                            )
                          : CircleAvatar(
                              backgroundImage: Image.file(_image).image,
                              radius: 50.0,
                              child: Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: FlatButton(
                                  onPressed: getImage,
                                  child: null,
                                ),
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FormAuthField(
                        customicon: Icons.person_add,
                        // customhinttext: 'First Name',
                        customtextinputaction: TextInputAction.next,
                        customkeyboardinputtype: TextInputType.text,
                        initialValue: userList[1],
                        customhinttext: 'First Name',
                        onChanged: (text) {
                          firstName = text;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FormAuthField(
                        customicon: Icons.person_outline,
                        customhinttext: 'Last Name',
                        customtextinputaction: TextInputAction.next,
                        customkeyboardinputtype: TextInputType.emailAddress,
                        initialValue: userList[2],
                        onChanged: (text) {
                          lastName = text;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FormAuthField(
                        customicon: Icons.phone,
                        customhinttext: 'Phone Number',
                        customtextinputaction: TextInputAction.next,
                        customkeyboardinputtype: TextInputType.text,
                        initialValue: profileList[2],
                        onChanged: (text) {
                          phoneNumber = text;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40.0, right: 16.0),
                      child: new AuthButton(
                        onPressed: () {
                          updateProfile();
                        },
                        buttontext: 'Update Profile',
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 40.0, right: 16.0, top: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/change-pin');
                        },
                        child: ReusableText(
                          customtext: 'Change Pin',
                          colour: Colors.white,
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

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
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

  Future<Map> updateProfile() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}

      try {
        pr.show();

        final file = await _localTokenFile;
        // Read the file
        String contents = await file.readAsString();

        if (firstName == null) {
          firstName = userList[1];
        }

        if (lastName == null) {
          lastName = userList[2];
        }

        if (phoneNumber == null) {
          phoneNumber = profileList[2];
        }

        Map userDetails = {
          'first_name': firstName,
          'last_name': lastName,
        };

        // if(_image != null){

        // }

        Map profileDetails = {
          'phone_number': phoneNumber,
        };

        String base64Image;
        if (_image != null) {
          List<int> imageBytes = _image.readAsBytesSync();
          base64Image = base64Encode(imageBytes);
        }

        Map profilePicDetails = {
          'phone_number': phoneNumber,
          'profile_pic': base64Image,
        };

        var body = json.encode(userDetails);
        var profileBody;

        if (_image == null) {
          profileBody = json.encode(profileDetails);
        } else {
          profileBody = json.encode(profilePicDetails);
        }

        // print(profileBody);

        Response response = await put(
            'https://lcapi.loosechangeng.com/api/users/' +
                userList[0].toString() +
                '/',
            headers: {
              HttpHeaders.authorizationHeader: "JWT " + contents,
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: body);

        // Response profileResponse = await put(
        //   'https://lcapi.loosechangeng.com/api/profiles/'+ profileList[0].toString() +'/',
        //   headers: {
        //     HttpHeaders.authorizationHeader: "JWT " + contents,
        //     "Content-Type": "multipart/form-data;",
        //   },
        //   body: profileBody
        // );

        if (_image != null) {
          var request = http.MultipartRequest(
              "PUT",
              Uri.parse("https://lcapi.loosechangeng.com/api/profiles/" +
                  profileList[0].toString() +
                  "/"));
          Map<String, String> headers = {
            "Accept": "application/json",
            "Authorization": "JWT " + contents
          };
          //add text fields
          request.fields["phone_number"] = phoneNumber;
          //create multipart using filepath, string or bytes
          var pic =
              await http.MultipartFile.fromPath("profile_pic", _image.path);
          //add multipart to request
          request.files.add(pic);
          request.headers.addAll(headers);
          var profileResponse = await request.send();
          var responseString;

          //Get the response from the server
          var responseData =
              await profileResponse.stream.toBytes().then((value) => {
                    pr.hide().then((value) => {
                          globals.profileUpdateComplete = true,
                          Navigator.pushNamed(context, '/homepage')
                        })
                  });
        } else {
          Response pResponse = await put(
              'https://lcapi.loosechangeng.com/api/profiles/' +
                  profileList[0].toString() +
                  '/',
              headers: {
                HttpHeaders.authorizationHeader: "JWT " + contents,
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: profileBody);
          pr.hide().then((value) => {
                globals.profileUpdateComplete = true,
                Navigator.pushNamed(context, '/homepage')
              });
        }

        // print(profileResponse.body);
        return null;
      } catch (e) {
        print(e);
        return e;
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
