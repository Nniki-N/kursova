import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

Future<void> pumpForSeconds({
  required WidgetTester tester,
  required int seconds,
}) async {
  bool timerDone = false;
  Timer(Duration(seconds: seconds), () => timerDone = true);

  while (timerDone != true) {
    await tester.pump();
  }
}
