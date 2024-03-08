import 'package:flutter/material.dart';
import 'package:kursova/presentation/screens/side_bar/widgets/rect_with_inner_radius.dart';
import 'package:kursova/presentation/widgets/custom_buttons/custom_square_button_with_icon.dart';
import 'package:kursova/resources/app_colors.dart';
import 'package:kursova/resources/graphics/resources.dart';

class SideBarOpenButton extends StatelessWidget {
  final void Function() onTap;
  final double customInnerBorderRectSize;
  final double drawerButtonPaddings;

  const SideBarOpenButton({
    super.key,
    required this.onTap,
    this.customInnerBorderRectSize = 18,
    this.drawerButtonPaddings = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(drawerButtonPaddings),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.mainDarkColor.withOpacity(0.25),
                blurRadius: 50,
                spreadRadius: 3,
              )
            ],
          ),
          child: RotatedBox(
            quarterTurns: 2,
            child: CustomSquareButtonWithIcon(
              iconSize: 16,
              iconPath: Svgs.smallArrowLeftIcon,
              onTap: onTap,
            ),
          ),
        ),

        // A top button rect with inner radius
        Positioned(
          top: -customInnerBorderRectSize + 1,
          left: 0,
          child: RectWithOneInnerRadius(
            size: customInnerBorderRectSize,
            radius: customInnerBorderRectSize,
            color: AppColors.backgroundColor,
            shadowColor: AppColors.mainShadowColor.withOpacity(0.3),
            topRight: true,
          ),
        ),

        // A bottom button rect with inner radius
        Positioned(
          bottom: -customInnerBorderRectSize + 1,
          left: 0,
          child: RectWithOneInnerRadius(
            size: customInnerBorderRectSize,
            radius: customInnerBorderRectSize,
            color: AppColors.backgroundColor,
            shadowColor: AppColors.mainShadowColor.withOpacity(0.3),
            bottomRight: true,
          ),
        ),
      ],
    );
  }
}
