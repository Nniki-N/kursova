import 'package:kursova/core/utils/exception_util.dart';

abstract class RouteException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  RouteException({
    required this.message,
    this.stackTrace,
  });

  @override
  String toString() => message;
}

class LocationsLackRouteException extends RouteException {
  LocationsLackRouteException({
    String? messageDetails,
    StackTrace? stackTrace,
  }) : super(
          message: ExceptionUtil.addDetailsToCustomMessage(
            'Locations for route were not provided',
            messageDetails,
          ),
          stackTrace: stackTrace,
        );
}

class EmptyRoutesResponseRouteException
    extends RouteException {
  EmptyRoutesResponseRouteException({
    String? messageDetails,
    StackTrace? stackTrace,
  }) : super(
          message: ExceptionUtil.addDetailsToCustomMessage(
            'No routes in respose were found',
            messageDetails,
          ),
          stackTrace: stackTrace,
        );
}

class NotOptimizedRouteRetrievingRouteException
    extends RouteException {
  NotOptimizedRouteRetrievingRouteException({
    String? messageDetails,
    StackTrace? stackTrace,
  }) : super(
          message: ExceptionUtil.addDetailsToCustomMessage(
            'Something happened while retrieving not optimized route',
            messageDetails,
          ),
          stackTrace: stackTrace,
        );
}

class OptimizedParametersCombinationOsrmException
    extends RouteException {
  OptimizedParametersCombinationOsrmException({
    String? messageDetails,
    StackTrace? stackTrace,
  }) : super(
          message: ExceptionUtil.addDetailsToCustomMessage(
            'Incorrect combination of parameters',
            messageDetails,
          ),
          stackTrace: stackTrace,
        );
}

class OptimizedRouteRetrievingRouteException
    extends RouteException {
  OptimizedRouteRetrievingRouteException({
    String? messageDetails,
    StackTrace? stackTrace,
  }) : super(
          message: ExceptionUtil.addDetailsToCustomMessage(
            'Something happened while retrieving optimized route',
            messageDetails,
          ),
          stackTrace: stackTrace,
        );
}
