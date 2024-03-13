import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/core/errors/route_exception.dart';
import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/entities/route.dart';
import 'package:kursova/domain/repositories/route_repository.dart';
import 'package:kursova/domain/usecases/find_route_usecase.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';

class MockRouteRepository extends Mock implements RouteRepository {}

void main() {
  group(
    'FindRouteUseCase ->',
    () {
      late FindRouteUseCase findRouteUseCase;
      late MockRouteRepository mockRouteRepository;
      late List<Location> mockLocations;
      late Route mockRoute;

      setUp(() {
        mockRouteRepository = MockRouteRepository();
        findRouteUseCase = FindRouteUseCase(
          routeRepository: mockRouteRepository,
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

        mockRoute = Route(
          polylineRouteCoordinates: [],
          locations: [],
          distancesInMeters: [],
          durationsInSeconds: [],
          totalDistanceInMeters: 0,
          totalDurationsInSeconds: 0,
        );
      });

      group(
        'execute function',
        () {
          test(
            'should return Route that is NOT optimized if all route parameters are false',
            () async {
              when(
                () => mockRouteRepository
                    .retrieveNotOptimizedRouteBetweenLocations(
                  orderedLocations: mockLocations,
                ),
              ).thenAnswer((_) async {
                return mockRoute;
              });

              final route = await findRouteUseCase.execute(
                locations: mockLocations,
                cycledRoute: false,
                withStartPoint: false,
                withEndPoint: false,
              );

              expect(route, isA<Route>());
            },
          );

          test(
            'should pass exception if any exception in repository occurs',
            () async {
              when(
                () => mockRouteRepository
                    .retrieveNotOptimizedRouteBetweenLocations(
                  orderedLocations: mockLocations,
                ),
              ).thenAnswer((_) async {
                throw NotOptimizedRouteRetrievingRouteException();
              });

              expect(
                () => findRouteUseCase.execute(
                  locations: mockLocations,
                  cycledRoute: false,
                  withStartPoint: false,
                  withEndPoint: false,
                ),
                throwsA(isA<NotOptimizedRouteRetrievingRouteException>()),
              );
            },
          );

          test(
            'should return Route that is optimized if NOT all route parameters are false',
            () async {
              when(
                () =>
                    mockRouteRepository.retrieveOptimizedRouteBetweenLocations(
                  locations: mockLocations,
                  roundTrip: false,
                  withStartPoint: true,
                  withEndPoint: true,
                ),
              ).thenAnswer((_) async {
                return mockRoute;
              });

              final route = await findRouteUseCase.execute(
                locations: mockLocations,
                cycledRoute: false,
                withStartPoint: true,
                withEndPoint: true,
              );

              expect(route, isA<Route>());
            },
          );
        },
      );
    },
  );
}
