import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kursova/core/errors/nominatim_exception.dart';
import 'package:kursova/data/models/nominatim_response_model.dart';

/// For use of the free Nominatim API
class NominatimDatasouce {
  const NominatimDatasouce({
    required http.Client client,
  }) : _client = client;

  final http.Client _client;

  final String _host = 'nominatim.openstreetmap.org';
  final String _reverseServicePath = '/reverse';
  final String _searchServicePath = '/search';

  /// Retrieves address data by provided coordinates.
  ///
  /// Returns [NominatimResponseModel] if request was successful.
  ///
  /// Throws [AddressDataRequestByCoordinatesNominatimException] if request failed and [RetrievingAddressDataByCoordinatesNominatimException] if any other error occurs.
  Future<NominatimResponseModel> retrieveAddressDataByCoordinates({
    required double latitude,
    required double longitude,
    String lang = 'en',
  }) async {
    try {
      final uri = Uri.http(
        _host,
        _reverseServicePath,
        {
          'lat': latitude.toString(),
          'lon': longitude.toString(),
          'format': 'jsonv2',
          'accept-language': lang,
        },
      );

      final http.Response response = await _client.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataAsJson = json.decode(response.body);

        return NominatimResponseModel(
          city: dataAsJson['address']['city'] ?? dataAsJson['address']['town'],
          neighbourhood: dataAsJson['address']['neighbourhood'],
          road: dataAsJson['address']['road'],
          houseNumber: dataAsJson['address']['house_number'],
          countryCode: dataAsJson['address']['country_code'],
          latitude: latitude,
          longitude: longitude,
        );
      } else {
        throw AddressDataRequestByCoordinatesNominatimException(
          messageDetails: 'response status code = ${response.statusCode}',
          stackTrace: StackTrace.current,
        );
      }
    } on NominatimException {
      rethrow;
    } catch (exception, stackTrace) {
      throw RetrievingAddressDataByCoordinatesNominatimException(
        messageDetails: exception.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  /// Retrieves address data by provided coordinates.
  ///
  /// Returns [NominatimResponseModel] if request was successful.
  ///
  /// Throws [AddressDataRequestByAddressNominatimException] if request failed, [EmptyAddressDataResponseNominatimException] if address data response is empyt
  /// and [RetrievingAddressDataByAddressNominatimException] if any other error occurs.
  Future<NominatimResponseModel> retrieveAddressDataByAdress({
    required String address,
    String lang = 'en',
  }) async {
    try {
      final uri = Uri.http(
        _host,
        _searchServicePath,
        {
          'addressdetails': '1',
          'q': address,
          'format': 'jsonv2',
          'limit': '1',
          'accept-language': lang,
        },
      );

      final http.Response response = await _client.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> dataAsJsonList = json.decode(response.body);

        if (dataAsJsonList.isEmpty) {
          throw EmptyAddressDataResponseNominatimException(
            stackTrace: StackTrace.current,
          );
        }

        final Map<String, dynamic> dataAsJson = dataAsJsonList.first;

        return NominatimResponseModel(
          city: dataAsJson['address']['city'] ?? dataAsJson['address']['town'],
          neighbourhood: dataAsJson['address']['neighbourhood'],
          road: dataAsJson['address']['road'],
          houseNumber: dataAsJson['address']['house_number'],
          countryCode: dataAsJson['address']['country_code'],
          latitude: double.parse(dataAsJson['lat']),
          longitude: double.parse(dataAsJson['lon']),
        );
      } else {
        throw AddressDataRequestByAddressNominatimException(
          messageDetails: 'response status code = ${response.statusCode}',
          stackTrace: StackTrace.current,
        );
      }
    } on NominatimException {
      rethrow;
    } catch (exception, stackTrace) {
      throw RetrievingAddressDataByAddressNominatimException(
        messageDetails: exception.toString(),
        stackTrace: stackTrace,
      );
    }
  }
}
