import 'package:kursova/core/utils/exception_util.dart';

/// An exception interface for all OSRM API exceptions.
abstract class OsrmException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  OsrmException({
    required this.message,
    this.stackTrace,
  });

  @override
  String toString() => message;
}

class TripRetrievingOsrmException extends OsrmException {
  TripRetrievingOsrmException({
    String? messageDetails,
    StackTrace? stackTrace,
  }) : super(
          message: ExceptionUtil.addDetailsToCustomMessage(
            'Something happened while retrieving trip',
            messageDetails,
          ),
          stackTrace: stackTrace,
        );
}

class TripRequestOsrmException extends OsrmException {
  TripRequestOsrmException({
    String? messageDetails,
    StackTrace? stackTrace,
  }) : super(
          message: ExceptionUtil.addDetailsToCustomMessage(
            'Retrieving trip response failed',
            messageDetails,
          ),
          stackTrace: stackTrace,
        );
}

class TripRequestParametersCombinationOsrmException extends OsrmException {
  TripRequestParametersCombinationOsrmException({
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

class RouteRetrievingOsrmException extends OsrmException {
  RouteRetrievingOsrmException({
    String? messageDetails,
    StackTrace? stackTrace,
  }) : super(
          message: ExceptionUtil.addDetailsToCustomMessage(
            'Something happened while retrieving route',
            messageDetails,
          ),
          stackTrace: stackTrace,
        );
}

class RouteRequestOsrmException extends OsrmException {
  RouteRequestOsrmException({
    String? messageDetails,
    StackTrace? stackTrace,
  }) : super(
          message: ExceptionUtil.addDetailsToCustomMessage(
            'Retrieving route response failed',
            messageDetails,
          ),
          stackTrace: stackTrace,
        );
}
