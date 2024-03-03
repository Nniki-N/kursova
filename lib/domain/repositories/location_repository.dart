import 'package:kursova/domain/entities/location.dart';
import 'package:latlong2/latlong.dart';

abstract class LocationRepository {
  const LocationRepository();

  /// Resets whole repository saved data. This is recomended to do start generation of unnamed locations from the beggining.
  void resetRepository();

  /// Retrieves location data by coordinates.
  ///
  /// Returns [Location] with retrieved data if request was successful and [Location] with
  /// alreaady provided data otherwise.
  ///
  /// The primaryLocationName of location is city/town if place if populated or generated name like 'Point 3'.
  /// The uid is always randomly generated.
  Future<Location> retrieveLocationByCoordinates({
    required LatLng latLng,
    String lang = 'en',
  });

  /// Retrieves current location data.
  ///
  /// Returns [Location] if request was successful and null if not.
  ///
  /// The primaryLocationName of location is city/town if place if populated and 'Current location' otherwise.
  /// The uid is always randomly generated.
  Future<Location?> retrieveCurrentLocation({
    String lang = 'en',
  });

  /// Retrieves location data by address.
  ///
  /// Returns [Location] if request was successful and null if not.
  ///
  /// The primaryLocationName of location is city/town if place if populated or generated name like 'Point 3'.
  /// The uid is always randomly generated.
  Future<Location?> retrieveLocationByAddress({
    required String address,
    String lang = 'en',
  });
}
