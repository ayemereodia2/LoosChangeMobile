import 'package:flutter/material.dart';
import 'package:loosechange/utilities/constants.dart';

BoxDecoration bodyGradientColor() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topRight,
        colors: [kGradientStart, kGradientEnd]
      ),
    );
  }