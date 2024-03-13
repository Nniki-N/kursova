import 'package:easy_localization/easy_localization.dart' as easy_localization;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kursova/core/app_constants.dart';
import 'package:kursova/core/utils/image_asset_path_formater.dart';
import 'package:kursova/core/utils/widget_measure_util.dart';
import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/presentation/blocs/locations_bloc/locations_bloc.dart';
import 'package:kursova/presentation/blocs/locations_bloc/locations_event.dart';
import 'package:kursova/presentation/blocs/locations_bloc/locations_state.dart';
import 'package:kursova/presentation/blocs/map_markers_bloc/map_markers_bloc.dart';
import 'package:kursova/presentation/blocs/map_markers_bloc/map_markers_event.dart';
import 'package:kursova/presentation/blocs/permissions_bloc/permission_bloc.dart';
import 'package:kursova/presentation/blocs/permissions_bloc/permission_state.dart';
import 'package:kursova/presentation/blocs/route_bloc/Route_event.dart';
import 'package:kursova/presentation/blocs/route_bloc/route_bloc.dart';
import 'package:kursova/presentation/blocs/route_bloc/route_state.dart';
import 'package:kursova/presentation/screens/side_bar/widgets/side_bar_header.dart';
import 'package:kursova/presentation/screens/side_bar/widgets/side_bar_horizontal_paddings_container.dart';
import 'package:kursova/presentation/screens/side_bar/widgets/side_bar_option_with_switch.dart';
import 'package:kursova/presentation/widgets/custom_buttons/custom_icon_button.dart';
import 'package:kursova/presentation/widgets/custom_buttons/custom_main_button.dart';
import 'package:kursova/presentation/widgets/custom_buttons/custom_square_button_with_icon.dart';
import 'package:kursova/presentation/widgets/custom_fields/custom_search_field.dart';
import 'package:kursova/presentation/widgets/custom_popups/check_and_show_no_internet_connection_pop_up.dart';
import 'package:kursova/resources/app_colors.dart';
import 'package:kursova/resources/app_typography.dart';
import 'package:kursova/resources/graphics/resources.dart';

class ChooseLocationsSideBarContent extends StatelessWidget {
  final textFieldController = TextEditingController();
  final double padding;

