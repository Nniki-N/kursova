import 'package:kursova/core/errors/route_exception.dart';
import 'package:kursova/domain/entities/location.dart';
import 'package:kursova/domain/entities/route.dart';

/// Interface for the route repository.
abstract class RouteRepository {
  const RouteRepository();


  /// Retrieves main route for vehicle between locations [orderedLocations] in provided order.
  /// 
  /// The route is simplified if it is too long. Еhe performed simplification does not affect the further accuracy of the route display on maps.
  ///
  /// Returns [Route] if request was successful.
  ///
  /// Throws [LocationsLackRouteException] if locations list is empty.
  ///
  /// Throws [EmptyRoutesResponseRouteException] if no routes were returned.
  ///
  /// Throws [NotOptimizedRouteRetrievingRouteException] if any other error occurs.
  Future<Route> retrieveNotOptimizedRouteBetweenLocations({
    required List<Location> orderedLocations,
  });

  
  /// Retrieves optimized route for vehicle between locations [locations].
  /// 
  /// The route is simplified if it is too long. Еhe performed simplification does not affect the further accuracy of the route display on maps.
  ///
  /// Set [withStartPoint] to true if first location in list has to be start of the route. Set [withEndPoint] to true if last location in list has to be end of the route.
  ///
  /// Set [roundTrip] to true if route has to be cycled. All route parameters can not be set to false at the same time!
  /// 
  ///
  /// 
  /// Returns [Route] if request was successful.
  ///
  /// Throws [LocationsLackRouteException] if locations list is empty.
  /// 
  /// Throws [OptimizedParametersCombinationOsrmException] if all route parameters were set to false.
  ///
  /// Throws [EmptyRoutesResponseRouteException] if no routes were returned.
  ///
  /// Throws [NotOptimizedRouteRetrievingRouteException] if any other error occurs.
  Future<Route> retrieveOptimizedRouteBetweenLocations({
    required List<Location> locations,
    required bool withStartPoint,
    required bool withEndPoint,
    required bool roundTrip,
  });
}
