import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/core/app_constants.dart';
import 'package:kursova/presentation/screens/side_bar/choose_locations_side_bar_content.dart';
import 'package:kursova/presentation/widgets/custom_buttons/custom_square_button_with_icon.dart';

import '../test_utils/pump_until_found.dart';

class ChooseLocationsSideBar {
  late WidgetTester tester;

  ChooseLocationsSideBar(this.tester);

  final _searchTextFieldFinder = find.descendant(
    of: find.byKey(const ValueKey('search_field')),
    matching: find.byType(TextField),
  );
  final _searchFieldButtonFinder = find.descendant(
    of: find.byKey(const ValueKey('search_field')),
    matching: find.byKey(const ValueKey('enter_button')),
  );
  final _locationsListFinder = find.byType(ReorderableListView);
  final _findRouteButtonFinder = find.byKey(
    const ValueKey('find_route_button'),
  );
  final _clearLocationsButtonFinder = find.byKey(
    const ValueKey('clear_locations_button'),
  );

  Future<void> addLocationBySearchField({
    required String address,
  }) async {
    final ReorderableListView reorderableListView = tester.firstWidget(
      _locationsListFinder,
    );

    final int locationsCount = reorderableListView.itemCount;

    if (locationsCount >= AppConstants.locationsLimit) {
      return;
    }

    await tester.enterText(_searchTextFieldFinder, address);
    await tester.pump();
    await tester.tap(_searchFieldButtonFinder);

    bool timerDone = false;

    while (timerDone != true) {
      final length = find.byType(SideBarLocationsListItem).evaluate().length;
      timerDone = length > locationsCount;
      await tester.pump();
    }
  }

  Future<void> clearLocations() async {
    await tester.tap(_clearLocationsButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> removeFirstLocation() async {
    final removeLocationButtonFinder = find.descendant(
      of: _locationsListFinder,
      matching: find.descendant(
        of: find.byType(SideBarLocationsListItem).first,
        matching: find.byType(CustomSquareButtonWithIcon),
      ),
    );

    await tester.tap(removeLocationButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> findRoute() async {
    await tester.tap(_findRouteButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> openAdvancedOptions() async {
    final advancedOptionsFinder = find.byType(AdvancedOptions);

    await tester.tap(advancedOptionsFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapOnCycledRouteOption() async {
    final switchFinder = find.descendant(
      of: find.byKey(const ValueKey('cycled_route_option')),
      matching: find.byKey(const ValueKey('custom_switch')),
    );

    await tester.tap(switchFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapOnSetStartPointOption() async {
    final switchFinder = find.descendant(
      of: find.byKey(const ValueKey('set_start_point_option')),
      matching: find.byKey(const ValueKey('custom_switch')),
    );

    await tester.tap(switchFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapOnSetEndPointOption() async {
    final switchFinder = find.descendant(
      of: find.byKey(const ValueKey('set_end_point_option')),
      matching: find.byKey(const ValueKey('custom_switch')),
    );

    await tester.tap(switchFinder);
    await tester.pumpAndSettle();
  }

  Future<void> waitUntilChooseLocationsSideBarContentIsInTree() async {
    await pumpUntilFound(
      tester: tester,
      finder: find.byType(
        ChooseLocationsSideBarContent,
      ),
    );
  }

  Future<void> verifyLocationsCount({
    required int locationsCount,
  }) async {
    final ReorderableListView reorderableListView = tester.firstWidget(
      _locationsListFinder,
    );

    expect(reorderableListView.itemCount, locationsCount);
  }

  Future<void> verifyChooseLocationsSideBarContentIsPresent() async {
    final chooseLocationsSideBarContentFinder = find.byType(
      ChooseLocationsSideBarContent,
    );

    expect(chooseLocationsSideBarContentFinder, findsOneWidget);
  }
}
