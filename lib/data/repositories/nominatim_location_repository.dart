import 'package:easy_localization/easy_localization.dart';
import 'package:kursova/core/errors/location_exception.dart';
import 'package:kursova/core/errors/nominatim_exception.dart';
import 'package:kursova/data/datasources/nominatim_datasource.dart';
import 'package:kursova/data/models/nominatim_response_model.dart';
import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/repositories/location_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
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
  /// Returns [Location] with retrieved data if request was successful and otherwise [Location] with
  /// already provided data.
  ///
  /// The primaryLocationName of location is city/town if place if populated or generated name like 'Point 3'.
  /// The uid is always randomly generated.
  @override
  Future<Location> retrieveLocationByCoordinates({
    required LatLng latLng,
    LocationType returnedLocationType = LocationType.locationOnMap,
    String lang = 'en',
  }) async {
    try {
      final NominatimResponseModel nominatimResponce =
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
        locationType: returnedLocationType,
      );
    } on NominatimException catch (exception) {
      _logger.e(
        'NominatimLocationRepository ${exception.message}',
        error: exception,
        stackTrace: exception.stackTrace,
      );

      return Location(
        uid: const Uuid().v4(),
        primaryLocationName: _generatedName,
        detailedLocationAddress: null,
        coordinate: latLng,
        locationType: returnedLocationType,
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
        locationType: returnedLocationType,
      );
    }
  }

  /// Retrieves location data by address.
  ///
  /// Returns [Location] with retrieved data if request was successful, otherwise throws [RetrievingLocationByAddressLocationException].
  ///
  /// The primaryLocationName of location is city/town if place if populated or generated name like 'Point 3'.
  /// The uid is always randomly generated.
  @override
  Future<Location> retrieveLocationByAddress({
    required String address,
    LocationType returnedLocationType = LocationType.locationFromSearch,
    String lang = 'en',
  }) async {
    try {
      final NominatimResponseModel nominatimResponce =
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
    } on NominatimException catch (exception) {
      throw RetrievingLocationByAddressLocationException(
        messageDetails: exception.message,
        stackTrace: exception.stackTrace,
      );
    } catch (exception, stackTrace) {
      throw RetrievingLocationByAddressLocationException(
        messageDetails: exception.toString(),
        stackTrace: stackTrace,
      );
    }
  }
}
