import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kursova/core/errors/route_repository_exception.dart';
import 'package:kursova/domain/entities/route.dart';
import 'package:kursova/domain/repositories/route_repository.dart';
import 'package:kursova/presentation/blocs/route_bloc/Route_event.dart';
import 'package:kursova/presentation/blocs/route_bloc/route_state.dart';
import 'package:logger/logger.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  RouteBloc({
    required RouteRepository routeRepository,
    required Logger logger,
  })  : _routeRepository = routeRepository,
        _logger = logger,
        super(RouteInitial()) {
    on<RouteFindRouteRequested>(_findRoute);
    on<RouteConfigureRouteRequested>(_configureRoute);
    on<RouteRemoveRouteRequested>(_removeRoute);
  }

  final RouteRepository _routeRepository;
  final Logger _logger;

  Future<void> _findRoute(
    RouteFindRouteRequested event,
    Emitter<RouteState> emit,
  ) async {
    try {
      if (event.locations.length < 2) {
        return;
      }

      emit(RouteLoading(
        withStartPoint: state.withStartPoint,
        withEndPoint: state.withEndPoint,
        cycledRoute: state.cycledRoute,
      ));

      final Route route;

      if (!state.cycledRoute && !state.withStartPoint && !state.withEndPoint) {
        route =
            await _routeRepository.retrieveNotOptimizedRouteBetweenLocations(
          orderedLocations: event.locations,
        );
      } else {
        route = await _routeRepository.retrieveOptimizedRouteBetweenLocations(
          locations: event.locations,
          withStartPoint: state.withStartPoint,
          withEndPoint: state.withEndPoint,
          roundTrip: state.cycledRoute,
        );
      }

      emit(RouteLoaded(
        route: route,
        withStartPoint: state.withStartPoint,
        withEndPoint: state.withEndPoint,
        cycledRoute: state.cycledRoute,
      ));
    } on RouteRepositoryException catch (exception, stackTrace) {
      _logger.e(
        'RouteBloc ${exception.message}',
        error: exception,
        stackTrace: stackTrace,
      );

      emit(RouteLoadingRouteFaillure(
        withStartPoint: state.withStartPoint,
        withEndPoint: state.withEndPoint,
        cycledRoute: state.cycledRoute,
      ));
    } catch (exception, stackTrace) {
      _logger.e(
        'RouteBloc ${exception.runtimeType}',
        error: exception,
        stackTrace: stackTrace,
      );

      emit(RouteLoadingRouteFaillure(
        withStartPoint: state.withStartPoint,
        withEndPoint: state.withEndPoint,
        cycledRoute: state.cycledRoute,
      ));
    }
  }

  Future<void> _configureRoute(
    RouteConfigureRouteRequested event,
    Emitter<RouteState> emit,
  ) async {
    if (!state.cycledRoute && (event.cycledRoute ?? false)) {
      emit(RouteConfigurationUpdated(
        withEndPoint: false,
        withStartPoint: false,
        cycledRoute: event.cycledRoute ?? state.cycledRoute,
      ));
    } else if ((!state.withEndPoint && (event.withEndPoint ?? false)) ||
        (!state.withStartPoint && (event.withStartPoint ?? false))) {
      emit(RouteConfigurationUpdated(
        withEndPoint: event.withEndPoint ?? state.withEndPoint,
        withStartPoint: event.withStartPoint ?? state.withStartPoint,
        cycledRoute: false,
      ));
    }

    emit(RouteConfigurationUpdated(
      withEndPoint: event.withEndPoint ?? state.withEndPoint,
      withStartPoint: event.withStartPoint ?? state.withStartPoint,
      cycledRoute: event.cycledRoute ?? state.cycledRoute,
    ));
  }

  Future<void> _removeRoute(
    RouteRemoveRouteRequested event,
    Emitter<RouteState> emit,
  ) async {
    emit(RouteEmpty(
      withStartPoint: state.withStartPoint,
      withEndPoint: state.withEndPoint,
      cycledRoute: state.cycledRoute,
    ));
  }
}
