
import 'package:flutter/material.dart';
import 'package:kursova/resources/app_ui_constants.dart';

class SideBarHorizontalPaddingsContainer extends StatelessWidget {
  const SideBarHorizontalPaddingsContainer({
    super.key,
    required this.child,
    this.leftPadding = AppUIConstants.sideBarMenuPaddings,
    this.rightPadding = AppUIConstants.sideBarMenuPaddings,
  });

  final Widget child;
  final double leftPadding;
  final double rightPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
      ),
      child: child,
    );
  }
}
