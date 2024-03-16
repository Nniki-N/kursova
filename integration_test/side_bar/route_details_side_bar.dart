import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/presentation/screens/side_bar/route_details_side_bar_content.dart';

import '../test_utils/pump_until_found.dart';

class RouteDetailsSideBar {
  late WidgetTester tester;

  RouteDetailsSideBar(this.tester);

  final _backButtonFinder = find.byKey(
    const ValueKey('back_button'),
  );

  Future<void> tapOnBackButton() async {
    await tester.tap(_backButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> waitUntilRouteDetailsSideBarContentIsInTree() async {
    await pumpUntilFound(
      tester: tester,
      finder: find.byType(
        RouteDetailsSideBarContent,
      ),
    );
  }

  Future<void> verifyLocationsCount({
    required int locationsCount,
  }) async {
    final int length = find
        .byKey(const ValueKey('route_details_location_name'))
        .evaluate()
        .length;

    expect(length, locationsCount);
  }

  Future<void> verifyRouteDetailsSideBarContenttIsPresent() async {
    final routeDetailsSideBarContentFinder = find.byType(
      RouteDetailsSideBarContent,
    );

    expect(routeDetailsSideBarContentFinder, findsOneWidget);
  }
}
