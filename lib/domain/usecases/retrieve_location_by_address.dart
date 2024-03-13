import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/repositories/location_repository.dart';

class RetrieveLocationByAddressUseCase {
  RetrieveLocationByAddressUseCase({
    required LocationRepository locationRepository,
  }) : _locationRepository = locationRepository;

  final LocationRepository _locationRepository;

  Future<Location> execute({
    required String address,
    required String locationDataLang,
    bool startRetrievingLocationsFromFirstPoint = false,
  }) async {
    if (startRetrievingLocationsFromFirstPoint) {
      _locationRepository.resetRepository();
    }

    return _locationRepository.retrieveLocationByAddress(
      address: address,
      lang: locationDataLang,
    );
  }
}
