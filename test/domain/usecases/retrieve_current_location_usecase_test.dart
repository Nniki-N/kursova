import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/core/errors/location_exception.dart';
import 'package:kursova/core/services/location_service.dart';
import 'package:kursova/core/services/permission_service.dart';
import 'package:kursova/data/repositories/nominatim_location_repository.dart';
import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/usecases/retrieve_current_location_usecase.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class MockNominatimLocationRepository extends Mock
    implements NominatimLocationRepository {}

class MockPermissionsService extends Mock implements PermissionsService {}

class MockLocationService extends Mock implements LocationService {}

void main() {
  group(
    'RetrieveCurrentLocationUseCase ->',
    () {
      late RetrieveCurrentLocationUseCase retrieveCurrentLocationUseCase;
      late MockPermissionsService mockPermissionsService;
      late MockLocationService mockLocationService;
      late MockNominatimLocationRepository mockNominatimLocationRepository;
      late LatLng mockCoordinate;
      late String mockLang;
      late Location mockLocation;

      setUp(() {
        mockNominatimLocationRepository = MockNominatimLocationRepository();
        mockPermissionsService = MockPermissionsService();
        mockLocationService = MockLocationService();
        retrieveCurrentLocationUseCase = RetrieveCurrentLocationUseCase(
          locationRepository: mockNominatimLocationRepository,
          permissionsService: mockPermissionsService,
          locationService: mockLocationService,
        );

        mockCoordinate = const LatLng(48.136691343766316, 11.577186091868162);
        mockLang = 'en';

        mockLocation = Location(
          uid: const Uuid().v4(),
          primaryLocationName: 'Test location 1',
          detailedLocationAddress: null,
          coordinate: mockCoordinate,
          locationType: LocationType.currentLocation,
        );
      });

      group(
        'execute function',
        () {
          test(
            'should return Location if location service is enabled, location permission is granted and request was successful',
            () async {
              when(
                () => mockPermissionsService.request(Permission.location),
              ).thenAnswer((_) async {
                return PermissionStatus.granted;
              });

              when(
                () => mockLocationService.getCurrentPosition(),
              ).thenAnswer((_) async {
                return mockCoordinate;
              });

              when(
                () => mockNominatimLocationRepository
                    .retrieveLocationByCoordinates(
                  latLng: mockCoordinate,
                  returnedLocationType: LocationType.currentLocation,
                  lang: mockLang,
                ),
              ).thenAnswer((_) async {
                return mockLocation;
              });

              final location = await retrieveCurrentLocationUseCase.execute(
                locationDataLang: mockLang,
              );

              expect(location, isA<Location>());
            },
          );

          test(
            'should throw LocationPermissionIsNotGrantedLocationException if location permission is permanently denied',
            () async {
              when(
                () => mockPermissionsService.request(Permission.location),
              ).thenAnswer((_) async {
                return PermissionStatus.permanentlyDenied;
              });

              when(
                () => mockLocationService.getCurrentPosition(),
              ).thenAnswer((_) async {
                return mockCoordinate;
              });

              when(
                () => mockPermissionsService.openAppSettings(),
              ).thenAnswer((_) async {
                return true;
              });

              when(
                () => mockNominatimLocationRepository
                    .retrieveLocationByCoordinates(
                  latLng: mockCoordinate,
                  returnedLocationType: LocationType.currentLocation,
                  lang: mockLang,
                ),
              ).thenAnswer((_) async {
                return mockLocation;
              });

              expect(
                retrieveCurrentLocationUseCase.execute(
                  locationDataLang: mockLang,
                ),
                throwsA(isA<LocationPermissionIsNotGrantedLocationException>()),
              );
            },
          );

          test(
            'should throw LocationPermissionIsNotGrantedLocationException if location permission is denied',
            () async {
              when(
                () => mockPermissionsService.request(Permission.location),
              ).thenAnswer((_) async {
                return PermissionStatus.denied;
              });

              expect(
                () => retrieveCurrentLocationUseCase.execute(
                  locationDataLang: mockLang,
                ),
                throwsA(isA<LocationPermissionIsNotGrantedLocationException>()),
              );
            },
          );

          test(
            'should pass exception if locations service is not enabled',
            () async {
              when(
                () => mockPermissionsService.request(Permission.location),
              ).thenAnswer((_) async {
                return PermissionStatus.denied;
              });

              when(
                () => mockLocationService.getCurrentPosition(),
              ).thenThrow((_) async {
                throw Exception();
              });

              expect(
                () => retrieveCurrentLocationUseCase.execute(
                  locationDataLang: mockLang,
                ),
                throwsException,
              );
            },
          );
        },
      );
    },
  );
}
