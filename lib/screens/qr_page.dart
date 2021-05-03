import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loosechange/components/reusable_bg.dart';
import 'package:loosechange/components/custom_positioning.dart';
import 'package:loosechange/components/appbar_widget.dart';
import 'package:loosechange/components/divider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../globals.dart' as globals;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

class QrPage extends StatefulWidget {
  @override
  _QrPageState createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  static List userList;

  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  static GlobalKey previewContainer = new GlobalKey();
  int originalSize = 800;

  Image _image;

  ProgressDialog pr;

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userList = globals.userDetails.values.toList();
    
  }

  @override
  Widget build(BuildContext context) {

    pr = new ProgressDialog(context, isDismissible: false);

    return Scaffold(
      key: key,
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
                appbarTextTwo: 'Qr Code',
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
                child: Column(
                  children: <Widget>[
                    RepaintBoundary(
                        key: previewContainer,
                        child: QrImage(
                        data: userList[0].toString(),
                        size: 300.0,
                        version: 1,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          _getWidgetImage();
        },
        child: Icon(Icons.file_download),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<Uint8List> _getWidgetImage() async {
    try {
      RenderRepaintBoundary boundary = previewContainer.currentContext.findRenderObject();
      double pixelRatio = originalSize / MediaQuery.of(context).size.width;
      ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      Uint8List pngBytes = byteData.buffer.asUint8List();
      setState(() {
        _image = Image.memory(pngBytes.buffer.asUint8List());
      });
      // var pngBytes = byteData.buffer.asUint8List();
      // var bs64 = base64Encode(pngBytes);
      // debugPrint(bs64.length.toString());
      final directory = (await getApplicationDocumentsDirectory()).path;
      // print(directory);
      File imgFile = new File('$directory/qrcode.png');
      GallerySaver.saveImage(imgFile.path);
      imgFile.writeAsBytes(pngBytes);

      key.currentState.showSnackBar(new SnackBar(
        content: new Text("QR Code Saved!"),
      ));

      return pngBytes;
    } catch (exception) {}
  }

}
