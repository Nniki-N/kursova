import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kursova/presentation/screens/side_bar/widgets/side_bar_header.dart';
import 'package:kursova/presentation/screens/side_bar/widgets/side_bar_horizontal_paddings_container.dart';
import 'package:kursova/resources/app_colors.dart';
import 'package:kursova/resources/app_typography.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingSideBarContent extends StatelessWidget {
  final textFieldController = TextEditingController();
  final double padding;

  LoadingSideBarContent({
    super.key,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    const double loadingAnimationSize = 71;
    const double loadingAnimationBorderWidth = 3;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SideBarHorizontalPaddingsContainer(
          leftPadding: padding,
          rightPadding: padding,
          child: SideBarHeader(
            headerTitle: 'route'.tr(context: context),
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    LoadingAnimationWidget.threeRotatingDots(
                      color: AppColors.mainDarkColor,
                      size: loadingAnimationSize,
                    ),
                    Positioned(
                      top: loadingAnimationBorderWidth,
                      left: loadingAnimationBorderWidth,
                      child: LoadingAnimationWidget.threeRotatingDots(
                        color: AppColors.mainColor,
                        size: loadingAnimationSize -
                            loadingAnimationBorderWidth * 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'creatingRoute'.tr(context: context),
                  style: AppTypography.h3Style,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
