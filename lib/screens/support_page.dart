import 'package:flutter/material.dart';
import 'package:loosechange/components/appbar_widget.dart';
import 'package:loosechange/components/reusable_bg.dart';
import 'package:loosechange/components/divider.dart';

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: bodyGradientColor(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: CustomAppBar(
                appbarTextOne: '',
                appbarTextTwo: 'Support',
                appbarFontSizeTwo: 20.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Divider(
                color: Colors.blueGrey,
                height: 24.0,
              ),
            ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'How do I collect my change?',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Simply tap on the QR code on the top left part of the home screen to show your QR code. Let the sender scan your code and that\'s it. You will receive a notifictation promptly.',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                    BuildDivider(
                      dividerTop: 330.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'How do I fund my wallet?',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Navigate to the cards page via the sidebar menu and click on fund account after entering the desired amount.',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                    BuildDivider(
                      dividerTop: 330.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'How do I send money?',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Tap on the camera Icon on the home screen then scan a valid LooseChange QR code of the receiver.',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                    BuildDivider(
                      dividerTop: 330.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Can I send money through my credit/debit card?',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Yes, you can! Plus LooseChange does not charge anything on transactions between users, meaning its cheaper to use LooseChange to make payments.',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                    BuildDivider(
                      dividerTop: 330.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'How do I get my money to my bank account?',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Navigate to accounts, update your bank account details and request withdrawal. NOTE: you need to enter your secret pin before you will be given access. Once completed, your bank account should be credited within a few minutes.',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                    BuildDivider(
                      dividerTop: 330.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'How much is charged from my withdrawal?',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'LooseChange charges only 3% of your withdrawal with the withdrawal floor at 3,000 Naira and the cap at 10,000,000 Naira',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                    BuildDivider(
                      dividerTop: 330.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Contact Details',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(16.0),
                    //   child: ListTile(
                    //     leading: MyBullet(),
                    //     title: Text('Phone: +234 803 446 6449', style: TextStyle(color: Colors.white)),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(16.0),
                    //   child: ListTile(
                    //     leading: MyBullet(),
                    //     title: Text('Phone: +234 818 885 9592', style: TextStyle(color: Colors.white)),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListTile(
                        leading: MyBullet(),
                        title: Text('Website: www.loosechangeng.com', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListTile(
                        leading: MyBullet(),
                        title: Text('Email: info@loosechangeng.com', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    BuildDivider(
                      dividerTop: 330.0,
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
  
}
class MyBullet extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Container(
    height: 10.0,
    width: 10.0,
    decoration: new BoxDecoration(
    color: Colors.white,
    shape: BoxShape.circle,
  ),
  );
  }
}
