import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kursova/core/app_constants.dart';
import 'package:kursova/core/utils/image_asset_path_formater.dart';
import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/presentation/blocs/locations_bloc/locations_bloc.dart';
import 'package:kursova/presentation/blocs/locations_bloc/locations_event.dart';
import 'package:kursova/presentation/blocs/locations_bloc/locations_state.dart';
import 'package:kursova/presentation/blocs/map_markers_bloc/map_markers_bloc.dart';
import 'package:kursova/presentation/blocs/map_markers_bloc/map_markers_event.dart';
import 'package:kursova/presentation/blocs/map_markers_bloc/map_markers_state.dart';
import 'package:kursova/presentation/blocs/route_bloc/route_bloc.dart';
import 'package:kursova/presentation/blocs/route_bloc/route_state.dart';
import 'package:kursova/presentation/cubits/side_bar_menu_visibility_cubit.dart';
import 'package:kursova/presentation/screens/side_bar/choose_locations_side_bar_content.dart';
import 'package:kursova/presentation/screens/side_bar/loading_side_bar_content.dart';
import 'package:kursova/presentation/screens/side_bar/route_details_side_bar_content.dart';
import 'package:kursova/presentation/screens/side_bar/side_bar.dart';
import 'package:kursova/presentation/screens/side_bar/widgets/language_dropdown.dart';
import 'package:kursova/presentation/screens/side_bar/widgets/side_bar_open_button.dart';
import 'package:kursova/presentation/widgets/custom_popups/check_and_show_no_internet_connection_pop_up.dart';
import 'package:kursova/presentation/widgets/custom_popups/show_notification_popup.dart';
import 'package:kursova/presentation/widgets/custom_snackbar/show_custom_error_snack_bar.dart';
import 'package:kursova/resources/app_colors.dart';
import 'package:kursova/resources/app_ui_constants.dart';
import 'package:kursova/resources/graphics/resources.dart';
import 'package:latlong2/latlong.dart' as latlong;

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool showCustomSideBar = kIsWeb &&
        MediaQuery.of(context).size.width >
            AppUIConstants.maximalWidthToShowDrawer;

    const double sidebarWidth = 380;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double sidebarHeight =
        screenHeight < 1000 ? screenHeight * 0.9 : 900;

    const double markerSize = 80;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      // A drawer is shown on mobile platforms or when web window is to narrow
      drawer: Drawer(
        backgroundColor: AppColors.backgroundColor,
        width: sidebarWidth,
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
      body: MultiBlocListener(
        listeners: [
          BlocListener<LocationsBloc, LocationsState>(
            listener: (context, locationState) {
              // Updates locations on the map after new location was added in any way
              if (locationState is LocationsNotEmpty ||
                  locationState is LocationsReachedLocationsLimit) {
                final List<Location> locations =
                    BlocProvider.of<LocationsBloc>(context).state.locations;

                BlocProvider.of<MapMarkersBloc>(context).add(
                  MapMarkersReplaceMarkersRequested(
                    coordinatesList: locations
                        .map((location) => location.coordinate)
                        .toList(),
                  ),
                );
              }

              // Shows that user has reached current locations limit
              if (locationState is LocationsReachedCurrentLocationsLimit) {
                showNotificationPopUp(
                  context: context,
                  title: 'currentLocationsLimit'.tr(context: context),
                  text: 'currentLocationsLimitText'.tr(context: context),
                  buttonText: 'ok'.tr(context: context),
                );
              }

              // Shows that user has reached locations limit
              else if (locationState is LocationsReachedLocationsLimit &&
                  locationState.showMessage) {
                showNotificationPopUp(
                  context: context,
                  title: 'locationsLimit'.tr(context: context),
                  text: 'locationsLimitText'.tr(
                    context: context,
                    args: [AppConstants.locationsLimit.toString()],
                  ),
                  buttonText: 'ok'.tr(context: context),
                );
              }

              // Shows adding location failure message. It could have been current location,
              // location from text field or location from map.
              if (locationState is LocationsAddingLocationFailure) {
                showCustomErrorSnackbar(
                  context: context,
                  title: 'addingLocationFailure'.tr(context: context),
                  text: 'addingLocationFailureText'.tr(context: context),
                );
              } else if (locationState
                  is LocationsAddingCurrentLocationFailure) {
                showCustomErrorSnackbar(
                  context: context,
                  title: 'addingCurrentLocationFailure'.tr(context: context),
                  text: 'addingCurrentLocationFailureText'.tr(context: context),
                  displayDurationInSeconds: 6,
                );
              }
            },
          ),
          BlocListener<RouteBloc, RouteState>(
            listener: (context, routeState) {
              // Shows creating route failure message
              if (routeState is RouteLoadingRouteFaillure) {
                showCustomErrorSnackbar(
                  context: context,
                  title: 'creatingRouteFailure'.tr(context: context),
                  text: 'creatingRouteFailureText'.tr(context: context),
                  displayDurationInSeconds: 9,
                );
              }
            },
          ),
        ],
        child: Stack(
          children: [
            // A map that takes all availablespace
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: FlutterMap(
                mapController: MapController(),
                options: MapOptions(
                  // An initial center is Kyiv
                  initialCenter: const latlong.LatLng(50.451226, 30.515041),
                  initialZoom: 6,
                  cameraConstraint: CameraConstraint.contain(
                    bounds: LatLngBounds(
                      const latlong.LatLng(-90, 180),
                      const latlong.LatLng(90, -180),
                    ),
                  ),
                  onTap: (tapPosition, latLng) {
                    if (checkAndShowNoInternetConnectionPopUp(context)) {
                      return;
                    }

                    final LocationsState locationsState =
                        BlocProvider.of<LocationsBloc>(context).state;

                    if (locationsState is LocationsAddingLocation) {
                      return;
                    }

                    final RouteState routeState =
                        BlocProvider.of<RouteBloc>(context).state;

                    if (routeState is RouteLoaded) {
                      return;
                    }

                    BlocProvider.of<LocationsBloc>(context).add(
                      LocationsAddNewLocationRequested(
                        latLng: latLng,
                        locationDataLang: context.locale.languageCode,
                      ),
                    );
                    BlocProvider.of<MapMarkersBloc>(context).add(
                      MapMarkersAddMakerRequested(latLng: latLng),
                    );
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),

                  // A created route
                  BlocBuilder<RouteBloc, RouteState>(
                    builder: (context, routeState) {
                      return PolylineLayer(
                        polylines: [
                          if (routeState
                              .route.polylineRouteCoordinates.isNotEmpty)
                            Polyline(
                              points: routeState.route.polylineRouteCoordinates,
                              strokeWidth: 8,
                              color: AppColors.routeColor,
                            ),
                        ],
                        polylineCulling: true,
                      );
                    },
                  ),

                  // All locations in the list
                  BlocBuilder<MapMarkersBloc, MapMarkersState>(
                    builder: (context, mapMarkersState) {
                      final locationMarkers = mapMarkersState.locationMarkers;

                      return MarkerLayer(
                        markers: [
                          if (locationMarkers.isNotEmpty)
                            ...locationMarkers
                                .map(
                                  (locationMarker) => Marker(
                                    width: markerSize,
                                    height: markerSize,
                                    point: locationMarker.coordinate,
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        bottom: markerSize / 2,
                                      ),
                                      child: SizedBox(
                                        height: markerSize / 25,
                                        width: markerSize / 25,
                                        child: SvgPicture.asset(
                                          ImageAssetPathFormater
                                              .formatImageAssetPath(
                                            imageAssetPath: Svgs.markerIcon,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // A language dropdown has always the same position on all platforms
            const Positioned(
              right: 15,
              top: 15,
              child: LanguageDropdown(),
            ),

            // Is shown in web when window is wider then AppUIConstants.maximalWidthToShowDrawer
            if (showCustomSideBar)
              BlocProvider(
                create: (context) => SideBarMenuVisibilityCubit(),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SideBar(
                    sidebarWidth: sidebarWidth,
                    sidebarHeight: sidebarHeight,
                  ),
                ),
              ),

            // Is shown when not custom side bar is used
            if (!showCustomSideBar)
              Positioned(
                left: 0,
                top: 15,
                child: Builder(
                  builder: (context) {
                    return SideBarOpenButton(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
