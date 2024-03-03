// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:kursova/domain/entities/location.dart';

abstract class LocationsState {
  final List<Location> locations;

  const LocationsState({
    required this.locations,
  });

  @override
  String toString() => '$runtimeType(locations: $locations)';
}

class LocationsEmpty extends LocationsState {
  LocationsEmpty() : super(locations: []);
}

class LocationsNotEmpty extends LocationsState {
  LocationsNotEmpty({
    required List<Location> locations,
  }) : super(locations: locations);
}

class LocationsAddingLocation extends LocationsState {
  LocationsAddingLocation({
    required List<Location> locations,
  }) : super(locations: locations);
}

class LocationsReachedLocationsLimit extends LocationsState {
  final bool showMessage;

  LocationsReachedLocationsLimit({
    required List<Location> locations,
    required this.showMessage,
  }) : super(locations: locations);
}

class LocationsReachedCurrentLocationsLimit extends LocationsState {
  LocationsReachedCurrentLocationsLimit({
    required List<Location> locations,
  }) : super(locations: locations);
}

class LocationsAddingLocationFailure extends LocationsState {
  LocationsAddingLocationFailure({
    required List<Location> locations,
  }) : super(locations: locations);
}

class LocationsAddingCurrentLocationFailure extends LocationsState {
  LocationsAddingCurrentLocationFailure({
    required List<Location> locations,
  }) : super(locations: locations);
}

class LocationsRemovingLocationFailure extends LocationsState {
  LocationsRemovingLocationFailure({
    required List<Location> locations,
  }) : super(locations: locations);
}

class LocationMovingOneLocationInOrderFailure extends LocationsState {
  LocationMovingOneLocationInOrderFailure({
    required List<Location> locations,
  }) : super(locations: locations);
}
