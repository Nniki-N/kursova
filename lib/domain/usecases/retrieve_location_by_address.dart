import 'package:kursova/core/errors/location_exception.dart';
import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/repositories/location_repository.dart';

/// Use case that is used for retrieving location data by address via comunication with [LocationRepository].
class RetrieveLocationByAddressUseCase {
  RetrieveLocationByAddressUseCase({
    required LocationRepository locationRepository,
  }) : _locationRepository = locationRepository;

  final LocationRepository _locationRepository;

  /// Retrieves location data by address [address].
  /// 
  /// [locationDataLang] represents language of response data. It has to be language code only.
  /// 
  /// [startRetrievingLocationsFromFirstPoint] resets nameless points count.
  /// 
  /// Any exception that can occur inherit [LocationException].
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
