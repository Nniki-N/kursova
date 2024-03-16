import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kursova/presentation/cubits/side_bar_menu_visibility_cubit.dart';
import 'package:kursova/presentation/widgets/custom_buttons/custom_square_button_with_icon.dart';
import 'package:kursova/presentation/widgets/custom_buttons/info_button.dart';
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
        // A header title with info button
        Flexible(
          child: RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: headerTitle,
                  style: AppTypography.h1Style,
                ),
                if (headerInfoTitle != null && headerInfoText != null)
                  const WidgetSpan(
                    child: SizedBox(width: 10),
                  ),
                if (headerInfoTitle != null && headerInfoText != null)
                  WidgetSpan(
                    child: InfoButton(
                      infoIconSize: infoIconSize,
                      infoTitle: headerInfoTitle!,
                      infoText: headerInfoText!,
                      fromChildLeftTopCornerMoveXDisctance: 21,
                      fromChildLeftTopCornerMoveYDisctance: 35,
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 10),

        // Hides side bar
        CustomSquareButtonWithIcon(
          key: const ValueKey('side_bar_hide_button'),
          iconSize: 16,
          iconPath: Svgs.smallArrowLeftIcon,
          onTap: () {
            final hasTheCubit = context.findAncestorWidgetOfExactType<
                BlocProvider<SideBarMenuVisibilityCubit>>();

            if (hasTheCubit != null) {
              BlocProvider.of<SideBarMenuVisibilityCubit>(context)
                  .toogleSideBarMenuVisibility();
            } else {
              Scaffold.of(context).closeDrawer();
            }
          },
        ),
      ],
    );
  }
}
