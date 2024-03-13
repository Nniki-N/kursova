import 'package:kursova/core/errors/location_exception.dart';
import 'package:kursova/domain/entities/location.dart';
import 'package:latlong2/latlong.dart';

abstract class LocationRepository {
  const LocationRepository();

  /// Resets whole repository saved data. This is recomended to do start generation of unnamed locations from the beggining.
  void resetRepository();

  /// Retrieves location data by coordinates.
  ///
  /// Returns [Location] with retrieved data if request was successful and otherwise [Location] with
  /// already provided data.
  ///
  /// The primaryLocationName of location is city/town if place if populated or generated name like 'Point 3'.
  /// The uid is always randomly generated.
  Future<Location> retrieveLocationByCoordinates({
    required LatLng latLng,
    LocationType returnedLocationType = LocationType.locationOnMap,
    String lang = 'en',
  });

  /// Retrieves location data by address.
  ///
  /// Returns [Location] with retrieved data if request was successful, otherwise throws [RetrievingLocationByAddressLocationException].
  ///
  /// The primaryLocationName of location is city/town if place if populated or generated name like 'Point 3'.
  /// The uid is always randomly generated.
  Future<Location> retrieveLocationByAddress({
    required String address,
    LocationType returnedLocationType = LocationType.locationFromSearch,
    String lang = 'en',
  });
}
