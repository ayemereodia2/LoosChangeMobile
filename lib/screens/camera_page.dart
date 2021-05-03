// import 'package:flutter/material.dart';
// import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';

// Animation<double> verticalPosition;
// class CameraPage extends StatefulWidget {
//   final List<CameraDescription> cameras;
//   const CameraPage({Key key, this.cameras}) : super(key: key);

//   @override
//   _CameraPageState createState() => _CameraPageState();
// }

// class _CameraPageState extends State<CameraPage> with SingleTickerProviderStateMixin {
//   QRReaderController _controller;
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   AnimationController animationController;

//   @override
//   void initState() {
//     super.initState();
//     animationController = new AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 3),
//     );

//     animationController.addListener(() {
//       this.setState(() {});
//     });
//     animationController.forward();
//     verticalPosition = Tween<double>(begin: 0.0, end: 300.0).animate(
//       CurvedAnimation(parent: animationController, curve: Curves.linear))
//       ..addStatusListener((state) {
//           if (state == AnimationStatus.completed) {
//             animationController.reverse();
//           } else if (state == AnimationStatus.dismissed) {
//             animationController.forward();
//           }
//       });

      
//     _controller = new QRReaderController(widget.cameras.first, ResolutionPreset.medium, [CodeFormat.qr, CodeFormat.pdf417], (dynamic value){
//         print(value); // the result!
//     // ... do something
//     // wait 3 seconds then start scanning again.
//     new Future.delayed(const Duration(seconds: 3), _controller.startScanning);
//     });
//     _controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//       _controller.startScanning();
//     });
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     if (!_controller.value.isInitialized) {
//       return new Container();
//     }
//     return new AspectRatio(
//         aspectRatio: _controller.value.aspectRatio,
//         child: new QRReaderPreview(_controller));
//   }
// }

