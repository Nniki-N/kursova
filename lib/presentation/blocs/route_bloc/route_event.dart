import 'package:kursova/domain/entities/location.dart';

abstract class RouteEvent {
  const RouteEvent();
}

class RouteFindRouteRequested extends RouteEvent {
  final List<Location> locations;

  const RouteFindRouteRequested({
    required this.locations,
  });
}

class RouteConfigureRouteRequested extends RouteEvent {
  final bool? withStartPoint;
  final bool? withEndPoint;
  final bool? cycledRoute;

  const RouteConfigureRouteRequested({
    this.withStartPoint,
    this.withEndPoint,
    this.cycledRoute,
  });
}

class RouteRemoveRouteRequested extends RouteEvent {
  const RouteRemoveRouteRequested();
}
