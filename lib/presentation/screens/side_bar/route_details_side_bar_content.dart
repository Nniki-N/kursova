import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/presentation/blocs/route_bloc/Route_event.dart';
import 'package:kursova/presentation/blocs/route_bloc/route_bloc.dart';
import 'package:kursova/presentation/blocs/route_bloc/route_state.dart';
import 'package:kursova/presentation/screens/side_bar/widgets/side_bar_header.dart';
import 'package:kursova/presentation/screens/side_bar/widgets/side_bar_horizontal_paddings_container.dart';
import 'package:kursova/presentation/widgets/custom_buttons/custom_main_button.dart';
import 'package:kursova/resources/app_colors.dart';
import 'package:kursova/resources/app_typography.dart';

class RouteDetailsSideBarContent extends StatelessWidget {
  final textFieldController = TextEditingController();
  final double padding;

  RouteDetailsSideBarContent({
    super.key,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(height: 25),
        SideBarHorizontalPaddingsContainer(
          child: BlocBuilder<RouteBloc, RouteState>(
            builder: (context, routeState) {
              final double distanceInMeters =
                  routeState.route.totalDistanceInMeters;
              final int durationInSeconds =
                  routeState.route.totalDurationsInSeconds;

              String distanceString;
              String durationString;

              if (distanceInMeters >= 100) {
                distanceString = 'distance'.tr(
                  context: context,
                  gender: 'km',
                  args: [
                    (distanceInMeters / 1000).toStringAsFixed(1).toString()
                  ],
                );
              } else {
                distanceString = 'distance'.tr(
                  context: context,
                  gender: 'm',
                  args: [distanceInMeters.toInt().toString()],
                );
              }

              if (durationInSeconds >= 3600) {
                durationString = 'time'.tr(
                  context: context,
                  gender: 'hrAndMin',
                  args: [
                    (durationInSeconds ~/ 3600).toString(),
                    (durationInSeconds % 3600 ~/ 60).toString(),
                  ],
                );
              } else {
                durationString = 'time'.tr(
                  context: context,
                  gender: 'min',
                  args: [
                    (durationInSeconds ~/ 60).toString(),
                  ],
                );
              }

              return Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'total'.tr(context: context),
                    style: AppTypography.mainTextStyle.copyWith(
                      color: AppColors.mainTextColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    distanceString,
                    style: AppTypography.secondTextStyle.copyWith(
                      color: AppColors.mainTextColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 6,
                    height: 1.5,
                    decoration: BoxDecoration(
                      color: AppColors.mainTextColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    durationString,
                    style: AppTypography.secondTextStyle.copyWith(
                      color: AppColors.mainTextColor,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        BlocBuilder<RouteBloc, RouteState>(
          builder: (context, routeState) {
            final List<Location> locations = routeState.route.locations;
            final List<double> distancesInMeters =
                routeState.route.distancesInMeters;
            final List<int> durationsInSeconds =
                routeState.route.durationsInSeconds;

            if (routeState.cycledRoute) {
              locations.add(locations.first);
            }

            return Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: padding),
                itemBuilder: (context, index) {
                  final String locationNameText;
                  final Location location = locations[index];

                  if (location.detailedLocationAddress != null) {
                    locationNameText =
                        '${location.primaryLocationName}, ${location.detailedLocationAddress}';
                  } else {
                    locationNameText = location.primaryLocationName;
                  }

                  return Text(
                    locationNameText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.mainTextStyle.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  if (index > distancesInMeters.length - 1) {
                    return const SizedBox(height: 30);
                  }

                  return LocationsSeparator(
                    distanceInMeters: distancesInMeters[index],
                    durationInSeconds: durationsInSeconds[index],
                  );
                },
                itemCount: locations.length,
              ),
            );
          },
        ),
        const SizedBox(height: 35),
        SideBarHorizontalPaddingsContainer(
          leftPadding: padding,
          rightPadding: padding,
          child: CustomMainButton(
            onTap: () {
              BlocProvider.of<RouteBloc>(context).add(
                const RouteRemoveRouteRequested(),
              );
            },
            text: 'back'.tr(context: context),
          ),
        ),
      ],
    );
  }
}

class LocationsSeparator extends StatelessWidget {
  final double distanceInMeters;
  final int durationInSeconds;

  const LocationsSeparator({
    super.key,
    required this.distanceInMeters,
    required this.durationInSeconds,
  });

  @override
  Widget build(BuildContext context) {
    String distanceString;
    String durationString;

    if (distanceInMeters >= 100) {
      distanceString = 'distance'.tr(
        context: context,
        gender: 'km',
        args: [(distanceInMeters / 1000).toStringAsFixed(1).toString()],
      );
    } else {
      distanceString = 'distance'.tr(
        context: context,
        gender: 'm',
        args: [distanceInMeters.toInt().toString()],
      );
    }

    if (durationInSeconds >= 3600) {
      durationString = 'time'.tr(
        context: context,
        gender: 'hrAndMin',
        args: [
          (durationInSeconds ~/ 3600).toString(),
          (durationInSeconds % 3600 ~/ 60).toString(),
        ],
      );
    } else {
      durationString = 'time'.tr(
        context: context,
        gender: 'min',
        args: [
          (durationInSeconds ~/ 60).toString(),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const SeparatorDot(color: AppColors.locationSeparationColor),
        const SizedBox(height: 7),
        const SeparatorDot(color: AppColors.locationSeparationColor),
        const SizedBox(height: 7),
        const SeparatorDot(color: AppColors.locationSeparationColor),
        const SizedBox(height: 9),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              distanceString,
              style: AppTypography.secondTextStyle.copyWith(
                color: AppColors.lightGrayTextColor,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 6,
              height: 1.5,
              decoration: BoxDecoration(
                color: AppColors.lightGrayTextColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              durationString,
              style: AppTypography.secondTextStyle.copyWith(
                color: AppColors.lightGrayTextColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        const SeparatorDot(color: AppColors.locationSeparationColor),
        const SizedBox(height: 7),
        const SeparatorDot(color: AppColors.locationSeparationColor),
        const SizedBox(height: 7),
        const SeparatorDot(color: AppColors.locationSeparationColor),
        const SizedBox(height: 10),
      ],
    );
  }
}

class SeparatorDot extends StatelessWidget {
  final Color color;

  const SeparatorDot({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: 2,
      margin: const EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
