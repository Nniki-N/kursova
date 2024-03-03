import 'package:flutter/material.dart';
import 'package:kursova/core/utils/image_asset_path_formater.dart';
import 'package:kursova/presentation/widgets/custom_buttons/custom_square_button_with_icon.dart';
import 'package:kursova/resources/app_colors.dart';
import 'package:kursova/resources/app_typography.dart';
import 'package:kursova/resources/app_ui_constants.dart';
import 'package:kursova/resources/graphics/resources.dart';

// Right side has higher priority than left side
// Bottom side has higher priority than top side

// ignore: must_be_immutable
class CustomPositionedHelpPopUp extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final double borderWidth;
  final double closeIconSize;
  final Color borderColor;
  final Color backgroundColor;
  final double padding;
  final String helpTitle;
  final String helpText;
  final bool helpPointerTopRight;
  final bool helpPointerBottomLeft;
  final bool helpPointerBottomRight;

  CustomPositionedHelpPopUp({
    super.key,
    this.width = 450,
    this.height = 500,
    this.borderRadius = AppUIConstants.commonBorderRadius,
    this.borderWidth = AppUIConstants.commonBorderWidth,
    this.closeIconSize = 18,
    this.borderColor = AppColors.buttonBorderColor,
    this.backgroundColor = AppColors.popupBackgroundColor,
    this.padding = 20,
    required this.helpTitle,
    required this.helpText,
    this.helpPointerTopRight = false,
    this.helpPointerBottomLeft = false,
    this.helpPointerBottomRight = false,
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
          right: helpPointerTopRight || helpPointerBottomRight
              ? pointerPostionX
              : null,
          left: !(helpPointerTopRight || helpPointerBottomRight)
              ? pointerPostionX
              : null,
          bottom: helpPointerBottomLeft || helpPointerBottomRight
              ? pointerPostionY
              : null,
          top: !(helpPointerBottomLeft || helpPointerBottomRight)
              ? pointerPostionY
              : null,
          child: RotatedBox(
            quarterTurns:
                helpPointerBottomLeft || helpPointerBottomRight ? 2 : 0,
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
            child: HelpPopUpContentColumn(
              helpTitle: helpTitle,
              helpText: helpText,
            ),
          ),
        ),
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
              final RenderBox renderBox =
                  globalKey.currentContext!.findRenderObject() as RenderBox;
              print('renderBox.size.height ${renderBox.size.height}');
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}

class HelpPopUpContentColumn extends StatelessWidget {
  const HelpPopUpContentColumn({
    super.key,
    required this.helpTitle,
    required this.helpText,
  });

  final String helpTitle;
  final String helpText;

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
            helpTitle,
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
            helpText,
            maxLines: 20,
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
