import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/entities/route.dart';
import 'package:kursova/domain/repositories/route_repository.dart';

class FindRouteUseCase {
  FindRouteUseCase({
    required RouteRepository routeRepository,
  }) : _routeRepository = routeRepository;

  final RouteRepository _routeRepository;

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
