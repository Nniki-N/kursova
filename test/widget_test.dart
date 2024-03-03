import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/presentation/app/my_app.dart';

void main() {
  testWidgets('Counter increments smoke test', (tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
  });
}
