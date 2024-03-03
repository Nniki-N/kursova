import 'package:latlong2/latlong.dart';

abstract class LocationsEvent {
  const LocationsEvent();
}

class LocationsAddNewLocationRequested extends LocationsEvent {
  final LatLng latLng;
  final String locationDataLang;

  const LocationsAddNewLocationRequested({
    required this.latLng,
    required this.locationDataLang,
  });
}

class LocationsAddCurrentUserLocationRequested extends LocationsEvent {
  final String locationDataLang;

  const LocationsAddCurrentUserLocationRequested({
    required this.locationDataLang,
  });
}

class LocationsAddLocationByAddressRequested extends LocationsEvent {
  final String address;
  final String locationDataLang;

  const LocationsAddLocationByAddressRequested({
    required this.address,
    required this.locationDataLang,
  });
}

class LocationsRemoveLocationRequested extends LocationsEvent {
  final String uid;

  const LocationsRemoveLocationRequested({
    required this.uid,
  });
}

class LocationsMoveOneLocationInOrderRequested extends LocationsEvent {
  final int oldIndex;
  final int newIndex;

  const LocationsMoveOneLocationInOrderRequested({
    required this.oldIndex,
    required this.newIndex,
  });
}

class LocationsClearLocationsRequested extends LocationsEvent {
  const LocationsClearLocationsRequested();
}
