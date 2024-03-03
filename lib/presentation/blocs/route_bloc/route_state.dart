import 'package:kursova/domain/entities/route.dart';

abstract class RouteState {
  final Route route;
  final bool withStartPoint;
  final bool withEndPoint;
  final bool cycledRoute;

  const RouteState({
    required this.route,
    required this.withStartPoint,
    required this.withEndPoint,
    required this.cycledRoute,
  });

  @override
  String toString() {
    return 'RouteState(route: $route, withStartPoint: $withStartPoint, withEndPoint: $withEndPoint, cycledRoute: $cycledRoute)';
  }
}

class RouteInitial extends RouteState {
  RouteInitial()
      : super(
          route: Route.empty(),
          withStartPoint: false,
          withEndPoint: false,
          cycledRoute: false,
        );
}

class RouteEmpty extends RouteState {
  RouteEmpty({
    required bool withStartPoint,
    required bool withEndPoint,
    required bool cycledRoute,
  }) : super(
          route: Route.empty(),
          withStartPoint: withStartPoint,
          withEndPoint: withEndPoint,
          cycledRoute: cycledRoute,
        );
}

class RouteConfigurationUpdated extends RouteState {
  RouteConfigurationUpdated({
    required bool withStartPoint,
    required bool withEndPoint,
    required bool cycledRoute,
  }) : super(
          route: Route.empty(),
          withStartPoint: withStartPoint,
          withEndPoint: withEndPoint,
          cycledRoute: cycledRoute,
        );
}

class RouteLoaded extends RouteState {
  RouteLoaded({
    required Route route,
    required bool withStartPoint,
    required bool withEndPoint,
    required bool cycledRoute,
  }) : super(
          route: route,
          withStartPoint: withStartPoint,
          withEndPoint: withEndPoint,
          cycledRoute: cycledRoute,
        );
}

class RouteLoading extends RouteState {
  RouteLoading({
    required bool withStartPoint,
    required bool withEndPoint,
    required bool cycledRoute,
  }) : super(
          route: Route.empty(),
          withStartPoint: withStartPoint,
          withEndPoint: withEndPoint,
          cycledRoute: cycledRoute,
        );
}

class RouteLoadingRouteFaillure extends RouteState {
  RouteLoadingRouteFaillure({
    required bool withStartPoint,
    required bool withEndPoint,
    required bool cycledRoute,
  }) : super(
          route: Route.empty(),
          withStartPoint: withStartPoint,
          withEndPoint: withEndPoint,
          cycledRoute: cycledRoute,
        );
}
