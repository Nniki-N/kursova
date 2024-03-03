import 'package:kursova/core/utils/exception_util.dart';

abstract class RouteRepositoryException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  RouteRepositoryException({
    required this.message,
    this.stackTrace,
  });

  @override
  String toString() => message;
}

class LocationsLackRouteRepositoryException extends RouteRepositoryException {
  LocationsLackRouteRepositoryException({
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

class EmptyRoutesResponseRouteRepositoryException
    extends RouteRepositoryException {
  EmptyRoutesResponseRouteRepositoryException({
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

class NotOptimizedRouteRetrievingRouteRepositoryException
    extends RouteRepositoryException {
  NotOptimizedRouteRetrievingRouteRepositoryException({
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
    extends RouteRepositoryException {
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

class OptimizedRouteRetrievingRouteRepositoryException
    extends RouteRepositoryException {
  OptimizedRouteRetrievingRouteRepositoryException({
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
