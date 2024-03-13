import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/core/utils/exception_util.dart';

void main() {
  group(
    'ExceptionUtil ->',
    () {
      group(
        'addDetailsToCustomMessage function',
        () {
          test(
            'should add message details if provided',
            () {
              const customMessage = 'Exception message';
              const messageDetails = 'details';

              final message = ExceptionUtil.addDetailsToCustomMessage(
                customMessage,
                messageDetails,
              );

              expect('$customMessage -> $messageDetails', message);
            },
          );
          
          test(
            'should return only message',
            () {
              const customMessage = 'Exception message';
              const messageDetails = null;

              final message = ExceptionUtil.addDetailsToCustomMessage(
                customMessage,
                messageDetails,
              );

              expect(customMessage, message);
            },
          );
        },
      );
    },
  );
}
