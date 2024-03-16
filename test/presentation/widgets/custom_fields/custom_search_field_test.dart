import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/presentation/widgets/custom_fields/custom_search_field.dart';
import 'package:kursova/resources/graphics/resources.dart';

void main() {
  testWidgets(
    'CustomSearchField shoud have enter button',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Scaffold(
            body: CustomSearchField(
              hintText: 'Hint text',
              controller: TextEditingController(text: ''),
              buttonIconPath: Svgs.addIcon,
            ),
          ),
        ),
      );

      final enterButtonFinder = find.byKey( const ValueKey('enter_button'));

      expect(enterButtonFinder, findsOneWidget);
    },
  );
}
