import 'package:flutter_bloc/flutter_bloc.dart';

enum SideBarMenuVisibility { visible, hidden }

class SideBarMenuVisibilityCubit extends Cubit<SideBarMenuVisibility> {
  SideBarMenuVisibilityCubit() : super(SideBarMenuVisibility.visible);

  void toogleSideBarMenuVisibility() {
    if (state == SideBarMenuVisibility.hidden) {
      emit(SideBarMenuVisibility.visible);
    } else if (state == SideBarMenuVisibility.visible) {
      emit(SideBarMenuVisibility.hidden);
    }
  }
}
