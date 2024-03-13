import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/core/services/connection_service.dart';
import 'package:kursova/presentation/blocs/internet_status_bloc/internet_status_bloc.dart';
import 'package:kursova/presentation/blocs/internet_status_bloc/internet_status_event.dart';
import 'package:kursova/presentation/blocs/internet_status_bloc/internet_status_state.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectionService extends Mock implements ConnectionService {}

void main() {
  group(
    'InternetStatusBloc ->',
    () {
      late InternetStatusBloc internetStatusBloc;
      late MockConnectionService mockConnectionService;
      late StreamController<CnnectionStatus>
          mockConnectionStatusStreamController;
      late Stream<CnnectionStatus> mockConnectionStatusStream;

      setUp(() {
        mockConnectionService = MockConnectionService();
        internetStatusBloc = InternetStatusBloc(
          logger: Logger(),
          connectionService: mockConnectionService,
        );

        mockConnectionStatusStreamController =
            StreamController<CnnectionStatus>();
        mockConnectionStatusStream =
            mockConnectionStatusStreamController.stream.asBroadcastStream();
      });

      tearDownAll(() async {
        await mockConnectionStatusStreamController.close();
        await internetStatusBloc.close();
      });

      test('initial state is InternetStatusInitial', () {
        expect(internetStatusBloc.state, isA<InternetStatusInitial>());
      });

      group(
        'InternetStatusListenRequested',
        () {
          blocTest(
            'shoud emit InternetStatusConnected when device connection status is connected to wifi, mobile, ethernet or vpn',
            build: () => internetStatusBloc,
            setUp: () {
              when(
                () => mockConnectionService.checkConnectivity(),
              ).thenAnswer((_) async => CnnectionStatus.connected);

              when(
                () => mockConnectionService.onConnectivityChanged(),
              ).thenAnswer((_) => mockConnectionStatusStream);
            },
            act: (bloc) => bloc.add(const InternetStatusListenRequested()),
            expect: () => [isA<InternetStatusConnected>()],
          );

          blocTest(
            'shoud emit InternetStatusDisconnected when device connection status is NOT connected to wifi, mobile, ethernet or vpn',
            build: () => internetStatusBloc,
            setUp: () {
              when(
                () => mockConnectionService.checkConnectivity(),
              ).thenAnswer((_) async => CnnectionStatus.disconnected);

              when(
                () => mockConnectionService.onConnectivityChanged(),
              ).thenAnswer((_) => mockConnectionStatusStream);
            },
            act: (bloc) => bloc.add(const InternetStatusListenRequested()),
            expect: () => [isA<InternetStatusDisconnected>()],
          );
        },
      );
    },
  );
}
