import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/core/errors/osrm_exception.dart';
import 'package:kursova/core/errors/route_exception.dart';
import 'package:kursova/data/datasources/osrm_datasource.dart';
import 'package:kursova/data/models/osrm_route_response_model.dart';
import 'package:kursova/data/models/osrm_trip_response_model.dart';
import 'package:kursova/data/repositories/osrm_route_repository.dart';
import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/entities/route.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';

import '../../fixtures/fixture_reader.dart';

class MockOsrmDatasource extends Mock implements OsrmDatasource {}

void main() {
  group(
    'OsrmRouteRepository ->',
    () {
      late OsrmRouteRepository osrmRouteRepository;
      late MockOsrmDatasource mockOsrmDatasource;
      late List<Location> mockLocations;
      late OsrmRouteResponseModel mockOsrmRouteResponseModel;
      late OsrmTripResponseModel mockOsrmTripResponseModel;
      late OsrmRouteResponseModel mockEmptyRouteListOsrmRouteResponseModel;
      late OsrmTripResponseModel mockEmptyTripListOsrmTripResponseModel;

      setUp(() {
        mockOsrmDatasource = MockOsrmDatasource();
        osrmRouteRepository = OsrmRouteRepository(
          osrmDatasource: mockOsrmDatasource,
        );

        mockLocations = [
          Location(
            uid: const Uuid().v4(),
            primaryLocationName: 'Test location 1',
            detailedLocationAddress: null,
            coordinate: const LatLng(50.444230104876326, 30.53701365624999),
            locationType: LocationType.locationOnMap,
          ),
          Location(
            uid: const Uuid().v4(),
            primaryLocationName: 'Test location 2',
            detailedLocationAddress: null,
            coordinate: const LatLng(50.21981506761894, 28.669337874999986),
            locationType: LocationType.locationOnMap,
          ),
          Location(
            uid: const Uuid().v4(),
            primaryLocationName: 'Test location 3',
            detailedLocationAddress: null,
            coordinate: const LatLng(50.597900952059504, 26.27431834374999),
            locationType: LocationType.locationOnMap,
          ),
        ];

        mockOsrmRouteResponseModel = OsrmRouteResponseModel.fromJson(
          json.decode(fixture(fileName: 'osrm_route.json')),
        );
        mockOsrmTripResponseModel = OsrmTripResponseModel.fromJson(
          json.decode(fixture(fileName: 'osrm_trip.json')),
        );
        mockEmptyRouteListOsrmRouteResponseModel =
            OsrmRouteResponseModel.fromJson(
          json.decode(fixture(fileName: 'empty_route_list_osrm_route.json')),
        );
        mockEmptyTripListOsrmTripResponseModel = OsrmTripResponseModel.fromJson(
          json.decode(fixture(fileName: 'empty_trip_list_osrm_trip.json')),
        );
      });

      group(
        'retrieveNotOptimizedRouteBetweenLocations function',
        () {
          test(
            'should return Route when request to datasource is successful',
            () async {
              when(
                () {
                  return mockOsrmDatasource.retrieveRouteBetweenLocations(
                    orderedCoordinates: mockLocations
                        .map((location) => location.coordinate)
                        .toList(),
                  );
                },
              ).thenAnswer((_) async {
                return mockOsrmRouteResponseModel;
              });

              final route = await osrmRouteRepository
                  .retrieveNotOptimizedRouteBetweenLocations(
                orderedLocations: mockLocations,
              );

              expect(route, isA<Route>());
            },
          );

          test(
            'should throw NotOptimizedRouteRetrievingRouteException when request to datasource is NOT successful',
            () async {
              when(
                () {
                  return mockOsrmDatasource.retrieveRouteBetweenLocations(
                    orderedCoordinates: mockLocations
                        .map((location) => location.coordinate)
                        .toList(),
                  );
                },
              ).thenAnswer((_) async {
                throw RouteRetrievingOsrmException();
              });

              final route =
                  osrmRouteRepository.retrieveNotOptimizedRouteBetweenLocations(
                orderedLocations: mockLocations,
              );

              expect(route,
                  throwsA(isA<NotOptimizedRouteRetrievingRouteException>()));
            },
          );

          test(
            'should throw LocationsLackRouteException when no locations were provided',
            () async {
              expect(
                () => osrmRouteRepository
                    .retrieveNotOptimizedRouteBetweenLocations(
                  orderedLocations: [],
                ),
                throwsA(isA<LocationsLackRouteException>()),
              );
            },
          );

          test(
            'should throw EmptyRoutesResponseRouteException when response from datasource has empy route list',
            () async {
              when(
                () {
                  return mockOsrmDatasource.retrieveRouteBetweenLocations(
                    orderedCoordinates: mockLocations
                        .map((location) => location.coordinate)
                        .toList(),
                  );
                },
              ).thenAnswer((_) async {
                return mockEmptyRouteListOsrmRouteResponseModel;
              });

              final route =
                  osrmRouteRepository.retrieveNotOptimizedRouteBetweenLocations(
                orderedLocations: mockLocations,
              );

              expect(route, throwsA(isA<EmptyRoutesResponseRouteException>()));
            },
          );
        },
      );

      group(
        'retrieveOptimizedRouteBetweenLocations function',
        () {
          test(
            'should return Route when request to datasource is successful',
            () async {
              when(
                () {
                  return mockOsrmDatasource.retrieveTripRouteBetweenLocations(
                    coordinates: mockLocations
                        .map((location) => location.coordinate)
                        .toList(),
                    withEndPoint: true,
                    withStartPoint: true,
                    roundTrip: false,
                  );
                },
              ).thenAnswer((_) async {
                return mockOsrmTripResponseModel;
              });

              final route = await osrmRouteRepository
                  .retrieveOptimizedRouteBetweenLocations(
                locations: mockLocations,
                withEndPoint: true,
                withStartPoint: true,
                roundTrip: false,
              );

              expect(route, isA<Route>());
            },
          );

          test(
            'should throw OptimizedRouteRetrievingRouteException when request to datasource is NOT successful',
            () async {
              when(
                () {
                  return mockOsrmDatasource.retrieveTripRouteBetweenLocations(
                    coordinates: mockLocations
                        .map((location) => location.coordinate)
                        .toList(),
                    withEndPoint: true,
                    withStartPoint: true,
                    roundTrip: false,
                  );
                },
              ).thenAnswer((_) async {
                throw TripRetrievingOsrmException();
              });

              final route =
                  osrmRouteRepository.retrieveOptimizedRouteBetweenLocations(
                locations: mockLocations,
                withEndPoint: true,
                withStartPoint: true,
                roundTrip: false,
              );

              expect(route,
                  throwsA(isA<OptimizedRouteRetrievingRouteException>()));
            },
          );

          test(
            'should throw LocationsLackRouteException when no locations were provided',
            () async {
              expect(
                () =>
                    osrmRouteRepository.retrieveOptimizedRouteBetweenLocations(
                  locations: [],
                  withEndPoint: true,
                  withStartPoint: true,
                  roundTrip: false,
                ),
                throwsA(isA<LocationsLackRouteException>()),
              );
            },
          );

          test(
            'should throw EmptyRoutesResponseRouteException when response from datasource has empy route list',
            () async {
              when(
                () {
                  return mockOsrmDatasource.retrieveTripRouteBetweenLocations(
                    coordinates: mockLocations
                        .map((location) => location.coordinate)
                        .toList(),
                    withEndPoint: true,
                    withStartPoint: true,
                    roundTrip: false,
                  );
                },
              ).thenAnswer((_) async {
                return mockEmptyTripListOsrmTripResponseModel;
              });

              final route =
                  osrmRouteRepository.retrieveOptimizedRouteBetweenLocations(
                locations: mockLocations,
                withEndPoint: true,
                withStartPoint: true,
                roundTrip: false,
              );

              expect(route, throwsA(isA<EmptyRoutesResponseRouteException>()));
            },
          );
        },
      );
    },
  );
}
