import 'package:kursova/core/errors/location_exception.dart';
import 'package:kursova/core/services/location_service.dart';
import 'package:kursova/core/services/permission_service.dart';
import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/repositories/location_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

/// Use case that is used for retrieving current location via comunication with device location services and [LocationRepository].
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

  /// Requests permission for using location services and uses current position of device to retrieve data about location base on the current position.
  /// 
  /// [locationDataLang] represents language of response data. It has to be language code only.
  /// 
  /// [startRetrievingLocationsFromFirstPoint] resets nameless points count.
  /// 
  /// Any exception that can occur inherit [LocationException].
  /// 
  /// Throws [LocationPermissionIsNotGrantedLocationException] if user denies location permission.
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

  /// Retrieves current position of device and requests location data based on the curren position.
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
