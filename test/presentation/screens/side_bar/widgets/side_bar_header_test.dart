import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/presentation/screens/side_bar/widgets/side_bar_header.dart';
import 'package:kursova/presentation/widgets/custom_buttons/custom_square_button_with_icon.dart';

void main() {
  testWidgets(
    'SideBarHeader shoud have provided title and hide side bar button',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) =>
              const SideBarHeader(headerTitle: 'Title'),
        ),
      );

      final titleFinder = find.text('Title', findRichText: true);
      final hideSideBarButtonFinder = find.byType(CustomSquareButtonWithIcon);

      expect(titleFinder, findsOneWidget);
      expect(hideSideBarButtonFinder, findsOneWidget);
    },
  );
}
