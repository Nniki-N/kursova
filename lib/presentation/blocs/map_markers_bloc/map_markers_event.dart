import 'package:latlong2/latlong.dart';

abstract class MapMarkersEvent {
  const MapMarkersEvent();
}

class MapMarkersAddMakerRequested extends MapMarkersEvent {
  final LatLng latLng;

  const MapMarkersAddMakerRequested({
    required this.latLng,
  });
}

class MapMarkersReplaceMarkersRequested extends MapMarkersEvent {
  final List<LatLng> coordinatesList;

  const MapMarkersReplaceMarkersRequested({
    required this.coordinatesList,
  });
}

class MapMarkersClearMarkersRequested extends MapMarkersEvent {
  const MapMarkersClearMarkersRequested();
}
