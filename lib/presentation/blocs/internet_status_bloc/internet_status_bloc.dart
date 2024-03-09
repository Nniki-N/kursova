import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kursova/presentation/blocs/internet_status_bloc/internet_status_event.dart';
import 'package:kursova/presentation/blocs/internet_status_bloc/internet_status_state.dart';
import 'package:logger/logger.dart';

class InternetStatusBloc
    extends Bloc<InternetStatusEvent, InternetStatusState> {
  InternetStatusBloc({
    required Logger logger,
  })  : _logger = logger,
        super(const InternetStatusInitial()) {
    on<InternetStatusListenRequested>(_listenStatusChanges);
  }

  final Logger _logger;

  Future<void> _listenStatusChanges(
    InternetStatusListenRequested event,
    Emitter<InternetStatusState> emit,
  ) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      emit(const InternetStatusConnected());
    } else if (connectivityResult == ConnectivityResult.wifi) {
      emit(const InternetStatusConnected());
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      emit(const InternetStatusConnected());
    } else if (connectivityResult == ConnectivityResult.vpn) {
      emit(const InternetStatusConnected());
    } else {
      emit(const InternetStatusDisconnected());
    }

    await emit.onEach(
      Connectivity().onConnectivityChanged.asBroadcastStream(),
      onData: (connectivityResult) {
        if (connectivityResult == ConnectivityResult.mobile) {
          emit(const InternetStatusConnected());
        } else if (connectivityResult == ConnectivityResult.wifi) {
          emit(const InternetStatusConnected());
        } else if (connectivityResult == ConnectivityResult.ethernet) {
          emit(const InternetStatusConnected());
        } else if (connectivityResult == ConnectivityResult.vpn) {
          emit(const InternetStatusConnected());
        } else {
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
