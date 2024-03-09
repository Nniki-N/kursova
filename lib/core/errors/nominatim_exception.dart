import 'package:kursova/core/utils/exception_util.dart';

abstract class NominatimException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  NominatimException({
    required this.message,
    this.stackTrace,
  });

  @override
  String toString() => message;
}

class AddressDataRequestByCoordinatesNominatimException extends NominatimException {
  AddressDataRequestByCoordinatesNominatimException({
    String? messageDetails,
    StackTrace? stackTrace,
  }) : super(
          message: ExceptionUtil.addDetailsToCustomMessage(
            'Retrieving address data by coordinates failed',
            messageDetails,
          ),
          stackTrace: stackTrace,
        );
}

class AddressDataRequestByAddressNominatimException extends NominatimException {
  AddressDataRequestByAddressNominatimException({
    String? messageDetails,
    StackTrace? stackTrace,
  }) : super(
          message: ExceptionUtil.addDetailsToCustomMessage(
            'Retrieving address data by address failed',
            messageDetails,
          ),
          stackTrace: stackTrace,
        );
}

class RetrievingAddressDataByCoordinatesNominatimException
    extends NominatimException {
  RetrievingAddressDataByCoordinatesNominatimException({
    String? messageDetails,
    StackTrace? stackTrace,
  }) : super(
          message: ExceptionUtil.addDetailsToCustomMessage(
            'Something happened while retrieving address data by coordinates',
            messageDetails,
          ),
          stackTrace: stackTrace,
        );
}

class RetrievingAddressDataByAddressNominatimException
    extends NominatimException {
  RetrievingAddressDataByAddressNominatimException({
    String? messageDetails,
    StackTrace? stackTrace,
  }) : super(
          message: ExceptionUtil.addDetailsToCustomMessage(
            'Something happened while etrieving address data by address',
            messageDetails,
          ),
          stackTrace: stackTrace,
        );
}

class EmptyAddressDataResponseNominatimException extends NominatimException {
  EmptyAddressDataResponseNominatimException({
    String? messageDetails,
    StackTrace? stackTrace,
  }) : super(
          message: ExceptionUtil.addDetailsToCustomMessage(
            'Retrieved address data is empty',
            messageDetails,
          ),
          stackTrace: stackTrace,
        );
}