  ChooseLocationsSideBarContent({
    super.key,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // A side bar is fully scrollable to fit locations
    if (MediaQuery.of(context).size.height < 630) {
      return ListView(
        padding: EdgeInsets.symmetric(vertical: padding),
        shrinkWrap: true,
        children: _contentListOfWidgets(
          context: context,
          isLocationsListScrollable: false,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _contentListOfWidgets(
          context: context,
          isLocationsListScrollable: true,
        ),
      ),
    );
  }

  // A side bar content
  List<Widget> _contentListOfWidgets({
    required BuildContext context,
    required bool isLocationsListScrollable,
  }) {
    return [
      SideBarHorizontalPaddingsContainer(
        leftPadding: padding,
        rightPadding: padding,
        child: SideBarHeader(
          headerTitle: 'chooseLocations'.tr(context: context),
          headerInfoTitle: 'howToUseThisService'.tr(context: context),
          headerInfoText: 'howToUseThisServiceText'.tr(context: context),
        ),
      ),
      const SizedBox(height: 25),
      SideBarHorizontalPaddingsContainer(
        leftPadding: padding,
        rightPadding: padding,
        child: CustomSearchField(
          controller: textFieldController,
          hintText: 'search'.tr(context: context),
          buttonIconPath: Svgs.addIcon,
          onTap: () {
            if (checkAndShowNoInternetConnectionPopUp(context)) {
              return;
            }

            final LocationsState locationsState =
                BlocProvider.of<LocationsBloc>(context).state;

            if (locationsState is LocationsAddingLocation) {
              return;
            }

            final String fieldText = textFieldController.text;

            if (fieldText.trim().isNotEmpty) {
              BlocProvider.of<LocationsBloc>(context).add(
                LocationsAddLocationByAddressRequested(
                  address: fieldText,
                  locationDataLang: context.locale.languageCode,
                ),
              );

              textFieldController.clear();
            }
          },
        ),
      ),
      const SizedBox(height: 15),

      // An add current location buttion is shown only if the location service is anabled
      BlocBuilder<PermissionBloc, PermissionState>(
        builder: (context, permissionState) {
          return !permissionState.locationServiceIsEnabled
              ? SizedBox.fromSize()
              : SideBarHorizontalPaddingsContainer(
                  leftPadding: padding,
                  rightPadding: padding,
                  child: CustomMainButton(
                    onTap: () {
                      if (checkAndShowNoInternetConnectionPopUp(context)) {
                        return;
                      }

                      final LocationsState locationsState =
                          BlocProvider.of<LocationsBloc>(context).state;

                      if (locationsState is LocationsAddingLocation) {
                        return;
                      }

                      BlocProvider.of<LocationsBloc>(context).add(
                        LocationsAddCurrentUserLocationRequested(
                          locationDataLang: context.locale.languageCode,
                        ),
                      );
                    },
                    text: 'myCurrentLocation'.tr(context: context),
                    height: 44,
                    iconPath: Svgs.locationIcon,
                    backgroundColor: Colors.transparent,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                );
        },
      ),
      BlocBuilder<PermissionBloc, PermissionState>(
        builder: (context, permissionState) {
          return !permissionState.locationServiceIsEnabled
              ? SizedBox.fromSize()
              : const SizedBox(height: 30);
        },
      ),

      SideBarHorizontalPaddingsContainer(
        leftPadding: padding,
        rightPadding: padding,
        child: BlocBuilder<LocationsBloc, LocationsState>(
          builder: (context, locationsState) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'locations'.tr(context: context),
                  style: AppTypography.mainTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${locationsState.locations.length} / ${AppConstants.locationsLimit}',
                  style: AppTypography.mainTextStyle.copyWith(
                    color: AppColors.darkGrayTextColor,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      const SizedBox(height: 20),
      BlocBuilder<RouteBloc, RouteState>(
        builder: (context, routeState) {
          return BlocBuilder<LocationsBloc, LocationsState>(
            builder: (context, locationsState) {
              if (isLocationsListScrollable) {
                return Expanded(
                  child: LocationsReorderableListView(
                    padding: padding,
                    locations: locationsState.locations,
                    isAddingNewLocation:
                        locationsState is LocationsAddingLocation,
                    showStart: routeState.withStartPoint,
                    showEnd: routeState.withEndPoint,
                    isScrollable: isLocationsListScrollable,
                  ),
                );
              } else {
                return LocationsReorderableListView(
                  padding: padding,
                  locations: locationsState.locations,
                  isAddingNewLocation:
                      locationsState is LocationsAddingLocation,
                  showStart: routeState.withStartPoint,
                  showEnd: routeState.withEndPoint,
                  isScrollable: isLocationsListScrollable,
                );
              }
            },
          );
        },
      ),
      const SizedBox(height: 25),
      SideBarHorizontalPaddingsContainer(
        leftPadding: padding,
        rightPadding: padding,
        child: BlocBuilder<RouteBloc, RouteState>(
          builder: (context, routeState) {
            return AdvancedOptions(
              showOptions: routeState.cycledRoute ||
                  routeState.withEndPoint ||
                  routeState.withStartPoint,
            );
          },
        ),
      ),
      const SizedBox(height: 15),
      SideBarHorizontalPaddingsContainer(
        leftPadding: padding,
        rightPadding: padding,
        child: CustomMainButton(
          onTap: () {
            if (checkAndShowNoInternetConnectionPopUp(context)) {
              return;
            }

            final List<Location> locations =
                BlocProvider.of<LocationsBloc>(context).state.locations;

            BlocProvider.of<RouteBloc>(context).add(
              RouteFindRouteRequested(locations: locations),
            );
          },
          text: 'findRoute'.tr(context: context),
        ),
      ),
      const SizedBox(height: 15),
      SideBarHorizontalPaddingsContainer(
        leftPadding: padding,
        rightPadding: padding,
        child: CustomMainButton(
          onTap: () {
            BlocProvider.of<LocationsBloc>(context).add(
              const LocationsClearLocationsRequested(),
            );

            BlocProvider.of<MapMarkersBloc>(context).add(
              const MapMarkersClearMarkersRequested(),
            );

            BlocProvider.of<RouteBloc>(context).add(
              const RouteConfigureRouteRequested(
                cycledRoute: false,
                withEndPoint: false,
                withStartPoint: false,
              ),
            );
          },
          text: 'clearAllLocations'.tr(context: context),
          backgroundColor: Colors.transparent,
        ),
      ),
    ];
  }
}

class LocationsReorderableListView extends StatefulWidget {
  final double padding;
  final List<Location> locations;
  final bool isAddingNewLocation;
  final bool showStart;
  final bool showEnd;
  final double spaceBetweenItems;
  final bool isScrollable;

  const LocationsReorderableListView({
    super.key,
    required this.padding,
    required this.locations,
    required this.isAddingNewLocation,
    required this.showStart,
    required this.showEnd,
    this.spaceBetweenItems = 24,
    required this.isScrollable,
  });

  @override
  State<LocationsReorderableListView> createState() =>
      _LocationsReorderableListViewState();
}

class _LocationsReorderableListViewState
    extends State<LocationsReorderableListView> {
  List<Location> locations = [];

  @override
  void initState() {
    locations = List.from(widget.locations);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LocationsReorderableListView oldWidget) {
    locations = List.from(widget.locations);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      physics:
          !widget.isScrollable ? const NeverScrollableScrollPhysics() : null,
      shrinkWrap: !widget.isScrollable,
      buildDefaultDragHandles: false,
      padding: EdgeInsets.only(
        right: widget.padding,
        left: widget.padding,
      ),
      itemBuilder: (context, index) {
        // Shows that location is loading
        if (index == locations.length && widget.isAddingNewLocation) {
          final height = WidgetMeasureUtil.measureWidget(Text(
            '',
            textDirection: TextDirection.ltr,
            style: AppTypography.mainTextStyle,
          )).height;

          return Row(
            key: const ValueKey('loading_indicator'),
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: index == 0 ? 2 : widget.spaceBetweenItems + 2,
                ),
                width: 130,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.lightGrayTextColor.withOpacity(0.15),
                ),
              ),
            ],
          );
        }

        return ReorderableDragStartListener(
          key: ValueKey(locations[index].uid),
          index: index,
          child: SideBarLocationsListItem(
            location: locations[index],
            isLast: index == locations.length - 1,
            isFirst: index == 0,
            showStart: widget.showStart,
            showEnd: widget.showEnd,
            itemVerticalPaddings: widget.spaceBetweenItems / 2,
          ),
        );
      },
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) => Material(
            color: AppColors.backgroundColor,
            child: child,
          ),
          child: child,
        );
      },
      itemCount:
          widget.isAddingNewLocation ? locations.length + 1 : locations.length,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }

          final Location location = locations.removeAt(oldIndex);
          locations.insert(newIndex, location);
        });

        BlocProvider.of<LocationsBloc>(context).add(
          LocationsMoveOneLocationInOrderRequested(
            oldIndex: oldIndex,
            newIndex: newIndex,
          ),
        );
      },
    );
  }
}

