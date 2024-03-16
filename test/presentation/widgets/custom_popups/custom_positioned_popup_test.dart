import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/presentation/widgets/custom_buttons/custom_square_button_with_icon.dart';
import 'package:kursova/presentation/widgets/custom_popups/custom_positioned_popup.dart';

void main() {
  testWidgets(
    'CustomPositionedPopUp shoud have provided title, text and close button',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => CustomPositionedPopUp(
            title: 'Title',
            text: 'Text',
          ),
        ),
      );

      final titleFinder = find.text('Title');
      final textFinder = find.text('Text');
      final closeButtonFinder = find.byType(CustomSquareButtonWithIcon);

      expect(titleFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
      expect(closeButtonFinder, findsOneWidget);
    },
  );
}
