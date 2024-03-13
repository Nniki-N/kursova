import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/data/repositories/nominatim_location_repository.dart';
import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/usecases/retrieve_location_by_coordinates_usecase.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';

class MockNominatimLocationRepository extends Mock
    implements NominatimLocationRepository {}

void main() {
  group(
    'RetrieveLocationByCoordinatesUseCase ->',
    () {
      late RetrieveLocationByCoordinatesUseCase
          retrieveLocationByCoordinatesUseCase;
      late MockNominatimLocationRepository mockNominatimLocationRepository;
      late LatLng mockCoordinate;
      late String mockLang;
      late Location mockLocation;

      setUp(() {
        mockNominatimLocationRepository = MockNominatimLocationRepository();
        retrieveLocationByCoordinatesUseCase =
            RetrieveLocationByCoordinatesUseCase(
          locationRepository: mockNominatimLocationRepository,
        );

        mockCoordinate = const LatLng(48.136691343766316, 11.577186091868162);
        mockLang = 'en';

        mockLocation = Location(
          uid: const Uuid().v4(),
          primaryLocationName: 'Test location 1',
          detailedLocationAddress: null,
          coordinate: mockCoordinate,
          locationType: LocationType.locationOnMap,
        );
      });

      group(
        'execute function',
        () {
          test(
            'should return Location',
            () async {
              when(
                () => mockNominatimLocationRepository
                    .retrieveLocationByCoordinates(
                  latLng: mockCoordinate,
                  lang: mockLang,
                ),
              ).thenAnswer((_) async {
                return mockLocation;
              });

              final location =
                  await retrieveLocationByCoordinatesUseCase.execute(
                latLng: mockCoordinate,
                locationDataLang: mockLang,
              );

              expect(location, isA<Location>());
            },
          );
        },
      );
    },
  );
}
