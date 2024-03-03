import 'package:flutter/material.dart';

/// Corner priority is [topRight] -> [bottomRight] -> [bottomLeft] -> [topLeft]
/// If no corner is selected, [topRight] is selected by default
class RectWithOneInnerRadius extends StatelessWidget {
  final double size;
  final double radius;
  final bool topRight;
  final bool bottomRight;
  final bool bottomLeft;
  final bool topLeft;
  final Color color;
  final Color shadowColor;

  const RectWithOneInnerRadius({
    super.key,
    required this.size,
    required this.radius,
    this.topRight = false,
    this.bottomRight = false,
    this.bottomLeft = false,
    this.topLeft = false,
    required this.color,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final int quarterTurns;

    if (topRight) {
      quarterTurns = 3;
    } else if (bottomRight) {
      quarterTurns = 0;
    } else if (bottomLeft) {
      quarterTurns = 1;
    } else if (topLeft) {
      quarterTurns = 2;
    } else {
      quarterTurns = 3;
    }

    return RotatedBox(
      quarterTurns: quarterTurns,
      child: ClipPath(
        clipper: CustomInnerRadiusClipPath(
          radius: radius,
        ),
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: color,
            // boxShadow: [
            //   BoxShadow(
            //     color: shadowColor,
            //     blurRadius: 50,
            //     spreadRadius: 3,
            //   )
            // ],
          ),
        ),
      ),
    );
  }
}

class CustomInnerRadiusClipPath extends CustomClipper<Path> {
  final double radius;

  const CustomInnerRadiusClipPath({
    required this.radius,
  });

  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(size.width, 0)
      ..lineTo(
        size.width,
        size.height - radius,
      )
      ..arcToPoint(
        Offset(
          size.width - radius,
          size.height,
        ),
        radius: Radius.circular(radius),
        clockwise: false,
      )
      ..lineTo(0, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
