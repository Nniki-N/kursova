import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/presentation/widgets/custom_bottom_sheet/custom_bottom_sheet.dart';

void main() {
  testWidgets(
    'CustomBottomSheet shoud have provided title and text',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => const CustomBottomSheet(
            title: 'Title',
            text: 'Text',
          ),
        ),
      );

      final titleFinder = find.text('Title');
      final textFinder = find.text('Text');

      expect(titleFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
    },
  );
}
