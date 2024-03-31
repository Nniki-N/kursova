import 'package:flutter_bloc/flutter_bloc.dart';

enum SideBarMenuVisibility { visible, hidden }

/// A Cubit that is responsible for the side bar menu visibility.
class SideBarMenuVisibilityCubit extends Cubit<SideBarMenuVisibility> {
  SideBarMenuVisibilityCubit() : super(SideBarMenuVisibility.visible);

  /// Toogles visibility of the side bar menu.
  void toogleSideBarMenuVisibility() {
    if (state == SideBarMenuVisibility.hidden) {
      emit(SideBarMenuVisibility.visible);
    } else if (state == SideBarMenuVisibility.visible) {
      emit(SideBarMenuVisibility.hidden);
    }
  }
}
