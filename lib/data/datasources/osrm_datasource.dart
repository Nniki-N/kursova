import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kursova/core/errors/osrm_exception.dart';
import 'package:kursova/data/models/osrm_route_response_model.dart';
import 'package:kursova/data/models/osrm_trip_response_model.dart';
import 'package:latlong2/latlong.dart';

/// For use of the free OSRM API
class OsrmDatasource {
  const OsrmDatasource({
    required http.Client client,
  }) : _client = client;

  final http.Client _client;

  final String _host = 'router.project-osrm.org';
  final String _carRoutingServicePath = '/route/v1/car/';
  final String _carTripServicePath = '/trip/v1/car/';

  /// Retrieves routes for vehicle between locations in order they are provided.
  ///
  /// Returns [OsrmRouteResponseModel] if request was successful.
  ///
  /// Throws [RouteRequestOsrmException] if request failed and [RouteRetrievingOsrmException] if any other error occurs.
  Future<OsrmRouteResponseModel> retrieveRouteBetweenLocations({
    required List<LatLng> orderedCoordinates,
  }) async {
    try {
      final String formattedCoordinatesString = _formatCoordinatesInString(
        locations: orderedCoordinates,
      );

      final String unencodedPath =
          '$_carRoutingServicePath$formattedCoordinatesString';

      final Uri uri = Uri.http(
        _host,
        unencodedPath,
        {
          'overview': 'full',
        },
      );

      final http.Response response = await _client.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataAsJson = json.decode(response.body);

        return OsrmRouteResponseModel.fromJson(dataAsJson);
      } else {
        throw RouteRequestOsrmException(
          messageDetails: 'response status code = ${response.statusCode}',
          stackTrace: StackTrace.current,
        );
      }
    } on OsrmException {
      rethrow;
    } catch (exception, stackTrace) {
      throw RouteRetrievingOsrmException(
        messageDetails: exception.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  /// Retrieves trip for vehicle between locations.
  ///
  /// Set [withStartPoint] to true if first location in list has to be start of the trip. Set [withEndPoint] to true if last location in list has to be end of the trip.
  ///
  /// Set [roundTrip] to true if trip has to be cycled.
  ///
  /// Returns [OsrmTripResponseModel] if request was successful.
  ///
  /// Throws [TripRequestOsrmException] if request failed and [TripRetrievingOsrmException] if any other error occurs.
  Future<OsrmTripResponseModel> retrieveTripRouteBetweenLocations({
    required List<LatLng> coordinates,
    required bool withStartPoint,
    required bool withEndPoint,
    required bool roundTrip,
  }) async {
    try {
      if (!withEndPoint && !withStartPoint && !roundTrip) {
        throw TripRequestParametersCombinationOsrmException(
          messageDetails:
              'withStartPoint = $withStartPoint, withEndPoint = $withEndPoint, roundTrip = $roundTrip',
          stackTrace: StackTrace.current,
        );
      }

      final String formattedCoordinatesString = _formatCoordinatesInString(
        locations: coordinates,
      );

      final String unencodedPath =
          '$_carTripServicePath$formattedCoordinatesString';

      final Uri uri = Uri.http(
        _host,
        unencodedPath,
        {
          'source': withStartPoint ? 'first' : 'any',
          'destination': withEndPoint ? 'last' : 'any',
          'roundtrip': roundTrip.toString(),
          'overview': 'full',
        },
      );

      final http.Response response = await _client.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataAsJson = json.decode(response.body);

        return OsrmTripResponseModel.fromJson(dataAsJson);
      } else {
        throw TripRequestOsrmException(
          messageDetails: 'response status code = ${response.statusCode}',
          stackTrace: StackTrace.current,
        );
      }
    } on OsrmException {
      rethrow;
    } catch (exception, stackTrace) {
      throw TripRetrievingOsrmException(
        messageDetails: exception.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  String _formatCoordinatesInString({
    required List<LatLng> locations,
  }) {
    String formattedCoordinatesString = '';

    for (int i = 0; i < locations.length; i++) {
      formattedCoordinatesString +=
          '${locations[i].longitude},${locations[i].latitude}';

      if (i != locations.length - 1) {
        formattedCoordinatesString += ';';
      }
    }

    return formattedCoordinatesString;
  }
}