class SideBarLocationsListItem extends StatelessWidget {
  final Location location;
  final bool isLast;
  final bool isFirst;
  final bool showStart;
  final bool showEnd;
  final double itemVerticalPaddings;

  const SideBarLocationsListItem({
    super.key,
    required this.location,
    required this.isLast,
    required this.isFirst,
    required this.showStart,
    required this.showEnd,
    this.itemVerticalPaddings = 12,
  });

  @override
  Widget build(BuildContext context) {
    String subText = '';

    if (showStart && isFirst) {
      subText = 'startPoint'.tr(context: context);
    }

    if (showEnd && isLast) {
      subText = 'endPoint'.tr(context: context);
    }

    if (((showStart && isFirst) || (showEnd && isLast)) &&
        location.locationType == LocationType.currentLocation) {
      subText = 'currentLocation'.tr(context: context, args: [subText]);
    } else if (location.locationType == LocationType.currentLocation) {
      subText = 'currentLocation'.tr(context: context);
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? 0 : itemVerticalPaddings,
        top: isFirst ? 0 : itemVerticalPaddings,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.primaryLocationName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.mainTextStyle,
                    ),
                    if (location.detailedLocationAddress != null)
                      Text(
                        location.detailedLocationAddress!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.subTextStyle.copyWith(
                          color: AppColors.lightGrayTextColor,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              CustomSquareButtonWithIcon(
                size: 18,
                iconSize: 8,
                borderWidth: 0,
                borderRadius: 3,
                iconPath: Svgs.closeIcon,
                backgroundColor: AppColors.unhoveredSmallButtonBackgroundColor,
                borderColor: AppColors.unhoveredSmallButtonBackgroundColor,
                iconColor: AppColors.whitenColor,
                detectWhenButtonIsHoveredOrPressed: true,
                onTap: () {
                  BlocProvider.of<LocationsBloc>(context).add(
                    LocationsRemoveLocationRequested(
                      uid: location.uid,
                    ),
                  );
                },
              ),
            ],
          ),
          if (subText.isNotEmpty)
            Text(
              subText,
              style: AppTypography.subTextStyle.copyWith(
                color: AppColors.lightGrayTextColor,
              ),
            ),
        ],
      ),
    );
  }
}

