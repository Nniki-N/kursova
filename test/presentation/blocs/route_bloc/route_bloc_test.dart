import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/entities/route.dart';
import 'package:kursova/domain/usecases/find_route_usecase.dart';
import 'package:kursova/presentation/blocs/route_bloc/Route_event.dart';
import 'package:kursova/presentation/blocs/route_bloc/route_bloc.dart';
import 'package:kursova/presentation/blocs/route_bloc/route_state.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';

class MockFindRouteUseCase extends Mock implements FindRouteUseCase {}

void main() {
  group(
    'RouteBloc ->',
    () {
      late RouteBloc routeBloc;
      late MockFindRouteUseCase mockFindRouteUseCase;
      late Location mockLocation;
      late Route mockRoute;

      setUp(() {
        mockFindRouteUseCase = MockFindRouteUseCase();
        routeBloc = RouteBloc(
          findRouteUseCase: mockFindRouteUseCase,
          logger: Logger(),
        );

        mockLocation = Location(
          uid: const Uuid().v4(),
          primaryLocationName: 'Test location',
          detailedLocationAddress: null,
          coordinate: const LatLng(50.444230104876326, 30.53701365624999),
          locationType: LocationType.locationOnMap,
        );

        mockRoute = Route(
          polylineRouteCoordinates: [],
          locations: [],
          distancesInMeters: [],
          durationsInSeconds: [],
          totalDistanceInMeters: 0,
          totalDurationsInSeconds: 0,
        );
      });

      tearDown(() async {
        await routeBloc.close();
      });

      test('initial state is RouteInitial', () {
        expect(routeBloc.state, isA<RouteInitial>());
      });

      group(
        'RouteFindRouteRequested',
        () {
          blocTest<RouteBloc, RouteState>(
            'should emit RouteLoaded after finding route',
            build: () => routeBloc,
            setUp: () {
              when(
                () => mockFindRouteUseCase.execute(
                  locations: List.filled(5, mockLocation),
                  cycledRoute: true,
                  withStartPoint: false,
                  withEndPoint: false,
                ),
              ).thenAnswer((_) async => mockRoute);
            },
            seed: () => RouteConfigurationUpdated(
              withStartPoint: false,
              withEndPoint: false,
              cycledRoute: true,
            ),
            act: (bloc) => bloc.add(
              RouteFindRouteRequested(locations: List.filled(5, mockLocation)),
            ),
            expect: () => [
              isA<RouteLoading>(),
              isA<RouteLoaded>(),
            ],
          );

          blocTest<RouteBloc, RouteState>(
            'should emit RouteLoadingRouteFaillure after finding route failure',
            build: () => routeBloc,
            setUp: () {
              when(
                () => mockFindRouteUseCase.execute(
                  locations: List.filled(5, mockLocation),
                  cycledRoute: true,
                  withStartPoint: false,
                  withEndPoint: false,
                ),
              ).thenThrow(Exception());
            },
            seed: () => RouteConfigurationUpdated(
              withStartPoint: false,
              withEndPoint: false,
              cycledRoute: true,
            ),
            act: (bloc) => bloc.add(
              RouteFindRouteRequested(locations: List.filled(5, mockLocation)),
            ),
            expect: () => [
              isA<RouteLoading>(),
              isA<RouteLoadingRouteFaillure>(),
            ],
          );

          blocTest<RouteBloc, RouteState>(
            'should do nothing when less then 2 locations were provided',
            build: () => routeBloc,
            setUp: () {
              when(
                () => mockFindRouteUseCase.execute(
                  locations: List.filled(1, mockLocation),
                  cycledRoute: true,
                  withStartPoint: false,
                  withEndPoint: false,
                ),
              ).thenThrow(Exception());
            },
            seed: () => RouteConfigurationUpdated(
              withStartPoint: false,
              withEndPoint: false,
              cycledRoute: true,
            ),
            act: (bloc) => bloc.add(
              RouteFindRouteRequested(locations: List.filled(1, mockLocation)),
            ),
            expect: () => [],
          );
        },
      );

      group(
        'RouteConfigureRouteRequested',
        () {
          blocTest<RouteBloc, RouteState>(
            'should emit RouteConfigurationUpdated with cycledRoute that equals true when event cycledRoute is true',
            build: () => routeBloc,
            act: (bloc) => bloc.add(
              const RouteConfigureRouteRequested(cycledRoute: true),
            ),
            expect: () => [
              isA<RouteConfigurationUpdated>().having(
                (state) => state.cycledRoute,
                'cycledRoute equals true',
                equals(true),
              ),
            ],
          );

          blocTest<RouteBloc, RouteState>(
            'should emit RouteConfigurationUpdated with withEndPoint that equals true when event withEndPoint is true',
            build: () => routeBloc,
            act: (bloc) => bloc.add(
              const RouteConfigureRouteRequested(withEndPoint: true),
            ),
            expect: () => [
              isA<RouteConfigurationUpdated>().having(
                (state) => state.withEndPoint,
                'withEndPoint equals true',
                equals(true),
              ),
            ],
          );

          blocTest<RouteBloc, RouteState>(
            'should emit RouteConfigurationUpdated with withStartPoint that equals true when event withStartPoint is true',
            build: () => routeBloc,
            act: (bloc) => bloc.add(
              const RouteConfigureRouteRequested(withStartPoint: true),
            ),
            expect: () => [
              isA<RouteConfigurationUpdated>().having(
                (state) => state.withStartPoint,
                'withStartPoint equals true',
                equals(true),
              ),
            ],
          );
        },
      );

      group(
        'RouteRemoveRouteRequested',
        () {
          blocTest<RouteBloc, RouteState>(
            'should emit RouteEmpty',
            build: () => routeBloc,
            act: (bloc) => bloc.add(const RouteRemoveRouteRequested()),
            expect: () => [isA<RouteEmpty>()],
          );
        },
      );
    },
  );
}
