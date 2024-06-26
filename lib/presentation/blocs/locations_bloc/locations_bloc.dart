import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kursova/core/app_constants.dart';
import 'package:kursova/core/errors/location_exception.dart';
import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/usecases/retrieve_current_location_usecase.dart';
import 'package:kursova/domain/usecases/retrieve_location_by_address.dart';
import 'package:kursova/domain/usecases/retrieve_location_by_coordinates_usecase.dart';
import 'package:kursova/presentation/blocs/locations_bloc/locations_event.dart';
import 'package:kursova/presentation/blocs/locations_bloc/locations_state.dart';
import 'package:logger/logger.dart';

/// A BLoC that is responsible for locations adding and removing.
class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  LocationsBloc({
    required RetrieveLocationByCoordinatesUseCase
        retrieveLocationByCoordinatesUseCase,
    required RetrieveCurrentLocationUseCase retrieveCurrentLocationUseCase,
    required RetrieveLocationByAddressUseCase
        retrieveLocationByAddresssUseCase,
    required Logger logger,
  })  : _retrieveLocationByCoordinatesUseCase =
            retrieveLocationByCoordinatesUseCase,
        _retrieveCurrentLocationUseCase = retrieveCurrentLocationUseCase,
        _retrieveLocationByAddresssUseCase = retrieveLocationByAddresssUseCase,
        _logger = logger,
        super(LocationsEmpty()) {
    on<LocationsAddNewLocationRequested>(_addNewLocation);
    on<LocationsAddCurrentUserLocationRequested>(_addCurrentUserLocation);
    on<LocationsAddLocationByAddressRequested>(_addLocationByAddress);
    on<LocationsRemoveLocationRequested>(_removeLocation);
    on<LocationsMoveOneLocationInOrderRequested>(_moveOneLocationInOrder);
    on<LocationsClearLocationsRequested>(_clearLocations);
  }

  final RetrieveLocationByCoordinatesUseCase
      _retrieveLocationByCoordinatesUseCase;
  final RetrieveCurrentLocationUseCase _retrieveCurrentLocationUseCase;
  final RetrieveLocationByAddressUseCase _retrieveLocationByAddresssUseCase;
  final Logger _logger;

  final int locationsLimit = 10;

  /// Adds a new location by coordinate [LocationsAddNewLocationRequested.latLng] if locations limit was not reached.
  /// 
  /// Location data language will be based on [LocationsAddNewLocationRequested.locationDataLang].
  /// 
  /// Emits [LocationsNotEmpty] if location was added, otherwise emits [LocationsAddingLocationFailure].
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
          await _retrieveLocationByCoordinatesUseCase.execute(
        latLng: event.latLng,
        locationDataLang: event.locationDataLang,
        startRetrievingLocationsFromFirstPoint: state.locations.isEmpty,
      );

      final List<Location> locations = List.from(state.locations);
      locations.add(location);

      emit(LocationsNotEmpty(locations: locations));
    } on LocationException catch (exception) {
      _logger.e(
        'LocationsBloc ${exception.message}',
        error: exception,
        stackTrace: exception.stackTrace,
      );

      emit(LocationsAddingLocationFailure(locations: state.locations));
    } catch (exception, stackTrace) {
      _logger.e(
        'LocationsBloc ${exception.toString()}',
        error: exception,
        stackTrace: stackTrace,
      );

      emit(LocationsAddingLocationFailure(locations: state.locations));
    }
  }

  /// Adds a new location based on current user position if locations limit was not reached.
  /// 
  /// Location data language will be based on [LocationsAddNewLocationRequested.locationDataLang].
  /// 
  /// Emits [LocationsNotEmpty] if location was added, otherwise emits [LocationsAddingCurrentLocationFailure].
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

      final currentLocation = await _retrieveCurrentLocationUseCase.execute(
        locationDataLang: event.locationDataLang,
        startRetrievingLocationsFromFirstPoint: state.locations.isEmpty,
      );

      final List<Location> locations = List.from(state.locations);
      locations.add(currentLocation);

      emit(LocationsNotEmpty(locations: locations));
    } on LocationException catch (exception) {
      print(exception);
      _logger.e(
        'LocationsBloc ${exception.message}',
        error: exception,
        stackTrace: exception.stackTrace,
      );

      emit(LocationsAddingCurrentLocationFailure(locations: state.locations));
    } catch (exception, stackTrace) {
      print(exception);
      _logger.e(
        'LocationsBloc ${exception.toString()}',
        error: exception,
        stackTrace: stackTrace,
      );

      emit(LocationsAddingCurrentLocationFailure(locations: state.locations));
    }
  }

  /// Adds a new location based on provided address [LocationsAddLocationByAddressRequested.address] if locations limit was not reached.
  /// 
  /// Location data language will be based on [LocationsAddNewLocationRequested.locationDataLang].
  /// 
  /// Emits [LocationsNotEmpty] if location was added, otherwise emits [LocationsAddingLocationFailure].
  Future<void> _addLocationByAddress(
    LocationsAddLocationByAddressRequested event,
    Emitter<LocationsState> emit,
  ) async {
    try {
      if (_reachedLocationsLimit(emit: emit, showMessage: true)) {
        return;
      }

      emit(LocationsAddingLocation(locations: state.locations));

      final location = await _retrieveLocationByAddresssUseCase.execute(
        address: event.address,
        locationDataLang: event.locationDataLang,
        startRetrievingLocationsFromFirstPoint: state.locations.isEmpty,
      );

      final List<Location> locations = List.from(state.locations);
      locations.add(location);

      emit(LocationsNotEmpty(locations: locations));
    } on LocationException catch (exception) {
      _logger.e(
        'LocationsBloc ${exception.message}',
        error: exception,
        stackTrace: exception.stackTrace,
      );

      emit(LocationsAddingLocationFailure(locations: state.locations));
    } catch (exception, stackTrace) {
      _logger.e(
        'LocationsBloc ${exception.toString()}',
        error: exception,
        stackTrace: stackTrace,
      );

      emit(LocationsAddingLocationFailure(locations: state.locations));
    }
  }

  /// Removes location based on location uid [LocationsRemoveLocationRequested.uid]
  /// 
  /// Emits [LocationsNotEmpty] if location was removed, otherwise emits [LocationsRemovingLocationFailure].
  Future<void> _removeLocation(
    LocationsRemoveLocationRequested event,
    Emitter<LocationsState> emit,
  ) async {
    try {
      final List<Location> locations = List.from(state.locations);

      if (locations.isEmpty) {
        return;
      }

      locations.removeWhere((location) => location.uid == event.uid);

      emit(LocationsNotEmpty(locations: locations));
    } catch (exception, stackTrace) {
      _logger.e(
        'LocationsBloc ${exception.toString()}',
        error: exception,
        stackTrace: stackTrace,
      );

      emit(LocationsRemovingLocationFailure(locations: state.locations));
    }
  }

  /// Moves one location in order of locations based on new and old indexes [LocationsMoveOneLocationInOrderRequested.oldIndex] and [LocationsMoveOneLocationInOrderRequested.newIndex].
  /// 
  /// Emits [LocationsNotEmpty] if location was moved, otherwise emits [LocationMovingOneLocationInOrderFailure].
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
        'LocationsBloc ${exception.toString()}',
        error: exception,
        stackTrace: stackTrace,
      );

      emit(LocationMovingOneLocationInOrderFailure(locations: state.locations));
    }
  }

  /// Emits [LocationsEmpty].
  Future<void> _clearLocations(
    LocationsClearLocationsRequested event,
    Emitter<LocationsState> emit,
  ) async {
    emit(LocationsEmpty());
  }

  /// Checks if locations limit was reached.
  ///
  /// Emits [LocationsReachedLocationsLimit] and returns true if location limit was reached.
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
