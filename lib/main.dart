import 'package:flutter/material.dart';
// import 'package:loosechange/utilities/constants.dart';
import 'package:loosechange/screens/homepage.dart';
import 'package:loosechange/screens/profile_page.dart';
import 'package:loosechange/screens/account_page.dart';
import 'package:loosechange/screens/support_page.dart';
import 'package:loosechange/screens/about_page.dart';
import 'package:loosechange/screens/card_page.dart';
import 'package:loosechange/screens/bank_transfer_page.dart';
import 'package:loosechange/screens/login_page.dart';
import 'package:loosechange/screens/signup_page.dart';
import 'package:loosechange/screens/loader_page.dart';
import 'package:loosechange/screens/transfer_page.dart';
import 'package:loosechange/screens/edit_account_page.dart';
import 'package:loosechange/screens/withdraw_page.dart';
import 'package:loosechange/screens/withdrawals_page.dart';
import 'package:loosechange/screens/transaction_page.dart';
import 'package:loosechange/screens/qr_page.dart';
import 'package:loosechange/screens/verify_phone_page.dart';
import 'package:loosechange/screens/verify_code_page.dart';
import 'package:loosechange/screens/check_code_page.dart';
import 'package:loosechange/screens/loader_page_two.dart';
import 'package:loosechange/screens/change_pin.dart';
import 'package:loosechange/screens/forgot_password_page.dart';
import 'dart:async';
import 'package:flutter/services.dart';

Future<void> main() async {
  runApp(LooseChange());
}

class LooseChange extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(),
      // home: HomePage(),
      initialRoute: '/',
      routes: {
        '/': (context) => LoaderPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/verify-phone': (context) => VerifyPhonePage(),
        '/verify-code': (context) => VerifyCodePage(),
        '/check-code': (context) => CheckCodePage(),
        '/change-pin': (context) => ChangePin(),
        '/loader-page-two': (context) => LoaderPageTwo(),
        '/forgot-password': (context) => ForgotPasswordPage(),
        '/homepage': (context) => HomePage(),
        '/transaction': (context) => TransactionPage(),
        '/transfer': (context) => TransferPage(),
        '/qr': (context) => QrPage(),
        '/profile': (context) => ProfilePage(),
        '/accounts': (context) => AccountPage(),
        '/edit-account': (context) => EditAccountPage(),
        '/withdraw': (context) => WithdrawPage(),
        '/withdrawals': (context) => WithdrawalsPage(),
        '/support': (context) => SupportPage(),
        '/about': (context) => AboutPage(),
        '/cards': (context) => CardPage(),
        '/bank-transfer': (context) => BankTransferPage(),
      },
    );
  }
}
