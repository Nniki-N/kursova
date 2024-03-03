import 'package:kursova/domain/entities/location_marker.dart';

abstract class MapMarkersState {
  final List<LocationMarker> locationMarkers;

  const MapMarkersState({
    required this.locationMarkers,
  });

  @override
  String toString() => '$runtimeType(locationMarkers: $locationMarkers)';
}

class MapMarkersEmpty extends MapMarkersState {
  MapMarkersEmpty() : super(locationMarkers: []);
}

class MapMarkersNotEmpty extends MapMarkersState {
  MapMarkersNotEmpty({
    required List<LocationMarker> locationMarkers,
  }) : super(locationMarkers: locationMarkers);
}

class MapMarkersAddingMarkerFailure extends MapMarkersState {
  MapMarkersAddingMarkerFailure({
    required List<LocationMarker> locationMarkers,
  }) : super(locationMarkers: locationMarkers);
}

class MapMarkersReplacingMarkerFailure extends MapMarkersState {
  MapMarkersReplacingMarkerFailure({
    required List<LocationMarker> locationMarkers,
  }) : super(locationMarkers: locationMarkers);
}

class MapMarkersReachedMarkersLimit extends MapMarkersState {
  MapMarkersReachedMarkersLimit({
    required List<LocationMarker> locationMarkers,
  }) : super(locationMarkers: locationMarkers);
}
