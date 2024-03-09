import 'package:kursova/core/utils/exception_util.dart';

abstract class LocationException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  LocationException({
    required this.message,
    this.stackTrace,
  });

  @override
  String toString() => message;
}

class RetrievingLocationByAddressLocationException extends LocationException {
  RetrievingLocationByAddressLocationException({
    String? messageDetails,
    StackTrace? stackTrace,
  }) : super(
          message: ExceptionUtil.addDetailsToCustomMessage(
            'Something happened while retrieving location by address',
            messageDetails,
          ),
          stackTrace: stackTrace,
        );
}

class LocationPermissionIsNotGrantedLocationException extends LocationException {
  LocationPermissionIsNotGrantedLocationException({
    String? messageDetails,
    StackTrace? stackTrace,
  }) : super(
          message: ExceptionUtil.addDetailsToCustomMessage(
            'Locations permission is not granted and operationg with retrieving current location is not possible',
            messageDetails,
          ),
          stackTrace: stackTrace,
        );
}
