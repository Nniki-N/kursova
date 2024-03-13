import 'package:kursova/core/errors/location_exception.dart';
import 'package:kursova/core/services/location_service.dart';
import 'package:kursova/core/services/permission_service.dart';
import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/repositories/location_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class RetrieveCurrentLocationUseCase {
  RetrieveCurrentLocationUseCase({
    required LocationRepository locationRepository,
    required PermissionsService permissionsService,
    required LocationService locationService,
  })  : _locationRepository = locationRepository,
        _permissionsService = permissionsService,
        _locationService = locationService;

  final LocationRepository _locationRepository;
  final PermissionsService _permissionsService;
  final LocationService _locationService;

  Future<Location> execute({
    required String locationDataLang,
    bool startRetrievingLocationsFromFirstPoint = false,
  }) async {
    if (startRetrievingLocationsFromFirstPoint) {
      _locationRepository.resetRepository();
    }

    PermissionStatus locationPermissionStatus =
        await _permissionsService.request(
      Permission.location,
    );

    // Retrieve current location only in case the location permission is granted.
    if (locationPermissionStatus.isGranted) {
      return _retrieveCurrentLocationWhenPermissionGranted(
        lang: locationDataLang,
      );
    } else if (locationPermissionStatus.isPermanentlyDenied) {
      await _permissionsService.openAppSettings();

      locationPermissionStatus = await _permissionsService.request(
        Permission.location,
      );

      if (locationPermissionStatus.isGranted) {
        print(7);
        return _retrieveCurrentLocationWhenPermissionGranted(
          lang: locationDataLang,
        );
      }
    }

    throw LocationPermissionIsNotGrantedLocationException();
  }

  Future<Location> _retrieveCurrentLocationWhenPermissionGranted({
    required String lang,
  }) async {
    final LatLng latlng = await _locationService.getCurrentPosition();

    final Location location =
        await _locationRepository.retrieveLocationByCoordinates(
      latLng: latlng,
      returnedLocationType: LocationType.currentLocation,
      lang: lang,
    );

    return location;
  }
}
