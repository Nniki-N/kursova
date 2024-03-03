import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kursova/core/errors/nominatim_exception.dart';
import 'package:kursova/data/datasources/nominatim_datasource.dart';
import 'package:kursova/data/models/nominatim_response.dart';
import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/enums/location_type.dart';
import 'package:kursova/domain/repositories/location_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class NominatimLocationRepository extends LocationRepository {
  NominatimLocationRepository({
    required NominatimDatasouce nominatimDatasouce,
    required Logger logger,
  })  : _nominatimDatasouce = nominatimDatasouce,
        _logger = logger;

  final NominatimDatasouce _nominatimDatasouce;
  final Logger _logger;

  static int _namelessLocationsCount = 0;

  // String get _generatedName => 'Point ${++_namelessLocationsCount}';
  String get _generatedName => 'point'.tr(args: [
        (++_namelessLocationsCount).toString(),
      ]);

  /// Resets whole repository saved data. This is recomended to do start generation of unnamed locations from the beggining.
  @override
  void resetRepository() {
    _namelessLocationsCount = 0;
  }

  /// Retrieves location data by coordinates.
  ///
  /// Returns [Location] with retrieved data if request was successful and [Location] with
  /// alreaady provided data otherwise.
  ///
  /// The primaryLocationName of location is city/town if place if populated or generated name like 'Point 3'.
  /// The uid is always randomly generated.
  @override
  Future<Location> retrieveLocationByCoordinates({
    required LatLng latLng,
    String lang = 'en',
  }) async {
    try {
      final NominatimResponse nominatimResponce =
          await _nominatimDatasouce.retrieveAddressDataByCoordinates(
        latitude: latLng.latitude,
        longitude: latLng.longitude,
        lang: lang,
      );

      final String addressName = nominatimResponce.city ?? _generatedName;

      String? detailedLocationAddress;

      if (nominatimResponce.road != null) {
        detailedLocationAddress =
            '${nominatimResponce.road}${nominatimResponce.houseNumber != null ? ' ${nominatimResponce.houseNumber}' : ''}';
      } else {
        detailedLocationAddress = nominatimResponce.neighbourhood;
      }

      return Location(
        uid: const Uuid().v4(),
        primaryLocationName: addressName,
        detailedLocationAddress: detailedLocationAddress,
        coordinate: latLng,
        locationType: LocationType.locationOnMap,
      );
    } on NominatimException catch (exception, stackTrace) {
      _logger.e(
        'NominatimLocationRepository ${exception.message}',
        error: exception,
        stackTrace: stackTrace,
      );

      return Location(
        uid: const Uuid().v4(),
        primaryLocationName: _generatedName,
        detailedLocationAddress: null,
        coordinate: latLng,
        locationType: LocationType.locationOnMap,
      );
    } catch (exception, stackTrace) {
      _logger.e(
        'NominatimLocationRepository ${exception.toString()}',
        error: exception,
        stackTrace: stackTrace,
      );

      return Location(
        uid: const Uuid().v4(),
        primaryLocationName: _generatedName,
        detailedLocationAddress: null,
        coordinate: latLng,
        locationType: LocationType.locationOnMap,
      );
    }
  }

  /// Retrieves current location data.
  ///
  /// Returns [Location] if request was successful and null if not.
  ///
  /// The primaryLocationName of location is city/town if place if populated and 'Current location' otherwise.
  /// The uid is always randomly generated.
  @override
  Future<Location?> retrieveCurrentLocation({
    String lang = 'en',
  }) async {
    try {
      PermissionStatus locationPermissionStatus =
          await Permission.location.request();

      /// Retrieve current location only in case the location permission is granted.
      if (locationPermissionStatus.isGranted) {
        return await _retrieveCurrentLocationWhenPermissionGranted(
          lang: lang,
        );
      } else if (locationPermissionStatus.isPermanentlyDenied) {
        await openAppSettings();

        locationPermissionStatus = await Permission.location.request();

        if (locationPermissionStatus.isGranted) {
          return await _retrieveCurrentLocationWhenPermissionGranted(
            lang: lang,
          );
        }
      }

      return null;
    } on NominatimException catch (exception, stackTrace) {
      _logger.e(
        'NominatimLocationRepository ${exception.message}',
        error: exception,
        stackTrace: stackTrace,
      );

      return null;
    } catch (exception, stackTrace) {
      _logger.e(
        'NominatimLocationRepository ${exception.toString()}',
        error: exception,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  Future<Location> _retrieveCurrentLocationWhenPermissionGranted({
    String lang = 'en',
  }) async {
    final currentPostion = await Geolocator.getCurrentPosition();

    final NominatimResponse nominatimResponce =
        await _nominatimDatasouce.retrieveAddressDataByCoordinates(
      latitude: currentPostion.latitude,
      longitude: currentPostion.longitude,
      lang: lang,
    );

    final String addressName = nominatimResponce.city ?? 'Current location';

    String? detailedLocationAddress;

    if (nominatimResponce.road != null) {
      detailedLocationAddress =
          '${nominatimResponce.road}${nominatimResponce.houseNumber != null ? ' ${nominatimResponce.houseNumber}' : ''}';
    } else {
      detailedLocationAddress = nominatimResponce.neighbourhood;
    }

    return Location(
      uid: const Uuid().v4(),
      primaryLocationName: addressName,
      detailedLocationAddress: detailedLocationAddress,
      coordinate: LatLng(currentPostion.latitude, currentPostion.longitude),
      locationType: LocationType.currentLocation,
    );
  }

  /// Retrieves location data by address.
  ///
  /// Returns [Location] if request was successful and null if not.
  ///
  /// The primaryLocationName of location is city/town if place if populated or generated name like 'Point 3'.
  /// The uid is always randomly generated.
  @override
  Future<Location?> retrieveLocationByAddress({
    required String address,
    String lang = 'en',
  }) async {
    try {
      final NominatimResponse nominatimResponce =
          await _nominatimDatasouce.retrieveAddressDataByAdress(
        address: address,
        lang: lang,
      );

      final String addressName = nominatimResponce.city ?? _generatedName;

      String? detailedLocationAddress;

      if (nominatimResponce.road != null) {
        detailedLocationAddress =
            '${nominatimResponce.road}${nominatimResponce.houseNumber != null ? ' ${nominatimResponce.houseNumber}' : ''}';
      } else {
        detailedLocationAddress = nominatimResponce.neighbourhood;
      }

      return Location(
        uid: const Uuid().v4(),
        primaryLocationName: addressName,
        detailedLocationAddress: detailedLocationAddress,
        coordinate: LatLng(
          nominatimResponce.latitude,
          nominatimResponce.longitude,
        ),
        locationType: LocationType.locationFromSearch,
      );
    } on NominatimException catch (exception, stackTrace) {
      _logger.e(
        'NominatimLocationRepository ${exception.message}',
        error: exception,
        stackTrace: stackTrace,
      );

      return null;
    } catch (exception, stackTrace) {
      _logger.e(
        'NominatimLocationRepository ${exception.toString()}',
        error: exception,
        stackTrace: stackTrace,
      );

      return null;
    }
  }
}
