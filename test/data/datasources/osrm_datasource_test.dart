import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:kursova/core/errors/osrm_exception.dart';
import 'package:kursova/data/datasources/osrm_datasource.dart';
import 'package:kursova/data/models/osrm_route_response_model.dart';
import 'package:kursova/data/models/osrm_trip_response_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/fixture_reader.dart';

class MockHTTPClient extends Mock implements Client {}

void main() {
  group(
    'OsrmDatasource ->',
    () {
      late OsrmDatasource osrmDatasource;
      late MockHTTPClient mockHTTPClient;
      late List<LatLng> mockCoordinates;
      late Uri mockRouteUri;
      late Uri mockTripUri;

      setUp(() {
        mockHTTPClient = MockHTTPClient();
        osrmDatasource = OsrmDatasource(client: mockHTTPClient);

        mockCoordinates = const [
          LatLng(50.444230104876326, 30.53701365624999),
          LatLng(50.21981506761894, 28.6693378749999869),
          LatLng(50.597900952059504, 26.27431834374999),
        ];
        mockRouteUri = Uri.parse(
          'http://router.project-osrm.org/route/v1/car/${mockCoordinates[0].longitude},${mockCoordinates[0].latitude};${mockCoordinates[1].longitude},${mockCoordinates[1].latitude};${mockCoordinates[2].longitude},${mockCoordinates[2].latitude}?overview=full',
        );
        mockTripUri = Uri.parse(
          'http://router.project-osrm.org/trip/v1/car/${mockCoordinates[0].longitude},${mockCoordinates[0].latitude};${mockCoordinates[1].longitude},${mockCoordinates[1].latitude};${mockCoordinates[2].longitude},${mockCoordinates[2].latitude}?source=first&destination=last&roundtrip=false&overview=full',
        );
      });

      group(
        'retrieveRouteBetweenLocations function',
        () {
          test(
            'should return OsrmRouteResponseModel when response is 200',
            () async {
              when(() => mockHTTPClient.get(mockRouteUri))
                  .thenAnswer((_) async {
                return Response(fixture(fileName: 'osrm_route.json'), 200);
              });

              final osrmRouteResponseModel =
                  await osrmDatasource.retrieveRouteBetweenLocations(
                orderedCoordinates: mockCoordinates,
              );

              expect(osrmRouteResponseModel, isA<OsrmRouteResponseModel>());
            },
          );

          test(
            'should throw RouteRequestOsrmException when response is NOT 200',
            () async {
              when(() => mockHTTPClient.get(mockRouteUri))
                  .thenAnswer((_) async {
                return Response('{}', 400);
              });

              final osrmRouteResponseModel =
                  osrmDatasource.retrieveRouteBetweenLocations(
                orderedCoordinates: mockCoordinates,
              );

              expect(
                osrmRouteResponseModel,
                throwsA(isA<RouteRequestOsrmException>()),
              );
            },
          );

          test(
            'should throw RouteRetrievingOsrmException when any other error occurs',
            () async {
              when(() => mockHTTPClient.get(mockRouteUri))
                  .thenAnswer((_) async {
                throw Exception();
              });

              final osrmRouteResponseModel =
                  osrmDatasource.retrieveRouteBetweenLocations(
                orderedCoordinates: mockCoordinates,
              );

              expect(
                osrmRouteResponseModel,
                throwsA(isA<RouteRetrievingOsrmException>()),
              );
            },
          );
        },
      );

      group(
        'retrieveTripRouteBetweenLocations function',
        () {
          test(
            'should return OsrmTripResponseModel when response is 200',
            () async {
              when(() => mockHTTPClient.get(mockTripUri)).thenAnswer((_) async {
                return Response(fixture(fileName: 'osrm_trip.json'), 200);
              });

              final osrmRouteResponseModel =
                  await osrmDatasource.retrieveTripRouteBetweenLocations(
                coordinates: mockCoordinates,
                withStartPoint: true,
                withEndPoint: true,
                roundTrip: false,
              );

              expect(osrmRouteResponseModel, isA<OsrmTripResponseModel>());
            },
          );

          test(
            'should throw TripRequestOsrmException when response is NOT 200',
            () async {
              when(() => mockHTTPClient.get(mockTripUri)).thenAnswer((_) async {
                return Response('{}', 400);
              });

              final osrmRouteResponseModel =
                  osrmDatasource.retrieveTripRouteBetweenLocations(
                coordinates: mockCoordinates,
                withStartPoint: true,
                withEndPoint: true,
                roundTrip: false,
              );

              expect(
                osrmRouteResponseModel,
                throwsA(isA<TripRequestOsrmException>()),
              );
            },
          );

          test(
            'should throw TripRetrievingOsrmException whenany other error occurs',
            () async {
              when(() => mockHTTPClient.get(mockTripUri)).thenAnswer((_) async {
                throw Exception();
              });

              final osrmRouteResponseModel =
                  osrmDatasource.retrieveTripRouteBetweenLocations(
                coordinates: mockCoordinates,
                withStartPoint: true,
                withEndPoint: true,
                roundTrip: false,
              );

              expect(
                osrmRouteResponseModel,
                throwsA(isA<TripRetrievingOsrmException>()),
              );
            },
          );

          test(
            'should throw TripRequestParametersCombinationOsrmException when all trip parameters are false',
            () async {
              expect(
                () => osrmDatasource.retrieveTripRouteBetweenLocations(
                  coordinates: mockCoordinates,
                  withStartPoint: false,
                  withEndPoint: false,
                  roundTrip: false,
                ),
                throwsA(isA<TripRequestParametersCombinationOsrmException>()),
              );
            },
          );
        },
      );
    },
  );
}
