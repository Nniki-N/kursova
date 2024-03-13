import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/presentation/cubits/side_bar_menu_visibility_cubit.dart';

void main() {
  group(
    'SideBarMenuVisibilityCubit ->',
    () {
      late SideBarMenuVisibilityCubit sideBarMenuVisibilityCubit;

      setUp(() {
        sideBarMenuVisibilityCubit = SideBarMenuVisibilityCubit();
      });

      tearDownAll(() async {
        await sideBarMenuVisibilityCubit.close();
      });

      test('initial state is PermissionInitial', () {
        expect(
          sideBarMenuVisibilityCubit.state,
          equals(SideBarMenuVisibility.visible),
        );
      });

      group(
        'toogleSideBarMenuVisibility function',
        () {
          blocTest(
            'shoud change state from visible to hidden',
            build: () => sideBarMenuVisibilityCubit,
            act: (cubit) => cubit.toogleSideBarMenuVisibility(),
            expect: () => [equals(SideBarMenuVisibility.hidden)],
          );
        },
      );
    },
  );
}
