
import 'package:flutter/material.dart';

class SideBarHorizontalPaddingsContainer extends StatelessWidget {
  const SideBarHorizontalPaddingsContainer({
    super.key,
    required this.child,
    this.leftPadding = 30,
    this.rightPadding = 30,
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
