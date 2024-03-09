import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kursova/presentation/blocs/permissions_bloc/permission_event.dart';
import 'package:kursova/presentation/blocs/permissions_bloc/permission_state.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionBloc({
    required Logger logger,
  })  : _logger = logger,
        super(PermissionInitial()) {
    on<PermissionInitRequested>(_init);
  }

  final Logger _logger;

  Future<void> _init(
    PermissionInitRequested event,
    Emitter<PermissionState> emit,
  ) async {
    try {
      final bool locationServiceIsEnabled =
          await Geolocator.isLocationServiceEnabled();
      final bool locationIsGranted = await Permission.location.isGranted;

      emit(PermissionLoaded(
        locationServiceIsEnabled: locationServiceIsEnabled,
        locationIsGranted: locationIsGranted,
      ));
    } catch (exception, stackTrace) {
      _logger.e(
        'PermissionBloc ${exception.toString()}',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }
}
