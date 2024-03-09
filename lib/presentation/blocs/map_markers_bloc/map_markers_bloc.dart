import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kursova/core/app_constants.dart';
import 'package:kursova/domain/entities/location_marker.dart';
import 'package:kursova/presentation/blocs/map_markers_bloc/map_markers_event.dart';
import 'package:kursova/presentation/blocs/map_markers_bloc/map_markers_state.dart';
import 'package:logger/logger.dart';

class MapMarkersBloc extends Bloc<MapMarkersEvent, MapMarkersState> {
  MapMarkersBloc({
    required Logger logger,
  })  : _logger = logger,
        super(MapMarkersEmpty()) {
    on<MapMarkersAddMakerRequested>(_addMarker);
    on<MapMarkersReplaceMarkersRequested>(_replaceMarkers);
    on<MapMarkersClearMarkersRequested>(_clearMarkers);
  }

  final Logger _logger;

  Future<void> _addMarker(
    MapMarkersAddMakerRequested event,
    Emitter<MapMarkersState> emit,
  ) async {
    try {
      if (_reachedLocationsLimit(emit)) {
        return;
      }

      final List<LocationMarker> locationMarkers = List.from(
        state.locationMarkers,
      );
      locationMarkers.add(LocationMarker(coordinate: event.latLng));

      emit(MapMarkersNotEmpty(locationMarkers: locationMarkers));
    } catch (exception, stackTrace) {
      _logger.e(
        'MapBloc ${exception.toString()}',
        error: exception,
        stackTrace: stackTrace,
      );

      emit(MapMarkersAddingMarkerFailure(
        locationMarkers: state.locationMarkers,
      ));
    }
  }

  Future<void> _replaceMarkers(
    MapMarkersReplaceMarkersRequested event,
    Emitter<MapMarkersState> emit,
  ) async {
    try {
      final List<LocationMarker> locationMarkers = event.coordinatesList
          .map((coordinate) => LocationMarker(coordinate: coordinate))
          .toList();

      emit(MapMarkersNotEmpty(locationMarkers: locationMarkers));
    } catch (exception, stackTrace) {
      _logger.e(
        'MapBloc ${exception.toString()}',
        error: exception,
        stackTrace: stackTrace,
      );

      emit(MapMarkersReplacingMarkerFailure(
        locationMarkers: state.locationMarkers,
      ));
    }
  }

  Future<void> _clearMarkers(
    MapMarkersClearMarkersRequested event,
    Emitter<MapMarkersState> emit,
  ) async {
    emit(MapMarkersEmpty());
  }

  bool _reachedLocationsLimit(Emitter<MapMarkersState> emit) {
    if (state.locationMarkers.length == AppConstants.locationsLimit) {
      emit(MapMarkersReachedMarkersLimit(
        locationMarkers: state.locationMarkers,
      ));
      return true;
    } else if (state.locationMarkers.length > AppConstants.locationsLimit) {
      List<LocationMarker> locationMarkers = List.from(state.locationMarkers);
      locationMarkers = locationMarkers.sublist(0, AppConstants.locationsLimit);

      emit(MapMarkersReachedMarkersLimit(locationMarkers: locationMarkers));
      return true;
    }

    return false;
  }
}
