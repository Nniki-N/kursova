import 'dart:convert';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/core/utils/route_util.dart';
import 'package:kursova/data/models/osrm_route_response_model.dart';
import 'package:latlong2/latlong.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  group(
    'RouteUtil ->',
    () {
      late List<LatLng> route;
      late PolylinePoints polylinePoints;

      setUp(
        () {
          polylinePoints = PolylinePoints();
          final Map<String, dynamic> routeAsJson = json.decode(
            fixture(fileName: 'long_route_coordinates.json'),
          );

          route = polylinePoints
              .decodePolyline(OsrmRouteResponseModel.fromJson(routeAsJson)
                  .routes
                  .first
                  .geometry)
              .map((pointLatLng) => LatLng(
                    pointLatLng.latitude,
                    pointLatLng.longitude,
                  ))
              .toList();
        },
      );

      group(
        'simplifyCoordinatesRoute function',
        () {
          test(
            'should simplify route when more then 35000 coordinates were provided',
            () {
              final simplifiedRoute = RouteUtil.simplifyCoordinatesRoute(
                routeCoordinates: route,
                cycledroute: false,
              );

              expect(route.length > simplifiedRoute.length, true);
            },
          );
        },
      );
    },
  );
}
