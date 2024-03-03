import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kursova/core/app_constants.dart';
import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/enums/location_type.dart';
import 'package:kursova/domain/repositories/location_repository.dart';
import 'package:kursova/presentation/blocs/locations_bloc/locations_event.dart';
import 'package:kursova/presentation/blocs/locations_bloc/locations_state.dart';
import 'package:logger/logger.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  LocationsBloc({
    required LocationRepository locationRepository,
    required Logger logger,
  })  : _locationRepository = locationRepository,
        _logger = logger,
        super(LocationsEmpty()) {
    on<LocationsAddNewLocationRequested>(_addNewLocation);
    on<LocationsAddCurrentUserLocationRequested>(_addCurrentUserLocation);
    on<LocationsAddLocationByAddressRequested>(_addLocationByAddress);
    on<LocationsRemoveLocationRequested>(_removeLocation);
    on<LocationsMoveOneLocationInOrderRequested>(_moveOneLocationInOrder);
    on<LocationsClearLocationsRequested>(_clearLocations);
  }

  final LocationRepository _locationRepository;
  final Logger _logger;

  final int locationsLimit = 10;

  Future<void> _addNewLocation(
    LocationsAddNewLocationRequested event,
    Emitter<LocationsState> emit,
  ) async {
    try {
      if (_reachedLocationsLimit(emit: emit, showMessage: false)) {
        return;
      }

      emit(LocationsAddingLocation(locations: state.locations));

      final Location location =
          await _locationRepository.retrieveLocationByCoordinates(
        latLng: event.latLng,
        lang: event.locationDataLang,
      );

      final List<Location> locations = List.from(state.locations);
      locations.add(location);

      emit(LocationsNotEmpty(locations: locations));
    } catch (exception, stackTrace) {
      _logger.e(
        'LocationsBloc ${exception.toString()}',
        error: exception,
        stackTrace: stackTrace,
      );

      emit(LocationsAddingLocationFailure(locations: state.locations));
    }
  }

  Future<void> _addCurrentUserLocation(
    LocationsAddCurrentUserLocationRequested event,
    Emitter<LocationsState> emit,
  ) async {
    try {
      if (_reachedLocationsLimit(emit: emit, showMessage: true)) {
        return;
      }

      final bool hasCurrentLocationInList = state.locations
          .where(
            (location) => location.locationType == LocationType.currentLocation,
          )
          .isNotEmpty;

      if (hasCurrentLocationInList) {
        emit(LocationsReachedCurrentLocationsLimit(locations: state.locations));
        return;
      }

      emit(LocationsAddingLocation(locations: state.locations));

      final currentLocation = await _locationRepository.retrieveCurrentLocation(
        lang: event.locationDataLang,
      );

      if (currentLocation != null) {
        final List<Location> locations = List.from(state.locations);
        locations.add(currentLocation);

        emit(LocationsNotEmpty(locations: locations));
      } else {
        emit(LocationsAddingCurrentLocationFailure(locations: state.locations));
      }
    } catch (exception, stackTrace) {
      _logger.e(
        'LocationsBloc ${exception.runtimeType}',
        error: exception,
        stackTrace: stackTrace,
      );

      emit(LocationsAddingCurrentLocationFailure(locations: state.locations));
    }
  }

  Future<void> _addLocationByAddress(
    LocationsAddLocationByAddressRequested event,
    Emitter<LocationsState> emit,
  ) async {
    try {
      if (_reachedLocationsLimit(emit: emit, showMessage: true)) {
        return;
      }

      emit(LocationsAddingLocation(locations: state.locations));

      final location = await _locationRepository.retrieveLocationByAddress(
        address: event.address,
        lang: event.locationDataLang,
      );

      if (location != null) {
        final List<Location> locations = List.from(state.locations);
        locations.add(location);

        emit(LocationsNotEmpty(locations: locations));
      } else {
        emit(LocationsAddingLocationFailure(locations: state.locations));
      }
    } catch (exception, stackTrace) {
      _logger.e(
        'LocationsBloc ${exception.runtimeType}',
        error: exception,
        stackTrace: stackTrace,
      );

      emit(LocationsAddingLocationFailure(locations: state.locations));
    }
  }

  Future<void> _removeLocation(
    LocationsRemoveLocationRequested event,
    Emitter<LocationsState> emit,
  ) async {
    try {
      final List<Location> locations = List.from(state.locations);

      if (locations.isEmpty) {
        _locationRepository.resetRepository();
        return;
      }

      locations.removeWhere((location) => location.uid == event.uid);

      if (locations.isEmpty) {
        _locationRepository.resetRepository();
      }

      emit(LocationsNotEmpty(locations: locations));
    } catch (exception, stackTrace) {
      _logger.e(
        'LocationsBloc ${exception.runtimeType}',
        error: exception,
        stackTrace: stackTrace,
      );

      emit(LocationsRemovingLocationFailure(locations: state.locations));
    }
  }

  Future<void> _moveOneLocationInOrder(
    LocationsMoveOneLocationInOrderRequested event,
    Emitter<LocationsState> emit,
  ) async {
    try {
      final List<Location> locations = List.from(state.locations);

      if (locations.length - 1 < event.oldIndex ||
          locations.length - 1 < event.newIndex) {
        emit(LocationMovingOneLocationInOrderFailure(
          locations: state.locations,
        ));
        return;
      }

      final Location location = locations.removeAt(event.oldIndex);
      locations.insert(
        event.newIndex,
        location,
      );

      emit(LocationsNotEmpty(locations: locations));
    } catch (exception, stackTrace) {
      _logger.e(
        'LocationsBloc ${exception.runtimeType}',
        error: exception,
        stackTrace: stackTrace,
      );

      emit(LocationMovingOneLocationInOrderFailure(locations: state.locations));
    }
  }

  Future<void> _clearLocations(
    LocationsClearLocationsRequested event,
    Emitter<LocationsState> emit,
  ) async {
    _locationRepository.resetRepository();
    emit(LocationsEmpty());
  }

  bool _reachedLocationsLimit({
    required Emitter<LocationsState> emit,
    required bool showMessage,
  }) {
    if (state.locations.length == AppConstants.locationsLimit) {
      emit(LocationsReachedLocationsLimit(
        locations: state.locations,
        showMessage: showMessage,
      ));
      return true;
    } else if (state.locations.length > AppConstants.locationsLimit) {
      List<Location> locations = List.from(state.locations);
      locations = locations.sublist(0, AppConstants.locationsLimit);

      emit(LocationsReachedLocationsLimit(
        locations: locations,
        showMessage: showMessage,
      ));
      return true;
    }

    return false;
  }
}
