import 'package:kursova/core/errors/location_exception.dart';
import 'package:kursova/domain/entities/location.dart';
import 'package:latlong2/latlong.dart';

/// Interface for the location repository.
abstract class LocationRepository {
  const LocationRepository();

  /// Resets whole repository saved data. This is recomended to do start generation of unnamed locations from the beggining.
  void resetRepository();

  /// Retrieves location data by coordinates [latLng].
  /// 
  /// [returnedLocationType] specifies the way the location was choosen. It does not affect request and is returned just as [Location.locationType] value.
  /// 
  /// [lang] represents language of response data. It has to be language code only. By default is 'en', which is language code of English.
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

  /// Retrieves location data by address [address].
  /// 
  /// [returnedLocationType] specifies the way the location was choosen. It does not affect request and is returned just as [Location.locationType] value.
  /// 
  /// [lang] represents language of response data. It has to be language code only. By default is 'en', which is language code of English.
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
