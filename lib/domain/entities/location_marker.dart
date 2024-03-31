// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:latlong2/latlong.dart';

/// A class for location marker that will be used on map to represent coordinates.
class LocationMarker {
  final LatLng coordinate;

  LocationMarker({
    required this.coordinate,
  });

  @override
  String toString() => 'LocationMarker(coordinate: $coordinate)';
}
