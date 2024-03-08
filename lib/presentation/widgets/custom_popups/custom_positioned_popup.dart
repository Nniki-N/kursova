import 'package:flutter/material.dart';
import 'package:kursova/core/utils/image_asset_path_formater.dart';
import 'package:kursova/presentation/widgets/custom_buttons/custom_square_button_with_icon.dart';
import 'package:kursova/resources/app_colors.dart';
import 'package:kursova/resources/app_typography.dart';
import 'package:kursova/resources/app_ui_constants.dart';
import 'package:kursova/resources/graphics/resources.dart';

/// A popup that will be shown as positioned popup.
/// 
/// It has a mandatory pointer that is attached to bottom or top of the popup. By default the pointer is on top left side.
/// 
/// Postion of the pointer can be changed by setting [pointerTopRight] or [pointerBottomLeft] or [pointerBottomRight] to true.
/// By selecting several sides for pointer, right side will have higher priority than left side and bottom side will have higher priority than top side.
class CustomPositionedPopUp extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final double borderWidth;
  final double closeIconSize;
  final Color borderColor;
  final Color backgroundColor;
  final double padding;
  final String title;
  final String text;
  final bool pointerTopRight;
  final bool pointerBottomLeft;
  final bool pointerBottomRight;

  CustomPositionedPopUp({
    super.key,
    this.width = 450,
    this.height = 500,
    this.borderRadius = AppUIConstants.commonBorderRadius,
    this.borderWidth = AppUIConstants.commonBorderWidth,
    this.closeIconSize = 18,
    this.borderColor = AppColors.buttonBorderColor,
    this.backgroundColor = AppColors.popupBackgroundColor,
    this.padding = 20,
    required this.title,
    required this.text,
    this.pointerTopRight = false,
    this.pointerBottomLeft = false,
    this.pointerBottomRight = false,
  });

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    const double triangleHeight = 12;
    const double triangleWidth = 28;

    const double pointerPostionX = 18;
    const double pointerPostionY = -triangleHeight + 1;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: pointerTopRight || pointerBottomRight
              ? pointerPostionX
              : null,
          left: !(pointerTopRight || pointerBottomRight)
              ? pointerPostionX
              : null,
          bottom: pointerBottomLeft || pointerBottomRight
              ? pointerPostionY
              : null,
          top: !(pointerBottomLeft || pointerBottomRight)
              ? pointerPostionY
              : null,
          child: RotatedBox(
            quarterTurns:
                pointerBottomLeft || pointerBottomRight ? 2 : 0,
            child: CustomPaint(
              painter: TriangleWithTopRaiusPainter(),
              child: const SizedBox(
                height: triangleHeight,
                width: triangleWidth,
              ),
            ),
          ),
        ),
        Container(
          key: globalKey,
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(
              borderRadius,
            ),
            border: Border.all(
              width: borderWidth,
              color: borderColor,
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: padding,
              right: padding + closeIconSize + 10,
              top: padding,
              bottom: padding,
            ),
            child: CustomPositionedPopUpContentColumn(
              title: title,
              text: text,
            ),
          ),
        ),

        // Closes pop up.
        Positioned(
          top: padding,
          right: padding,
          child: CustomSquareButtonWithIcon(
            size: closeIconSize,
            iconSize: 8,
            iconColor: AppColors.whitenColor,
            iconPath: ImageAssetPathFormater.formatImageAssetPath(
              imageAssetPath: Svgs.closeIcon,
            ),
            backgroundColor: AppColors.hoveredSmallButtonBackgroundColor,
            borderColor: AppColors.hoveredSmallButtonBackgroundColor,
            borderWidth: 0,
            borderRadius: 4,
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}

class CustomPositionedPopUpContentColumn extends StatelessWidget {
  const CustomPositionedPopUpContentColumn({
    super.key,
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: TextDirection.ltr,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTextStyle(
          style: AppTypography.h3Style.copyWith(
            fontWeight: FontWeight.w600,
          ),
          child: Text(
            title,
            maxLines: 2,
            softWrap: true,
            textDirection: TextDirection.ltr,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 15),
        DefaultTextStyle(
          style: AppTypography.mainTextStyle,
          child: Text(
            text,
            maxLines: 50,
            softWrap: true,
            textDirection: TextDirection.ltr,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class TriangleWithTopRaiusPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final double topRadious;

  TriangleWithTopRaiusPainter({
    this.color = AppColors.popupBackgroundColor,
    this.borderColor = AppColors.popupBorderColor,
    this.borderWidth = 1.5,
    this.topRadious = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintBorder = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final Paint paint = Paint()..color = color;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
    canvas.drawPath(getTrianglePath(size.width, size.height), paintBorder);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2 - topRadious, 0 + topRadious)
      ..quadraticBezierTo(x / 2, 0, x / 2 + topRadious, 0 + topRadious)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TriangleWithTopRaiusPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth;
  }
}