class AdvancedOptions extends StatefulWidget {
  final bool showOptions;

  const AdvancedOptions({
    super.key,
    required this.showOptions,
  });

  @override
  State<AdvancedOptions> createState() => _AdvancedOptionsState();
}

class _AdvancedOptionsState extends State<AdvancedOptions> {
  late bool showOptions;

  @override
  void initState() {
    showOptions = widget.showOptions;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AdvancedOptions oldWidget) {
    showOptions = showOptions;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            setState(() => showOptions = !showOptions);
          },
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'advancedOptions'.tr(context: context),
                style: AppTypography.mainTextStyle.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 15),
              RotatedBox(
                quarterTurns: showOptions ? 1 : 3,
                child: CustomIconButton(
                  iconPath: ImageAssetPathFormater.formatImageAssetPath(
                    imageAssetPath: Svgs.smallArrowLeftIcon,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showOptions) const SizedBox(height: 15),
        if (showOptions)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<RouteBloc, RouteState>(
                builder: (context, routeState) {
                  return SideBarOptionWithSwitch(
                    text: 'cycleRoute'.tr(context: context),
                    infoTitle: 'cycleRouteTitle'.tr(context: context),
                    infoText: 'cycleRouteText'.tr(context: context),
                    value: routeState.cycledRoute,
                    onToggle: (toggleValue) {
                      BlocProvider.of<RouteBloc>(context).add(
                        RouteConfigureRouteRequested(
                          cycledRoute: toggleValue,
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 15),
              BlocBuilder<RouteBloc, RouteState>(
                builder: (context, routeState) {
                  return SideBarOptionWithSwitch(
                    text: 'setStartPoint'.tr(context: context),
                    infoTitle: 'setStartPointTitle'.tr(context: context),
                    infoText: 'setStartPointText'.tr(context: context),
                    value: routeState.withStartPoint,
                    onToggle: (toggleValue) {
                      BlocProvider.of<RouteBloc>(context).add(
                        RouteConfigureRouteRequested(
                          withStartPoint: toggleValue,
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 15),
              BlocBuilder<RouteBloc, RouteState>(
                builder: (context, routeState) {
                  return SideBarOptionWithSwitch(
                    text: 'setEndPoint'.tr(context: context),
                    infoTitle: 'setEndPointTitle'.tr(context: context),
                    infoText: 'setEndPointText'.tr(context: context),
                    value: routeState.withEndPoint,
                    onToggle: (toggleValue) {
                      BlocProvider.of<RouteBloc>(context).add(
                        RouteConfigureRouteRequested(
                          withEndPoint: toggleValue,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          )
      ],
    );
  }
}
