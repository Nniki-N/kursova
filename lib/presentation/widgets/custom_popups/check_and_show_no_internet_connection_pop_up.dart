import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kursova/presentation/blocs/internet_status_bloc/internet_status_bloc.dart';
import 'package:kursova/presentation/blocs/internet_status_bloc/internet_status_state.dart';
import 'package:kursova/presentation/widgets/custom_popups/show_notification_popup.dart';

/// Shows pop up and returns true if there is no internet connections.
bool checkAndShowNoInternetConnectionPopUp(BuildContext context) {
  final internetConnectionState =
      BlocProvider.of<InternetStatusBloc>(context).state;

  if (internetConnectionState is InternetStatusDisconnected) {
    showNotificationPopUp(
      context: context,
      title: 'noInternetConnection'.tr(context: context),
      text: 'noInternetConnectionText'.tr(context: context),
      buttonText: 'ok'.tr(context: context),
    );

    return true;
  }

  return false;
}
