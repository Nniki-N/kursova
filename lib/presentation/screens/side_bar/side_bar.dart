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
import 'package:kursova/presentation/screens/side_bar/widgets/side_bar_open_button.dart';
import 'package:kursova/resources/app_colors.dart';
import 'package:kursova/resources/app_ui_constants.dart';

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
  bool displayHiddenButton = true;

  @override
  Widget build(BuildContext context) {
    const double customInnerBorderRectSize = 30;
    const double openSideBarButtonPaddings = 15;

    final bool fullHeightSidebar = MediaQuery.of(context).size.height <
        AppUIConstants.maximalHeightToShowFullHeightSideBar;

    return BlocBuilder<SideBarMenuVisibilityCubit, SideBarMenuVisibility>(
      builder: (context, sideBarMenuState) {
        return SizedBox(
          width: widget.sidebarWidth,
          height: fullHeightSidebar
              ? MediaQuery.of(context).size.height
              : widget.sidebarHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // A hidden button that opens side bar
              Positioned(
                top: AppUIConstants.sideBarMenuPaddings -
                    openSideBarButtonPaddings,
                child: SideBarOpenButton(
                  onTap: () {
                    BlocProvider.of<SideBarMenuVisibilityCubit>(context)
                        .toogleSideBarMenuVisibility();
                  },
                ),
              ),

              // A side bar
              Positioned(
                key: const ValueKey('side_bar_positioned_widget'),
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

              // A top side bar rect with inner radius
              if (!fullHeightSidebar)
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

              // A bottom side bar rect with inner radius
              if (!fullHeightSidebar)
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
