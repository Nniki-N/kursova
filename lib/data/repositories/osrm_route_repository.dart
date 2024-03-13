import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kursova/core/errors/osrm_exception.dart';
import 'package:kursova/core/errors/route_exception.dart';
import 'package:kursova/core/utils/route_util.dart';
import 'package:kursova/data/datasources/osrm_datasource.dart';
import 'package:kursova/data/models/osrm_route_response_model.dart'
    as osrm_route;
import 'package:kursova/data/models/osrm_trip_response_model.dart' as osrm_trip;
import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/entities/route.dart';
import 'package:kursova/domain/repositories/route_repository.dart';
import 'package:latlong2/latlong.dart';

class OsrmRouteRepository extends RouteRepository {
  const OsrmRouteRepository({
    required OsrmDatasource osrmDatasource,
  }) : _osrmDatasource = osrmDatasource;

  final OsrmDatasource _osrmDatasource;

  /// Retrieves main route for vehicle between locations in provided order by converting route polyline from osrm api in coordinates.
  ///
  /// Returns [Route] if request was successful.
  ///
  /// Throws [LocationsLackRouteException] if locations list is empty.
  ///
  /// Throws [EmptyRoutesResponseRouteException] if no routes were returned.
  ///
  /// Throws [NotOptimizedRouteRetrievingRouteException] if any other error occurs.
  @override
  Future<Route> retrieveNotOptimizedRouteBetweenLocations({
    required List<Location> orderedLocations,
  }) async {
    try {
      if (orderedLocations.isEmpty || orderedLocations.length == 1) {
        throw LocationsLackRouteException(
          messageDetails: 'locations length = ${orderedLocations.length}',
          stackTrace: StackTrace.current,
        );
      }

      final List<LatLng> locationCoordinates =
          orderedLocations.map((location) => location.coordinate).toList();

      final osrm_route.OsrmRouteResponseModel osrmRouteResponse =
          await _osrmDatasource.retrieveRouteBetweenLocations(
        orderedCoordinates: locationCoordinates,
      );

      if (osrmRouteResponse.routes.isEmpty) {
        throw EmptyRoutesResponseRouteException(
          stackTrace: StackTrace.current,
        );
      }

      final PolylinePoints polylinePoints = PolylinePoints();

      final List<LatLng> polylineRouteCoordinates = polylinePoints
          .decodePolyline(osrmRouteResponse.routes.first.geometry)
          .map((pointLatLng) => LatLng(
                pointLatLng.latitude,
                pointLatLng.longitude,
              ))
          .toList();
      // osrmRouteResponse.routes.first.geometry.coordinates
      //     .map((coordinates) => LatLng(
      //           coordinates[1],
      //           coordinates[0],
      //         ))
      //     .toList();

      final List<double> distances = osrmRouteResponse.routes.first.legs
          .map((leg) => leg.distance.toDouble())
          .toList();

      final List<int> durations = osrmRouteResponse.routes.first.legs
          .map((leg) => leg.duration.toInt())
          .toList();

      final List<LatLng> simplifiedPolylineRouteCoordinates = kIsWeb
          ? RouteUtil.simplifyCoordinatesRoute(
              routeCoordinates: polylineRouteCoordinates,
              cycledroute: false,
            )
          : await Isolate.run(
              () => RouteUtil.simplifyCoordinatesRoute(
                routeCoordinates: polylineRouteCoordinates,
                cycledroute: false,
              ),
            );

      return Route(
        polylineRouteCoordinates: simplifiedPolylineRouteCoordinates,
        locations: orderedLocations,
        distancesInMeters: distances,
        durationsInSeconds: durations,
        totalDistanceInMeters: distances.reduce((a, b) => a + b),
        totalDurationsInSeconds: durations.reduce((a, b) => a + b),
      );
    } on RouteException {
      rethrow;
    } on OsrmException catch (exception) {
      throw NotOptimizedRouteRetrievingRouteException(
        messageDetails: exception.message,
        stackTrace: exception.stackTrace,
      );
    } catch (exception, stackTrace) {
      throw NotOptimizedRouteRetrievingRouteException(
        messageDetails: exception.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  /// Retrieves optimized route for vehicle between locations by converting route polyline from osrm api in coordinates.
  ///
  /// Set [withStartPoint] to true if first location in list has to be start of the route. Set [withEndPoint] to true if last location in list has to be end of the route.
  ///
  /// Set [roundTrip] to true if route has to be cycled. All route parameters can not be set to false at the same time!
  ///
  ///
  ///
  /// Returns [Route] if request was successful.
  ///
  /// Throws [LocationsLackRouteException] if locations list is empty.
  ///
  /// Throws [OptimizedParametersCombinationOsrmException] if all route parameters were set to false.
  ///
  /// Throws [EmptyRoutesResponseRouteException] if no routes were returned.
  ///
  /// Throws [OptimizedRouteRetrievingRouteException] if any other error occurs.
  @override
  Future<Route> retrieveOptimizedRouteBetweenLocations({
    required List<Location> locations,
    required bool withStartPoint,
    required bool withEndPoint,
    required bool roundTrip,
  }) async {
    try {
      if (locations.isEmpty || locations.length == 1) {
        throw LocationsLackRouteException(
          messageDetails: 'locations length = ${locations.length}',
          stackTrace: StackTrace.current,
        );
      }

      final List<LatLng> locationCoordinates =
          locations.map((location) => location.coordinate).toList();

      if (!withEndPoint && !withStartPoint && !roundTrip) {
        throw OptimizedParametersCombinationOsrmException(
          messageDetails:
              'withStartPoint = $withStartPoint, withEndPoint = $withEndPoint, roundTrip = $roundTrip,',
          stackTrace: StackTrace.current,
        );
      }

      final osrm_trip.OsrmTripResponseModel osrmTripResponse =
          await _osrmDatasource.retrieveTripRouteBetweenLocations(
        coordinates: locationCoordinates,
        withStartPoint: withStartPoint,
        withEndPoint: withEndPoint,
        roundTrip: roundTrip,
      );

      if (osrmTripResponse.trips.isEmpty) {
        throw EmptyRoutesResponseRouteException(
          stackTrace: StackTrace.current,
        );
      }

      final PolylinePoints polylinePoints = PolylinePoints();

      final List<LatLng> polylineRouteCoordinates = polylinePoints
          .decodePolyline(osrmTripResponse.trips.first.geometry)
          .map((pointLatLng) => LatLng(
                pointLatLng.latitude,
                pointLatLng.longitude,
              ))
          .toList();
      // osrmTripResponse.trips.first.geometry.coordinates
      //     .map((coordinates) => LatLng(
      //           coordinates[1],
      //           coordinates[0],
      //         ))
      //     .toList();

      final List<double> distances = osrmTripResponse.trips.first.legs
          .map((leg) => leg.distance.toDouble())
          .toList();

      final List<int> durations = osrmTripResponse.trips.first.legs
          .map((leg) => leg.duration.toInt())
          .toList();

      final List<osrm_trip.Waypoint> waypoints = osrmTripResponse.waypoints;
      waypoints.sort((a, b) => a.waypointIndex.compareTo(b.waypointIndex));

      final List<LatLng> orderedResponseCoordinates = waypoints
          .map((waypoint) => LatLng(
                waypoint.location[1],
                waypoint.location[0],
              ))
          .toList();

      final List<Location> orderedLocations = _reorderLocations(
        locations: locations,
        orderedCoordinates: orderedResponseCoordinates,
      );

      final List<LatLng> simplifiedPolylineRouteCoordinates = kIsWeb
          ? RouteUtil.simplifyCoordinatesRoute(
              routeCoordinates: polylineRouteCoordinates,
              cycledroute: true,
            )
          : await Isolate.run(
              () => RouteUtil.simplifyCoordinatesRoute(
                routeCoordinates: polylineRouteCoordinates,
                cycledroute: true,
              ),
            );

      return Route(
        polylineRouteCoordinates: simplifiedPolylineRouteCoordinates,
        locations: orderedLocations,
        distancesInMeters: distances,
        durationsInSeconds: durations,
        totalDistanceInMeters: distances.reduce((a, b) => a + b),
        totalDurationsInSeconds: durations.reduce((a, b) => a + b),
      );
    } on RouteException {
      rethrow;
    } on OsrmException catch (exception) {
      throw OptimizedRouteRetrievingRouteException(
        messageDetails: exception.message,
        stackTrace: exception.stackTrace,
      );
    } catch (exception, stackTrace) {
      throw OptimizedRouteRetrievingRouteException(
        messageDetails: exception.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  /// Reorders [locations] according to [orderedCoordinates].
  List<Location> _reorderLocations({
    required List<Location> locations,
    required List<LatLng> orderedCoordinates,
  }) {
    final List<Location> result = [];
    final List<Location> locationsToIterate = List.from(locations);

    for (final coordinate in orderedCoordinates) {
      double minDistance = double.infinity;
      int minDistanceIndex = 0;

      for (int i = 0; i < locationsToIterate.length; i++) {
        final double distanceBetween = Geolocator.distanceBetween(
          coordinate.latitude,
          coordinate.longitude,
          locationsToIterate[i].coordinate.latitude,
          locationsToIterate[i].coordinate.longitude,
        );

        if (distanceBetween < minDistance) {
          minDistanceIndex = i;
          minDistance = distanceBetween;
        }
      }

      final Location nearesLocation = locationsToIterate.removeAt(
        minDistanceIndex,
      );

      result.add(nearesLocation);
    }

    return result;
  }
}
