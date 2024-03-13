import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kursova/core/services/connection_service.dart';
import 'package:kursova/presentation/blocs/internet_status_bloc/internet_status_event.dart';
import 'package:kursova/presentation/blocs/internet_status_bloc/internet_status_state.dart';
import 'package:logger/logger.dart';

class InternetStatusBloc
    extends Bloc<InternetStatusEvent, InternetStatusState> {
  InternetStatusBloc({
    required Logger logger,
    required ConnectionService connectionService,
  })  : _logger = logger,
        _connectionService = connectionService,
        super(const InternetStatusInitial()) {
    on<InternetStatusListenRequested>(_listenStatusChanges);
  }

  final Logger _logger;
  final ConnectionService _connectionService;

  Future<void> _listenStatusChanges(
    InternetStatusListenRequested event,
    Emitter<InternetStatusState> emit,
  ) async {
    final CnnectionStatus cnnectionStatus =
        await _connectionService.checkConnectivity();

    if (cnnectionStatus == CnnectionStatus.connected) {
      emit(const InternetStatusConnected());
    } else if (cnnectionStatus == CnnectionStatus.disconnected) {
      emit(const InternetStatusDisconnected());
    }

    await emit.onEach(
      _connectionService.onConnectivityChanged(),
      onData: (cnnectionStatus) {
        if (cnnectionStatus == CnnectionStatus.connected) {
          emit(const InternetStatusConnected());
        } else if (cnnectionStatus == CnnectionStatus.connected) {
          emit(const InternetStatusDisconnected());
        }
      },
      onError: (exception, stackTrace) {
        _logger.e(
          'InternetStatusBloc ${exception.toString()}',
          error: exception,
          stackTrace: stackTrace,
        );
        emit(const InternetStatusListeningException());
      },
    );
  }
}
