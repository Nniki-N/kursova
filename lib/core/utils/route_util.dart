import 'dart:math';

import 'package:latlong2/latlong.dart';

abstract class RouteUtil {
  /// Simplifies route by reducing route coordinates number.
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
      points: routeCoordinates,
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

  /// Douglas Peucker method for reducing number of coordinates in the route.
  static List<LatLng> _douglasPeucker({
    required List<LatLng> points,
    required double tolerance,
  }) {
    if (points.length < 3) {
      return points;
    }

    int furthestIndex = 0;
    double maxDistance = 0.0;
    final LatLng start = points.first;
    final LatLng end = points.last;

    for (int i = 1; i < points.length - 1; i++) {
      final double distance = _perpendicularDistance(
        point: points[i],
        lineStart: start,
        lineEnd: end,
      );

      if (distance > maxDistance) {
        maxDistance = distance;
        furthestIndex = i;
      }
    }

    if (maxDistance > tolerance) {
      final List<LatLng> simplified1 = _douglasPeucker(
        points: points.sublist(0, furthestIndex + 1),
        tolerance: tolerance,
      );

      final List<LatLng> simplified2 = _douglasPeucker(
        points: points.sublist(furthestIndex, points.length),
        tolerance: tolerance,
      );

      return [
        ...simplified1.sublist(0, simplified1.length - 1),
        ...simplified2
      ];
    } else {
      return [start, end];
    }
  }

  static double _perpendicularDistance({
    required LatLng point,
    required LatLng lineStart,
    required LatLng lineEnd,
  }) {
    final double x = point.longitude;
    final double y = point.latitude;
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
