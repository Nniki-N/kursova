import 'package:geolocator/geolocator.dart';
import 'package:kursova/core/errors/location_exception.dart';
import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/enums/location_type.dart';
import 'package:kursova/domain/repositories/location_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class RetrieveCurrentLocationUseCase {
  RetrieveCurrentLocationUseCase({
    required LocationRepository locationRepository,
  }) : _locationRepository = locationRepository;

  final LocationRepository _locationRepository;

  Future<Location> execute({
    required String locationDataLang,
    bool startRetrievingLocationsFromFirstPoint = false,
  }) async {
    if (startRetrievingLocationsFromFirstPoint) {
      _locationRepository.resetRepository();
    }

    PermissionStatus locationPermissionStatus =
        await Permission.location.request();

    /// Retrieve current location only in case the location permission is granted.
    if (locationPermissionStatus.isGranted) {
      return _retrieveCurrentLocationWhenPermissionGranted(
        lang: locationDataLang,
      );
    } else if (locationPermissionStatus.isPermanentlyDenied) {
      await openAppSettings();

      locationPermissionStatus = await Permission.location.request();

      if (locationPermissionStatus.isGranted) {
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
    final currentPostion = await Geolocator.getCurrentPosition();

    return _locationRepository.retrieveLocationByCoordinates(
      latLng: LatLng(
        currentPostion.latitude,
        currentPostion.longitude,
      ),
      returnedLocationType: LocationType.currentLocation,
      lang: lang,
    );
  }
}
