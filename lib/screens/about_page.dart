import 'package:flutter/material.dart';
import 'package:loosechange/components/appbar_widget.dart';
import 'package:loosechange/components/reusable_bg.dart';
import 'package:loosechange/components/divider.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

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
                appbarTextTwo: 'About',
                appbarFontSizeTwo: 20.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Divider(
                color: Colors.white,
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
                        'About LooseChange',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Your access to the use of this service is conditioned on your acceptance of and compliance with these terms. These terms apply to all visitors users and others who access or use this service',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                    BuildDivider(
                      dividerTop: 330.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'What is the platform about?',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'LooseChange is an e-wallet application that will be used as a pittance collection platform. Research shows that a high percentage of individuals who patronize supermarkets, pharmacies,restaurants,petty stores e.t.c where they buy goods and services find it difficulty in accessing accurate pittance from vendors.',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                    BuildDivider(
                      dividerTop: 330.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'LooseChange Solves a Huge Problem',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'The LooseChange e-wallet application is here to solve that problem by creating a saving platform that will enable proper accountability and transparency for all transactions.',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                    BuildDivider(
                      dividerTop: 330.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'True Saving is now possible',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Your change as a customer can now be saved in your e-wallet account. Which can be withdrawn whenever you deem fit or used to purchase needed items from the stores.',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                    BuildDivider(
                      dividerTop: 330.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Our Objectives',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListTile(
                        leading: MyBullet(),
                        title: Text('To promote a cashless economy through the application', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListTile(
                        leading: MyBullet(),
                        title: Text('To create a seamless transaction experience for both customers and vendors', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListTile(
                        leading: MyBullet(),
                        title: Text('To create a user friendly application for the collection of pittance', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListTile(
                        leading: MyBullet(),
                        title: Text('To create a saving habit for individuals who use the application', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListTile(
                        leading: MyBullet(),
                        title: Text('To assist individuals have access to accurate pittance', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListTile(
                        leading: MyBullet(),
                        title: Text('To assist individuals have access to accurate pittance', style: TextStyle(color: Colors.white)),
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
