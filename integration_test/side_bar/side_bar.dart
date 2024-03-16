import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/presentation/screens/side_bar/choose_locations_side_bar_content.dart';
import 'package:kursova/presentation/screens/side_bar/widgets/side_bar_open_button.dart';

class SideBar {
  late WidgetTester tester;

  SideBar(this.tester);

  Future<void> openSideBarOnMobile() async {
    if (kIsWeb) {
      return;
    }

    final sideBarOpenButtonFinder = find.byType(SideBarOpenButton);
    await tester.tap(sideBarOpenButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapOnSideBarOpenButton() async {
    final sideBarOpenButtonFinder = find.byType(SideBarOpenButton);

    await tester.tap(sideBarOpenButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapOnSideBarHideButton() async {
    final sideBarHideButtonFinder = find.byKey(
      const ValueKey('side_bar_hide_button'),
    );

    await tester.tap(sideBarHideButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> verifySideBarIsNotVisible() async {
    if (kIsWeb) {
      final sideBarPositionedFinder = find.byKey(
        const ValueKey('side_bar_positioned_widget'),
      );

      final Positioned sideBarPositioned = tester.firstWidget(
        sideBarPositionedFinder,
      );

      final bool sideBarIsNotVisible =
          sideBarPositioned.left != 0 && sideBarPositioned.right != 0;

      expect(sideBarIsNotVisible, equals(true));
    }

    final chooseLocationsSideBarContentFinder = find.byType(
      ChooseLocationsSideBarContent,
    );

    expect(chooseLocationsSideBarContentFinder, findsNothing);
  }

  Future<void> verifySideBarIsVisible() async {
    if (kIsWeb) {
      final sideBarPositionedFinder = find.byKey(
        const ValueKey('side_bar_positioned_widget'),
      );

      final Positioned sideBarPositioned = tester.firstWidget(
        sideBarPositionedFinder,
      );

      final bool sideBarIsNotVisible =
          sideBarPositioned.left == 0 && sideBarPositioned.right == 0;

      expect(sideBarIsNotVisible, equals(true));
    }

    final chooseLocationsSideBarContentFinder = find.byType(
      ChooseLocationsSideBarContent,
    );

    expect(chooseLocationsSideBarContentFinder, findsOneWidget);
  }
}
