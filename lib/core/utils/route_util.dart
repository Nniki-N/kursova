import 'dart:math';

import 'package:latlong2/latlong.dart';

/// An util that is used for route optimization/simplification.
abstract class RouteUtil {

  /// Simplifies route by reducing route coordinates number from provided [routeCoordinates].
  /// Douglas-Peucker algorithm is used for simplification.
  /// 
  /// Obligatorily set [cycledroute] to true if route is cycled, otherwise route will not be optimized!
  /// 
  /// Set [minimalRouteCoordinatesLengthToSimplify] to lower or higher number to change miimal bar for route simplification.
  static List<LatLng> simplifyCoordinatesRoute({
    required List<LatLng> routeCoordinates,
    required bool cycledroute,
    int minimalRouteCoordinatesLengthToSimplify = 35000,
  }) {
    print('routeCoordinates = ${routeCoordinates.length}');
    
    if (routeCoordinates.length <= 35000) {
      return routeCoordinates;
    }

    List<LatLng> tempLastCoordinates = [];

    /// Removes from and saves last 1000 coordinates in temporary list to allow algorithm work as expected.
    if (cycledroute) {
      tempLastCoordinates = routeCoordinates.sublist(
        routeCoordinates.length - 1000,
      );

      routeCoordinates.removeRange(
        routeCoordinates.length - 1000,
        routeCoordinates.length,
      );
    }

    double tolerance = 0.000001;
    if (routeCoordinates.length > minimalRouteCoordinatesLengthToSimplify * 2) {
      tolerance = 0.00001;
    } else if (routeCoordinates.length >
        minimalRouteCoordinatesLengthToSimplify) {
      tolerance = 0.000001;
    }

    final List<LatLng> simplifiedCoordinates = _douglasPeucker(
      coordinates: routeCoordinates,
      tolerance: tolerance,
    );

    if (simplifiedCoordinates.length <= 2) {
      return routeCoordinates;
    }

    if (cycledroute) {
      simplifiedCoordinates.addAll(tempLastCoordinates);
    }

    print('simplifiedCoordinates = ${simplifiedCoordinates.length}');

    return simplifiedCoordinates;
  }

  /// Douglas Peucker method for reducing number of [coordinates] in the route.
  /// 
  /// The algorithm recursively breaks the route into shorter segments, using the points with the maximum deviation from the straight line between the starting and ending points of the route.
  /// 
  /// [tolerance] indicates the power of simplification. It is recomended to use 0.00001 to start from light simplification.
  static List<LatLng> _douglasPeucker({
    required List<LatLng> coordinates,
    required double tolerance,
  }) {
    if (coordinates.length < 3) {
      return coordinates;
    }

    int furthestIndex = 0;
    double maxDistance = 0.0;
    final LatLng start = coordinates.first;
    final LatLng end = coordinates.last;

    // Iterates through each point to find the furthest point.
    for (int i = 1; i < coordinates.length - 1; i++) {
      // Calculates the perpendicular distance of the point from the line formed by start and end points.
      final double distance = _perpendicularDistance(
        coordinate: coordinates[i],
        lineStart: start,
        lineEnd: end,
      );

      // Updates the furthest point and its distance if a new maximum distance is found.
      if (distance > maxDistance) {
        maxDistance = distance;
        furthestIndex = i;
      }
    }

    // If the maximum distance is greater than the tolerance, recursively simplifies the segments.
    if (maxDistance > tolerance) {
      final List<LatLng> simplified1 = _douglasPeucker(
        coordinates: coordinates.sublist(0, furthestIndex + 1),
        tolerance: tolerance,
      );

      final List<LatLng> simplified2 = _douglasPeucker(
        coordinates: coordinates.sublist(furthestIndex, coordinates.length),
        tolerance: tolerance,
      );

      // Combines the simplified segments and remove the duplicated point.
      return [
        ...simplified1.sublist(0, simplified1.length - 1),
        ...simplified2
      ];
    } else {
      // If the maximum distance is within the tolerance, returns the start and end points.
      return [start, end];
    }
  }

  /// Calculates the perpendicular distance from a point to a line.
  static double _perpendicularDistance({
    required LatLng coordinate,
    required LatLng lineStart,
    required LatLng lineEnd,
  }) {
    final double x = coordinate.longitude;
    final double y = coordinate.latitude;
    final double x1 = lineStart.longitude;
    final double y1 = lineStart.latitude;
    final double x2 = lineEnd.longitude;
    final double y2 = lineEnd.latitude;

    final double numerator =
        ((y2 - y1) * x - (x2 - x1) * y + x2 * y1 - y2 * x1).abs();
    final double denominator = sqrt(pow(y2 - y1, 2) + pow(x2 - x1, 2));

    return numerator / denominator;
  }
}
