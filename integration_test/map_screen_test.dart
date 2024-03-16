import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kursova/core/di/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'side_bar/choose_locations_side_bar.dart';
import 'side_bar/route_details_side_bar.dart';
import 'side_bar/side_bar.dart';
import 'test_utils/pump_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    return Future(() async {
      SharedPreferences.setMockInitialValues({});
      await EasyLocalization.ensureInitialized();

      setupDependencies();
    });
  });

  group(
    'Side Bar ->',
    () {
      testWidgets(
        'side bar can be hidden and shown',
        (tester) async {
          await pumpApp(tester);

          final sideBar = SideBar(tester);
          final chooseLocationsSideBar = ChooseLocationsSideBar(tester);

          // Opens drawer if device is not web.
          await sideBar.openSideBarOnMobile();

          // Checks if initial menu is choose locations side bar and is shown.
          await chooseLocationsSideBar
              .verifyChooseLocationsSideBarContentIsPresent();

          // Hides side bar.
          await sideBar.tapOnSideBarHideButton();

          // Checks if side bar is hidden.
          await sideBar.verifySideBarIsNotVisible();

          // Opens side bar.
          await sideBar.tapOnSideBarOpenButton();

          // Checks if side bar is shown.
          await sideBar.verifySideBarIsVisible();
        },
      );

      testWidgets(
        'locations can be added, removed and cleared',
        (tester) async {
          await pumpApp(tester);

          final sideBar = SideBar(tester);

          // Opens drawer if device is not web.
          await sideBar.openSideBarOnMobile();

          final chooseLocationsSideBar = ChooseLocationsSideBar(tester);

          // Checks if initial menu is choose locations side bar.
          await chooseLocationsSideBar
              .verifyChooseLocationsSideBarContentIsPresent();

          // Adds first location.
          await chooseLocationsSideBar.addLocationBySearchField(
            address: 'Paris',
          );

          // Checks if location was added.
          await chooseLocationsSideBar.verifyLocationsCount(locationsCount: 1);

          // Removes first location from the list.
          await chooseLocationsSideBar.removeFirstLocation();

          // Checks if location was removed.
          await chooseLocationsSideBar.verifyLocationsCount(locationsCount: 0);

          // Adds 2 more locations.
          await chooseLocationsSideBar.addLocationBySearchField(
            address: 'Paris',
          );
          await chooseLocationsSideBar.addLocationBySearchField(
            address: 'Munich',
          );
          await chooseLocationsSideBar.addLocationBySearchField(
            address: 'Berlin',
          );

          // Checks if locations were added.
          await chooseLocationsSideBar.verifyLocationsCount(locationsCount: 3);

          // Clears all locations.
          await chooseLocationsSideBar.clearLocations();

          // Checks if all locations were cleared.
          await chooseLocationsSideBar.verifyLocationsCount(locationsCount: 0);
        },
      );

      testWidgets(
        'one way route can be created and all locations are shwon',
        (tester) async {
          await pumpApp(tester);

          final sideBar = SideBar(tester);

          // Opens drawer if device is not web.
          await sideBar.openSideBarOnMobile();

          final chooseLocationsSideBar = ChooseLocationsSideBar(tester);
          final routeDetailsSideBar = RouteDetailsSideBar(tester);

          // Checks if initial menu is choose locations side bar.
          await chooseLocationsSideBar
              .verifyChooseLocationsSideBarContentIsPresent();

          // Adds locations.
          await chooseLocationsSideBar.addLocationBySearchField(
            address: 'Paris',
          );
          await chooseLocationsSideBar.addLocationBySearchField(
            address: 'Munich',
          );
          await chooseLocationsSideBar.addLocationBySearchField(
            address: 'Berlin',
          );

          // Checks if location was added.
          await chooseLocationsSideBar.verifyLocationsCount(locationsCount: 3);

          // Adds start and end points to the route configuration.
          await chooseLocationsSideBar.openAdvancedOptions();
          await chooseLocationsSideBar.tapOnSetStartPointOption();
          await chooseLocationsSideBar.tapOnSetEndPointOption();

          // Starts route finding;
          await chooseLocationsSideBar.findRoute();

          // Checks if route details side bar is shown.
          await routeDetailsSideBar
              .waitUntilRouteDetailsSideBarContentIsInTree();
          await routeDetailsSideBar
              .verifyRouteDetailsSideBarContenttIsPresent();

          // Checks if all locations in route details are shown.
          await routeDetailsSideBar.verifyLocationsCount(locationsCount: 3);

          // Returns back.
          await routeDetailsSideBar.tapOnBackButton();

          // Checks if choose locations side bar is shown.
          await chooseLocationsSideBar
              .waitUntilChooseLocationsSideBarContentIsInTree();
          await chooseLocationsSideBar
              .verifyChooseLocationsSideBarContentIsPresent();
        },
      );

      testWidgets(
        'cycled route can be created and all locations are shwon',
        (tester) async {
          await pumpApp(tester);

          final sideBar = SideBar(tester);

          // Opens drawer if device is not web.
          await sideBar.openSideBarOnMobile();

          final chooseLocationsSideBar = ChooseLocationsSideBar(tester);
          final routeDetailsSideBar = RouteDetailsSideBar(tester);

          // Checks if initial menu is choose locations side bar.
          await chooseLocationsSideBar
              .verifyChooseLocationsSideBarContentIsPresent();

          // Adds locations.
          await chooseLocationsSideBar.addLocationBySearchField(
            address: 'Paris',
          );
          await chooseLocationsSideBar.addLocationBySearchField(
            address: 'Munich',
          );
          await chooseLocationsSideBar.addLocationBySearchField(
            address: 'Berlin',
          );

          // Checks if location was added.
          await chooseLocationsSideBar.verifyLocationsCount(locationsCount: 3);

          // Adds cycled route parameter to the route configuration.
          await chooseLocationsSideBar.openAdvancedOptions();
          await chooseLocationsSideBar.tapOnCycledRouteOption();

          // Starts route finding;
          await chooseLocationsSideBar.findRoute();

          // Checks if route details side bar is shown.
          await routeDetailsSideBar
              .waitUntilRouteDetailsSideBarContentIsInTree();
          await routeDetailsSideBar
              .verifyRouteDetailsSideBarContenttIsPresent();

          // Checks if all locations in route details are shown.
          await routeDetailsSideBar.verifyLocationsCount(locationsCount: 4);

          // Returns back.
          await routeDetailsSideBar.tapOnBackButton();

          // Checks if choose locations side bar is shown.
          await chooseLocationsSideBar
              .waitUntilChooseLocationsSideBarContentIsInTree();
          await chooseLocationsSideBar
              .verifyChooseLocationsSideBarContentIsPresent();
        },
      );
    },
  );
}
