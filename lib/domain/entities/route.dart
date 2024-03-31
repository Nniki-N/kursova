// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:kursova/domain/entities/location.dart';
import 'package:latlong2/latlong.dart';

/// A class for route data to be represented on the map and in the route description.
class Route {
  final List<LatLng> polylineRouteCoordinates;
  final List<Location> locations;
  final List<double> distancesInMeters;
  final List<int> durationsInSeconds;
  final double totalDistanceInMeters;
  final int totalDurationsInSeconds;

  Route({
    required this.polylineRouteCoordinates,
    required this.locations,
    required this.distancesInMeters,
    required this.durationsInSeconds,
    required this.totalDistanceInMeters,
    required this.totalDurationsInSeconds,
  });

  Route.empty()
      : polylineRouteCoordinates = const [],
        locations = const [],
        distancesInMeters = const [],
        durationsInSeconds = const [],
        totalDistanceInMeters = 0,
        totalDurationsInSeconds = 0;
}
