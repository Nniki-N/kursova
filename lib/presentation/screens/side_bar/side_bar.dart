import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kursova/presentation/blocs/locations_bloc/locations_bloc.dart';
import 'package:kursova/presentation/blocs/locations_bloc/locations_state.dart';
import 'package:kursova/presentation/blocs/route_bloc/route_bloc.dart';
import 'package:kursova/presentation/blocs/route_bloc/route_state.dart';
import 'package:kursova/presentation/cubits/side_bar_menu_visibility_cubit.dart';
import 'package:kursova/presentation/screens/side_bar/choose_locations_side_bar_content.dart';
import 'package:kursova/presentation/screens/side_bar/loading_side_bar_content.dart';
import 'package:kursova/presentation/screens/side_bar/route_details_side_bar_content.dart';
import 'package:kursova/presentation/screens/side_bar/widgets/rect_with_inner_radius.dart';
import 'package:kursova/presentation/widgets/custom_buttons/custom_square_button_with_icon.dart';
import 'package:kursova/resources/app_colors.dart';
import 'package:kursova/resources/app_ui_constants.dart';
import 'package:kursova/resources/graphics/resources.dart';

class SideBar extends StatefulWidget {
  final double sidebarWidth;
  final double sidebarHeight;

  const SideBar({
    super.key,
    required this.sidebarWidth,
    required this.sidebarHeight,
  });

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin {
  // bool displayHiddenButton = false;
  bool displayHiddenButton = true;

  @override
  Widget build(BuildContext context) {
    const double customInnerBorderRectSize = 30;
    const double hiddenSideBarButtonPaddings = 15;

    return BlocBuilder<SideBarMenuVisibilityCubit, SideBarMenuVisibility>(
      builder: (context, sideBarMenuState) {
        return SizedBox(
          width: widget.sidebarWidth,
          height: widget.sidebarHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: AppUIConstants.sideBarMenuPaddings -
                    hiddenSideBarButtonPaddings,
                child: Opacity(
                  opacity: displayHiddenButton ? 1 : 0,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(
                          hiddenSideBarButtonPaddings,
                        ),
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
                            onTap: () {
                              BlocProvider.of<SideBarMenuVisibilityCubit>(
                                      context)
                                  .toogleSideBarMenuVisibility();
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: -customInnerBorderRectSize + 1,
                        left: 0,
                        child: RectWithOneInnerRadius(
                          size: customInnerBorderRectSize,
                          radius: customInnerBorderRectSize,
                          color: AppColors.backgroundColor,
                          shadowColor:
                              AppColors.mainShadowColor.withOpacity(0.3),
                          topRight: true,
                        ),
                      ),
                      Positioned(
                        bottom: -customInnerBorderRectSize + 1,
                        left: 0,
                        child: RectWithOneInnerRadius(
                          size: customInnerBorderRectSize,
                          radius: customInnerBorderRectSize,
                          color: AppColors.backgroundColor,
                          shadowColor:
                              AppColors.mainShadowColor.withOpacity(0.3),
                          bottomRight: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: sideBarMenuState == SideBarMenuVisibility.visible
                    ? 0
                    : -widget.sidebarWidth,
                right: sideBarMenuState == SideBarMenuVisibility.visible
                    ? 0
                    : widget.sidebarWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mainDarkColor.withOpacity(0.25),
                        blurRadius: 50,
                        spreadRadius: 3,
                      )
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppUIConstants.sideBarMenuPaddings,
                  ),
                  child: BlocBuilder<LocationsBloc, LocationsState>(
                    builder: (context, locationsState) {
                      return BlocBuilder<RouteBloc, RouteState>(
                        builder: (context, routeState) {
                          if (routeState is RouteLoaded) {
                            return RouteDetailsSideBarContent(
                              padding: AppUIConstants.sideBarMenuPaddings,
                            );
                          }
                          if (routeState is RouteLoading) {
                            return LoadingSideBarContent(
                              padding: AppUIConstants.sideBarMenuPaddings,
                            );
                          } else {
                            return ChooseLocationsSideBarContent(
                              padding: AppUIConstants.sideBarMenuPaddings,
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: -customInnerBorderRectSize + 1,
                left: sideBarMenuState == SideBarMenuVisibility.visible
                    ? 0
                    : -customInnerBorderRectSize,
                child: RectWithOneInnerRadius(
                  size: customInnerBorderRectSize,
                  radius: customInnerBorderRectSize,
                  color: AppColors.backgroundColor,
                  shadowColor: AppColors.mainShadowColor.withOpacity(0.3),
                  topRight: true,
                ),
              ),
              Positioned(
                bottom: -customInnerBorderRectSize + 1,
                left: sideBarMenuState == SideBarMenuVisibility.visible
                    ? 0
                    : -customInnerBorderRectSize,
                child: RectWithOneInnerRadius(
                  size: customInnerBorderRectSize,
                  radius: customInnerBorderRectSize,
                  color: AppColors.backgroundColor,
                  shadowColor: AppColors.mainShadowColor.withOpacity(0.3),
                  bottomRight: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
