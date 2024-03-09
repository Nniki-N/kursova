import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/repositories/location_repository.dart';
import 'package:latlong2/latlong.dart';

class RetrieveLocationByCoordinatesUseCase {
  RetrieveLocationByCoordinatesUseCase({
    required LocationRepository locationRepository,
  }) : _locationRepository = locationRepository;

  final LocationRepository _locationRepository;

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
