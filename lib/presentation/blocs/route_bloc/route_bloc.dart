import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kursova/core/errors/route_exception.dart';
import 'package:kursova/domain/entities/route.dart';
import 'package:kursova/domain/usecases/find_route_usecase.dart';
import 'package:kursova/presentation/blocs/route_bloc/route_event.dart';
import 'package:kursova/presentation/blocs/route_bloc/route_state.dart';
import 'package:logger/logger.dart';

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
