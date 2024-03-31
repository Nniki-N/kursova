import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kursova/core/errors/route_exception.dart';
import 'package:kursova/domain/entities/route.dart';
import 'package:kursova/domain/usecases/find_route_usecase.dart';
import 'package:kursova/presentation/blocs/route_bloc/route_event.dart';
import 'package:kursova/presentation/blocs/route_bloc/route_state.dart';
import 'package:logger/logger.dart';

/// A BLoC that is responsible for route creating and displaying on the map.
class RouteBloc extends Bloc<RouteEvent, RouteState> {
  RouteBloc({
    required FindRouteUseCase findRouteUseCase,
    required Logger logger,
  })  : _findRouteUseCase = findRouteUseCase,
        _logger = logger,
        super(RouteInitial()) {
    on<RouteFindRouteRequested>(_findRoute);
    on<RouteConfigureRouteRequested>(_configureRoute);
    on<RouteRemoveRouteRequested>(_removeRoute);
  }

  final FindRouteUseCase _findRouteUseCase;
  final Logger _logger;

  /// Finds route between [RouteFindRouteRequested.locations] base on selected configuration.
  /// 
  /// Emits [RouteLoaded] if route was found, otherwise emits [RouteLoadingRouteFaillure].
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

      final Route route = await _findRouteUseCase.execute(
        locations: event.locations,
        withStartPoint: state.withStartPoint,
        withEndPoint: state.withEndPoint,
        cycledRoute: state.cycledRoute,
      );

      emit(RouteLoaded(
        route: route,
        withStartPoint: state.withStartPoint,
        withEndPoint: state.withEndPoint,
        cycledRoute: state.cycledRoute,
      ));
    } on RouteException catch (exception) {
      _logger.e(
        'RouteBloc ${exception.message}',
        error: exception,
        stackTrace: exception.stackTrace,
      );

      emit(RouteLoadingRouteFaillure(
        withStartPoint: state.withStartPoint,
        withEndPoint: state.withEndPoint,
        cycledRoute: state.cycledRoute,
      ));
    } catch (exception, stackTrace) {
      _logger.e(
        'RouteBloc ${exception.toString()}',
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

  /// Changes route configuration.
  /// 
  /// Set [RouteConfigureRouteRequested.cycledRoute] to true if you want to get cycled route in result.
  /// 
  /// Set [RouteConfigureRouteRequested.withEndPoint] or [RouteConfigureRouteRequested.withStartPoint] to true if you want to get optimized one way route.
  /// 
  /// By setting [RouteConfigureRouteRequested.withEndPoint] to true, found route will end with last location from provided.
  /// 
  /// By setting [RouteConfigureRouteRequested.withStartPoint] to true, found route will start from first location from provided.
  /// 
  /// [RouteConfigureRouteRequested.withEndPoint] and [RouteConfigureRouteRequested.withStartPoint] can be set to true at the same time, but [RouteConfigureRouteRequested.cycledRoute]
  /// can not be used with another route configuration settings.
  /// 
  /// Emits [RouteConfigurationUpdated] after configuration changing.
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
    } else {
      emit(RouteConfigurationUpdated(
        withEndPoint: event.withEndPoint ?? state.withEndPoint,
        withStartPoint: event.withStartPoint ?? state.withStartPoint,
        cycledRoute: event.cycledRoute ?? state.cycledRoute,
      ));
    }
  }

  /// Cleans BLoC state by removing route from it.
  /// 
  /// Emits [RouteEmpty].
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
