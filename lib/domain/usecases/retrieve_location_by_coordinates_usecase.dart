import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/repositories/location_repository.dart';
import 'package:latlong2/latlong.dart';

/// Use case that is used for retrieving location data by coordinates via comunication with [LocationRepository].
class RetrieveLocationByCoordinatesUseCase {
  RetrieveLocationByCoordinatesUseCase({
    required LocationRepository locationRepository,
  }) : _locationRepository = locationRepository;

  final LocationRepository _locationRepository;

  /// Retrieves location data by coordinates [latLng].
  /// 
  /// [locationDataLang] represents language of response data. It has to be language code only.
  /// 
  /// [startRetrievingLocationsFromFirstPoint] resets nameless points count.
  Future<Location> execute({
    required LatLng latLng,
    required String locationDataLang,
    bool startRetrievingLocationsFromFirstPoint = false,
  }) async {
    if (startRetrievingLocationsFromFirstPoint) {
      _locationRepository.resetRepository();
    }

    return _locationRepository.retrieveLocationByCoordinates(
      latLng: latLng,
      lang: locationDataLang,
    );
  }
}
