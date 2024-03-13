import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/core/errors/location_exception.dart';
import 'package:kursova/data/repositories/nominatim_location_repository.dart';
import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/usecases/retrieve_location_by_address.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';

class MockNominatimLocationRepository extends Mock
    implements NominatimLocationRepository {}

void main() {
  group(
    'RetrieveLocationByAddressUseCase ->',
    () {
      late RetrieveLocationByAddressUseCase retrieveLocationByAddressUseCase;
      late MockNominatimLocationRepository mockNominatimLocationRepository;
      late String mockAddress;
      late String mockLang;
      late Location mockLocation;

      setUp(() {
        mockNominatimLocationRepository = MockNominatimLocationRepository();
        retrieveLocationByAddressUseCase = RetrieveLocationByAddressUseCase(
          locationRepository: mockNominatimLocationRepository,
        );

        mockAddress = 'Paris';
        mockLang = 'en';

        mockLocation = Location(
          uid: const Uuid().v4(),
          primaryLocationName: 'Test location 1',
          detailedLocationAddress: null,
          coordinate: const LatLng(48.86010864158489, 2.345729107741683),
          locationType: LocationType.locationFromSearch,
        );
      });

      group(
        'execute function',
        () {
          test(
            'should return Location if request was successful',
            () async {
              when(
                () => mockNominatimLocationRepository.retrieveLocationByAddress(
                  address: mockAddress,
                  lang: mockLang,
                ),
              ).thenAnswer((_) async {
                return mockLocation;
              });

              final location = await retrieveLocationByAddressUseCase.execute(
                address: mockAddress,
                locationDataLang: mockLang,
              );

              expect(location, isA<Location>());
            },
          );

          test(
            'should pass exception if any exception in repository occurs',
            () async {
              when(
                () => mockNominatimLocationRepository.retrieveLocationByAddress(
                  address: mockAddress,
                  lang: mockLang,
                ),
              ).thenAnswer((_) async {
                throw RetrievingLocationByAddressLocationException();
              });

              expect(
                () => retrieveLocationByAddressUseCase.execute(
                  address: mockAddress,
                  locationDataLang: mockLang,
                ),
                throwsA(isA<RetrievingLocationByAddressLocationException>()),
              );
            },
          );
        },
      );
    },
  );
}
