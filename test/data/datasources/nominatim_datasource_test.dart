import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:kursova/core/errors/nominatim_exception.dart';
import 'package:kursova/data/datasources/nominatim_datasource.dart';
import 'package:kursova/data/models/nominatim_response_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/fixture_reader.dart';

class MockHTTPClient extends Mock implements Client {}

void main() {
  group(
    'NominatimDatasouce ->',
    () {
      late NominatimDatasouce nominatimDatasouce;
      late MockHTTPClient mockHTTPClient;
      late LatLng mockCoordinate;
      late String mockAddress;
      late String mockLang;
      late Uri mockReverseGeocodingByCoordinatesUri;
      late Uri mockReverseGeocodingByAddressUri;

      setUp(() {
        mockHTTPClient = MockHTTPClient();
        nominatimDatasouce = NominatimDatasouce(client: mockHTTPClient);

        mockCoordinate = const LatLng(48.136691343766316, 11.577186091868162);
        mockAddress = 'Paris';
        mockLang = 'en';
        mockReverseGeocodingByCoordinatesUri = Uri.parse(
          'http://nominatim.openstreetmap.org/reverse?lat=${mockCoordinate.latitude}&lon=${mockCoordinate.longitude}&format=jsonv2&accept-language=$mockLang',
        );
        mockReverseGeocodingByAddressUri = Uri.parse(
          'http://nominatim.openstreetmap.org/search?addressdetails=1&q=$mockAddress&format=jsonv2&limit=1&accept-language=$mockLang',
        );
      });

      group(
        'retrieveAddressDataByCoordinates function',
        () {
          test(
            'should return NominatimResponseModel when response is 200',
            () async {
              when(
                () => mockHTTPClient.get(mockReverseGeocodingByCoordinatesUri),
              ).thenAnswer((_) async {
                return Response(
                  fixture(fileName: 'nominatim_by_coordinates.json'),
                  200,
                );
              });

              final nominatimResponseModel =
                  await nominatimDatasouce.retrieveAddressDataByCoordinates(
                latitude: mockCoordinate.latitude,
                longitude: mockCoordinate.longitude,
                lang: mockLang,
              );

              expect(nominatimResponseModel, isA<NominatimResponseModel>());
            },
          );

          test(
            'should throw AddressDataRequestByCoordinatesNominatimException when response is NOT 200',
            () async {
              when(
                () => mockHTTPClient.get(mockReverseGeocodingByCoordinatesUri),
              ).thenAnswer((_) async {
                return Response(
                  '{}',
                  400,
                );
              });

              final nominatimResponseModel =
                  nominatimDatasouce.retrieveAddressDataByCoordinates(
                latitude: mockCoordinate.latitude,
                longitude: mockCoordinate.longitude,
                lang: mockLang,
              );

              expect(
                nominatimResponseModel,
                throwsA(
                    isA<AddressDataRequestByCoordinatesNominatimException>()),
              );
            },
          );

          test(
            'should throw RetrievingAddressDataByCoordinatesNominatimException when any other exception occurs',
            () async {
              when(
                () => mockHTTPClient.get(mockReverseGeocodingByCoordinatesUri),
              ).thenAnswer((_) async {
                throw Exception();
              });

              final nominatimResponseModel =
                  nominatimDatasouce.retrieveAddressDataByCoordinates(
                latitude: mockCoordinate.latitude,
                longitude: mockCoordinate.longitude,
                lang: mockLang,
              );

              expect(
                nominatimResponseModel,
                throwsA(
                  isA<RetrievingAddressDataByCoordinatesNominatimException>(),
                ),
              );
            },
          );
        },
      );

      group(
        'retrieveAddressDataByAdress function',
        () {
          test(
            'should return NominatimResponseModel when response is 200',
            () async {
              when(
                () => mockHTTPClient.get(mockReverseGeocodingByAddressUri),
              ).thenAnswer((_) async {
                return Response(
                  fixture(fileName: 'nominatim_by_address.json'),
                  200,
                );
              });

              final nominatimResponseModel =
                  await nominatimDatasouce.retrieveAddressDataByAdress(
                address: mockAddress,
                lang: mockLang,
              );

              expect(nominatimResponseModel, isA<NominatimResponseModel>());
            },
          );

          test(
            'should throw AddressDataRequestByAddressNominatimException when response is NOT 200',
            () async {
              when(
                () => mockHTTPClient.get(mockReverseGeocodingByAddressUri),
              ).thenAnswer((_) async {
                return Response(
                  '[]',
                  400,
                );
              });

              final nominatimResponseModel =
                  nominatimDatasouce.retrieveAddressDataByAdress(
                address: mockAddress,
                lang: mockLang,
              );

              expect(
                nominatimResponseModel,
                throwsA(isA<AddressDataRequestByAddressNominatimException>()),
              );
            },
          );

          test(
            'should throw EmptyAddressDataResponseNominatimException when response is 200 but empty',
            () async {
              when(
                () => mockHTTPClient.get(mockReverseGeocodingByAddressUri),
              ).thenAnswer((_) async {
                return Response(
                  '[]',
                  200,
                );
              });

              final nominatimResponseModel =
                  nominatimDatasouce.retrieveAddressDataByAdress(
                address: mockAddress,
                lang: mockLang,
              );

              expect(
                nominatimResponseModel,
                throwsA(isA<EmptyAddressDataResponseNominatimException>()),
              );
            },
          );

          test(
            'should throw RetrievingAddressDataByAddressNominatimException when any other exception occurs',
            () async {
              when(
                () => mockHTTPClient.get(mockReverseGeocodingByAddressUri),
              ).thenAnswer((_) async {
                throw Exception();
              });

              final nominatimResponseModel =
                  nominatimDatasouce.retrieveAddressDataByAdress(
                address: mockAddress,
                lang: mockLang,
              );

              expect(
                nominatimResponseModel,
                throwsA(
                  isA<RetrievingAddressDataByAddressNominatimException>(),
                ),
              );
            },
          );
        },
      );
    },
  );
}
