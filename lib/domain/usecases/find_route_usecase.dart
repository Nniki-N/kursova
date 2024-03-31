import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/entities/route.dart';
import 'package:kursova/domain/repositories/route_repository.dart';

/// Use case that is used for finding route for provided locations via communication with [RouteRepository].
class FindRouteUseCase {
  FindRouteUseCase({
    required RouteRepository routeRepository,
  }) : _routeRepository = routeRepository;

  final RouteRepository _routeRepository;

  /// Retrieves optimized route for vehicle between locations [locations] if [cycledRoute] or [withStartPoint] or [withEndPoint] is true,
  /// otherwise retrieves main route for vehicle between locations [locations] in provided order.
  ///
  /// Set [withStartPoint] to true if first location in list has to be start of the route. Set [withEndPoint] to true if last location in list has to be end of the route.
  /// 
  /// Set [cycledRoute] to true if route has to be cycled.
  Future<Route> execute({
    required List<Location> locations,
    required bool cycledRoute,
    required bool withStartPoint,
    required bool withEndPoint,
  }) async {
    final Route route;

    if (!cycledRoute && !withStartPoint && !withEndPoint) {
      route = await _routeRepository.retrieveNotOptimizedRouteBetweenLocations(
        orderedLocations: locations,
      );
    } else {
      route = await _routeRepository.retrieveOptimizedRouteBetweenLocations(
        locations: locations,
        withStartPoint: withStartPoint,
        withEndPoint: withEndPoint,
        roundTrip: cycledRoute,
      );
    }

    return route;
  }
}
