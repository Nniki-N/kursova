import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kursova/core/services/location_service.dart';
import 'package:kursova/core/services/permission_service.dart';
import 'package:kursova/presentation/blocs/permissions_bloc/permission_event.dart';
import 'package:kursova/presentation/blocs/permissions_bloc/permission_state.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

/// A BLoC that is responsible app permissions.
class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionBloc({
    required Logger logger,
    required PermissionsService permissionsService,
    required LocationService locationService,
  })  : _logger = logger,
        _permissionsService = permissionsService,
        _locationService = locationService,
        super(PermissionInitial()) {
    on<PermissionInitRequested>(_init);
  }

  final Logger _logger;
  final PermissionsService _permissionsService;
  final LocationService _locationService;

  /// Checks if location service is enabled and location permission is granted.
  /// 
  /// Emits [PermissionLoaded].
  Future<void> _init(
    PermissionInitRequested event,
    Emitter<PermissionState> emit,
  ) async {
    try {
      final bool locationServiceIsEnabled =
          await _locationService.isLocationServiceEnabled();
      final bool locationIsGranted = (await _permissionsService.status(
        Permission.location,
      ))
          .isGranted;

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
