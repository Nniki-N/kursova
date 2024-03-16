import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/presentation/app/my_app.dart';

import 'easy_localizotion_wrapper.dart';
import 'pump_for_seconds.dart';

Future<void> pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(
    addEasyLocalizationWrapper(child: const MyApp()),
  );

  await tester.pumpAndSettle();

  await pumpForSeconds(
    tester: tester,
    seconds: 3,
  );
}
