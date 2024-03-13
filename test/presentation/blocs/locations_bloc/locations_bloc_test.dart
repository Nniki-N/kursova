import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/core/app_constants.dart';
import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/usecases/retrieve_current_location_usecase.dart';
import 'package:kursova/domain/usecases/retrieve_location_by_address.dart';
import 'package:kursova/domain/usecases/retrieve_location_by_coordinates_usecase.dart';
import 'package:kursova/presentation/blocs/locations_bloc/locations_bloc.dart';
import 'package:kursova/presentation/blocs/locations_bloc/locations_event.dart';
import 'package:kursova/presentation/blocs/locations_bloc/locations_state.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';

class MockRetrieveLocationByCoordinatesUseCase extends Mock
    implements RetrieveLocationByCoordinatesUseCase {}

class MockRetrieveCurrentLocationUseCase extends Mock
    implements RetrieveCurrentLocationUseCase {}

class MockRetrieveLocationByAddressUseCase extends Mock
    implements RetrieveLocationByAddressUseCase {}

void main() {
  group(
    'LocationsBloc ->',
    () {
      late LocationsBloc locationsBloc;
      late MockRetrieveLocationByCoordinatesUseCase
          mockRetrieveLocationByCoordinatesUseCase;
      late MockRetrieveCurrentLocationUseCase
          mockRetrieveCurrentLocationUseCase;
      late MockRetrieveLocationByAddressUseCase
          mockRetrieveLocationByAddressUseCase;
      late Location mockLocation;
      late String mockLang;
      late LatLng mockLatLng;
      late String mockAddress;

      setUp(() {
        mockRetrieveLocationByCoordinatesUseCase =
            MockRetrieveLocationByCoordinatesUseCase();
        mockRetrieveCurrentLocationUseCase =
            MockRetrieveCurrentLocationUseCase();
        mockRetrieveLocationByAddressUseCase =
            MockRetrieveLocationByAddressUseCase();

        locationsBloc = LocationsBloc(
          retrieveCurrentLocationUseCase: mockRetrieveCurrentLocationUseCase,
          retrieveLocationByAddresssUseCase:
              mockRetrieveLocationByAddressUseCase,
          retrieveLocationByCoordinatesUseCase:
              mockRetrieveLocationByCoordinatesUseCase,
          logger: Logger(),
        );

        mockLocation = Location(
          uid: const Uuid().v4(),
          primaryLocationName: 'Test location',
          detailedLocationAddress: null,
          coordinate: const LatLng(50.444230104876326, 30.53701365624999),
          locationType: LocationType.locationOnMap,
        );

        mockLatLng = const LatLng(48.136691343766316, 11.577186091868162);
        mockLang = 'en';
        mockAddress = 'Paris';
      });

      tearDown(() async {
        await locationsBloc.close();
      });

      test('initial state is LocationsEmpty', () {
        expect(locationsBloc.state, isA<LocationsEmpty>());
      });

      group(
        'LocationsAddNewLocationRequested',
        () {
          blocTest<LocationsBloc, LocationsState>(
            'should emit LocationsNotEmpty after location data retrieving',
            build: () => locationsBloc,
            setUp: () {
              when(
                () => mockRetrieveLocationByCoordinatesUseCase.execute(
                  latLng: mockLatLng,
                  locationDataLang: mockLang,
                  startRetrievingLocationsFromFirstPoint:
                      locationsBloc.state.locations.isEmpty,
                ),
              ).thenAnswer((invocation) async => mockLocation);
            },
            act: (bloc) => bloc.add(
              LocationsAddNewLocationRequested(
                latLng: mockLatLng,
                locationDataLang: mockLang,
              ),
            ),
            expect: () => [
              isA<LocationsAddingLocation>(),
              isA<LocationsNotEmpty>(),
            ],
          );

          blocTest<LocationsBloc, LocationsState>(
            'should emit LocationsAddingLocationFailure after location data retrieving failure',
            build: () => locationsBloc,
            setUp: () {
              when(
                () => mockRetrieveLocationByCoordinatesUseCase.execute(
                  latLng: mockLatLng,
                  locationDataLang: mockLang,
                  startRetrievingLocationsFromFirstPoint:
                      locationsBloc.state.locations.isEmpty,
                ),
              ).thenThrow(Exception());
            },
            act: (bloc) => bloc.add(
              LocationsAddNewLocationRequested(
                latLng: mockLatLng,
                locationDataLang: mockLang,
              ),
            ),
            expect: () => [
              isA<LocationsAddingLocation>(),
              isA<LocationsAddingLocationFailure>(),
            ],
          );

          blocTest<LocationsBloc, LocationsState>(
            'should emit LocationsReachedLocationsLimit when markers count reached limit and new marker can not be added',
            build: () => locationsBloc,
            seed: () => LocationsNotEmpty(
              locations: List.filled(
                AppConstants.locationsLimit,
                mockLocation,
              ),
            ),
            act: (bloc) => bloc.add(
              LocationsAddNewLocationRequested(
                latLng: mockLatLng,
                locationDataLang: mockLang,
              ),
            ),
            expect: () => [isA<LocationsReachedLocationsLimit>()],
          );

          blocTest<LocationsBloc, LocationsState>(
            'should emit LocationsReachedLocationsLimit when markers count is over limit and removes last markers from the list',
            build: () => locationsBloc,
            seed: () => LocationsNotEmpty(
              locations: List.filled(
                AppConstants.locationsLimit + 5,
                mockLocation,
              ),
            ),
            act: (bloc) => bloc.add(
              LocationsAddNewLocationRequested(
                latLng: mockLatLng,
                locationDataLang: mockLang,
              ),
            ),
            expect: () => [
              isA<LocationsReachedLocationsLimit>().having(
                (state) => state.locations.length,
                'locations length is AppConstants.locationsLimit',
                equals(AppConstants.locationsLimit),
              ),
            ],
          );
        },
      );

      group(
        'LocationsAddCurrentUserLocationRequested',
        () {
          blocTest<LocationsBloc, LocationsState>(
            'should emit LocationsNotEmpty after current location data retrieving',
            build: () => locationsBloc,
            setUp: () {
              when(
                () => mockRetrieveCurrentLocationUseCase.execute(
                  locationDataLang: mockLang,
                  startRetrievingLocationsFromFirstPoint:
                      locationsBloc.state.locations.isEmpty,
                ),
              ).thenAnswer((invocation) async => mockLocation);
            },
            act: (bloc) => bloc.add(
              LocationsAddCurrentUserLocationRequested(
                locationDataLang: mockLang,
              ),
            ),
            expect: () => [
              isA<LocationsAddingLocation>(),
              isA<LocationsNotEmpty>(),
            ],
          );

          blocTest<LocationsBloc, LocationsState>(
            'should emit LocationsAddingCurrentLocationFailure after current location data retrieving failure',
            build: () => locationsBloc,
            setUp: () {
              when(
                () => mockRetrieveCurrentLocationUseCase.execute(
                  locationDataLang: mockLang,
                  startRetrievingLocationsFromFirstPoint:
                      locationsBloc.state.locations.isEmpty,
                ),
              ).thenThrow(Exception());
            },
            act: (bloc) => bloc.add(
              LocationsAddCurrentUserLocationRequested(
                locationDataLang: mockLang,
              ),
            ),
            expect: () => [
              isA<LocationsAddingLocation>(),
              isA<LocationsAddingCurrentLocationFailure>(),
            ],
          );

          blocTest<LocationsBloc, LocationsState>(
            'should emit LocationsReachedCurrentLocationsLimit when current location is already in list',
            build: () => locationsBloc,
            seed: () => LocationsNotEmpty(
              locations: List.filled(
                1,
                mockLocation.copyWith(
                  locationType: LocationType.currentLocation,
                ),
              ),
            ),
            setUp: () {
              when(
                () => mockRetrieveCurrentLocationUseCase.execute(
                  locationDataLang: mockLang,
                  startRetrievingLocationsFromFirstPoint:
                      locationsBloc.state.locations.isEmpty,
                ),
              ).thenThrow(Exception());
            },
            act: (bloc) => bloc.add(
              LocationsAddCurrentUserLocationRequested(
                locationDataLang: mockLang,
              ),
            ),
            expect: () => [
              isA<LocationsReachedCurrentLocationsLimit>(),
            ],
          );

          blocTest<LocationsBloc, LocationsState>(
            'should emit LocationsReachedLocationsLimit when markers count reached limit and new marker can not be added',
            build: () => locationsBloc,
            seed: () => LocationsNotEmpty(
              locations: List.filled(
                AppConstants.locationsLimit,
                mockLocation,
              ),
            ),
            act: (bloc) => bloc.add(
              LocationsAddCurrentUserLocationRequested(
                locationDataLang: mockLang,
              ),
            ),
            expect: () => [isA<LocationsReachedLocationsLimit>()],
          );

          blocTest<LocationsBloc, LocationsState>(
            'should emit LocationsReachedLocationsLimit when markers count is over limit and removes last markers from the list',
            build: () => locationsBloc,
            seed: () => LocationsNotEmpty(
              locations: List.filled(
                AppConstants.locationsLimit + 5,
                mockLocation,
              ),
            ),
            act: (bloc) => bloc.add(
              LocationsAddCurrentUserLocationRequested(
                locationDataLang: mockLang,
              ),
            ),
            expect: () => [
              isA<LocationsReachedLocationsLimit>().having(
                (state) => state.locations.length,
                'locations length is AppConstants.locationsLimit',
                equals(AppConstants.locationsLimit),
              ),
            ],
          );
        },
      );

      group(
        'LocationsAddLocationByAddressRequested',
        () {
          blocTest<LocationsBloc, LocationsState>(
            'should emit LocationsNotEmpty after location data retrieving by address',
            build: () => locationsBloc,
            setUp: () {
              when(
                () => mockRetrieveLocationByAddressUseCase.execute(
                  address: mockAddress,
                  locationDataLang: mockLang,
                  startRetrievingLocationsFromFirstPoint:
                      locationsBloc.state.locations.isEmpty,
                ),
              ).thenAnswer((invocation) async => mockLocation);
            },
            act: (bloc) => bloc.add(
              LocationsAddLocationByAddressRequested(
                address: mockAddress,
                locationDataLang: mockLang,
              ),
            ),
            expect: () => [
              isA<LocationsAddingLocation>(),
              isA<LocationsNotEmpty>(),
            ],
          );

          blocTest<LocationsBloc, LocationsState>(
            'should emit LocationsAddingCurrentLocationFailure after current location data retrieving by address failure',
            build: () => locationsBloc,
            setUp: () {
              when(
                () => mockRetrieveLocationByAddressUseCase.execute(
                  address: mockAddress,
                  locationDataLang: mockLang,
                  startRetrievingLocationsFromFirstPoint:
                      locationsBloc.state.locations.isEmpty,
                ),
              ).thenThrow(Exception());
            },
            act: (bloc) => bloc.add(
              LocationsAddLocationByAddressRequested(
                address: mockAddress,
                locationDataLang: mockLang,
              ),
            ),
            expect: () => [
              isA<LocationsAddingLocation>(),
              isA<LocationsAddingLocationFailure>(),
            ],
          );

          blocTest<LocationsBloc, LocationsState>(
            'should emit LocationsReachedLocationsLimit when markers count reached limit and new marker can not be added',
            build: () => locationsBloc,
            seed: () => LocationsNotEmpty(
              locations: List.filled(
                AppConstants.locationsLimit,
                mockLocation,
              ),
            ),
            act: (bloc) => bloc.add(
              LocationsAddLocationByAddressRequested(
                address: mockAddress,
                locationDataLang: mockLang,
              ),
            ),
            expect: () => [isA<LocationsReachedLocationsLimit>()],
          );

          blocTest<LocationsBloc, LocationsState>(
            'should emit LocationsReachedLocationsLimit when markers count is over limit and removes last markers from the list',
            build: () => locationsBloc,
            seed: () => LocationsNotEmpty(
              locations: List.filled(
                AppConstants.locationsLimit + 5,
                mockLocation,
              ),
            ),
            act: (bloc) => bloc.add(
              LocationsAddLocationByAddressRequested(
                address: mockAddress,
                locationDataLang: mockLang,
              ),
            ),
            expect: () => [
              isA<LocationsReachedLocationsLimit>().having(
                (state) => state.locations.length,
                'locations length is AppConstants.locationsLimit',
                equals(AppConstants.locationsLimit),
              ),
            ],
          );
        },
      );

      group(
        'LocationsRemoveLocationRequested',
        () {
          blocTest<LocationsBloc, LocationsState>(
            'should emit LocationsEmpty after moving one provided location iside list of locations',
            build: () => locationsBloc,
            seed: () => LocationsNotEmpty(
              locations: List.filled(
                1,
                mockLocation,
              ),
            ),
            act: (bloc) => bloc.add(
              LocationsRemoveLocationRequested(
                uid: mockLocation.uid,
              ),
            ),
            expect: () => [isA<LocationsNotEmpty>()],
          );
        },
      );

      group(
        'LocationsMoveOneLocationInOrderRequested',
        () {
          blocTest<LocationsBloc, LocationsState>(
            'should emit LocationsEmpty after moving one provided location iside list of locations',
            build: () => locationsBloc,
            seed: () => LocationsNotEmpty(
              locations: List.filled(
                5,
                mockLocation,
              ),
            ),
            act: (bloc) => bloc.add(
              const LocationsMoveOneLocationInOrderRequested(
                oldIndex: 2,
                newIndex: 1,
              ),
            ),
            expect: () => [isA<LocationsNotEmpty>()],
          );
        },
      );

      group(
        'LocationsClearLocationsRequested',
        () {
          blocTest<LocationsBloc, LocationsState>(
            'should emit LocationsEmpty',
            build: () => locationsBloc,
            act: (bloc) => bloc.add(
              const LocationsClearLocationsRequested(),
            ),
            expect: () => [isA<LocationsEmpty>()],
          );
        },
      );
    },
  );
}
