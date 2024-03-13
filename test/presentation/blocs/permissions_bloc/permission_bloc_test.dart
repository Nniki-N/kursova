import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/core/services/location_service.dart';
import 'package:kursova/core/services/permission_service.dart';
import 'package:kursova/presentation/blocs/permissions_bloc/permission_bloc.dart';
import 'package:kursova/presentation/blocs/permissions_bloc/permission_event.dart';
import 'package:kursova/presentation/blocs/permissions_bloc/permission_state.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';

class MockPermissionsService extends Mock implements PermissionsService {}

class MockLocationService extends Mock implements LocationService {}

void main() {
  group(
    'PermissionBloc ->',
    () {
      late PermissionBloc permissionBloc;
      late MockPermissionsService mockPermissionsService;
      late MockLocationService mockLocationService;

      setUp(() {
        mockPermissionsService = MockPermissionsService();
        mockLocationService = MockLocationService();
        permissionBloc = PermissionBloc(
          logger: Logger(),
          permissionsService: mockPermissionsService,
          locationService: mockLocationService,
        );
      });

      tearDownAll(() async {
        await permissionBloc.close();
      });

      test('initial state is PermissionInitial', () {
        expect(permissionBloc.state, isA<PermissionInitial>());
      });

      group(
        'PermissionInitRequested',
        () {
          blocTest(
            'shoud emit PermissionInitRequested with locationIsGranted that equals true and locationServiceIsEnabled that equals true too',
            build: () => permissionBloc,
            setUp: () {
              when(
                () => mockPermissionsService.status(Permission.location),
              ).thenAnswer((_) async => PermissionStatus.granted);

              when(
                () => mockLocationService.isLocationServiceEnabled(),
              ).thenAnswer((_) async => true);
            },
            act: (bloc) => bloc.add(const PermissionInitRequested()),
            expect: () => [
              isA<PermissionLoaded>()
                  .having(
                    (state) => state.locationIsGranted,
                    'locationIsGranted is true',
                    equals(true),
                  )
                  .having(
                    (state) => state.locationServiceIsEnabled,
                    'locationServiceIsEnabled is true',
                    equals(true),
                  ),
            ],
          );

          blocTest(
            'shoud NOT emit PermissionInitRequested when exception appears while initializing',
            build: () => permissionBloc,
            setUp: () {
              when(
                () => mockPermissionsService.status(Permission.location),
              ).thenAnswer((_) async => PermissionStatus.granted);

              when(
                () => mockLocationService.isLocationServiceEnabled(),
              ).thenThrow(Exception());
            },
            act: (bloc) => bloc.add(const PermissionInitRequested()),
            expect: () => [],
          );
        },
      );
    },
  );
}
