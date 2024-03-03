import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kursova/core/utils/image_asset_path_formater.dart';
import 'package:kursova/presentation/cubits/side_bar_menu_visibility_cubit.dart';
import 'package:kursova/presentation/widgets/custom_buttons/custom_square_button_with_icon.dart';
import 'package:kursova/presentation/widgets/custom_popups/custom_positioned_help_popup_wrapper.dart';
import 'package:kursova/resources/app_typography.dart';
import 'package:kursova/resources/graphics/resources.dart';

class SideBarHeader extends StatelessWidget {
  final String headerTitle;
  final String? headerInfoTitle;
  final String? headerInfoText;

  const SideBarHeader({
    super.key,
    required this.headerTitle,
    this.headerInfoTitle,
    this.headerInfoText,
  });

  @override
  Widget build(BuildContext context) {
    const double infoIconSize = 20;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          headerTitle,
          style: AppTypography.h1Style,
        ),
        const SizedBox(width: 10),
        if (headerInfoTitle != null && headerInfoText != null)
          CustomPositionedHelpPopUpWrapper(
            fromChildLeftTopCornerMoveXDisctance: 21,
            fromChildLeftTopCornerMoveYDisctance: 35,
            helpTitle: headerInfoTitle!,
            helpText: headerInfoText!,
            child: SizedBox(
              width: infoIconSize,
              height: infoIconSize,
              child: SvgPicture.asset(
                ImageAssetPathFormater.formatImageAssetPath(
                  imageAssetPath: Svgs.infoIcon,
                ),
              ),
            ),
          ),
        if (headerInfoTitle != null && headerInfoText != null)
          const SizedBox(width: 10),
        const Spacer(),
        CustomSquareButtonWithIcon(
          iconSize: 16,
          iconPath: Svgs.smallArrowLeftIcon,
          onTap: () {
            BlocProvider.of<SideBarMenuVisibilityCubit>(context)
                .toogleSideBarMenuVisibility();
          },
        ),
      ],
    );
  }
}
