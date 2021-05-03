import 'package:flutter/material.dart';
import 'package:loosechange/components/custom_positioning.dart';

class BuildDivider extends StatelessWidget {
  final double dividerTop;

  BuildDivider({@required this.dividerTop});
  @override
  Widget build(BuildContext context) {
    return new CustomPositioning(
      customTop: dividerTop,
      customChild: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Divider(
          color: Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}
