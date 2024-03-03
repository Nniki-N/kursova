import 'package:flutter/material.dart';
import 'package:kursova/presentation/widgets/custom_popups/show_custom_popup.dart';

/// A custom method that shows just a notification dialog popup.
///
/// [popUpTitle] is a text that is shown as a title of a dialog popup.
///
/// [popUpText] is a text that is shown as a text of a dialog popup.
///
/// [buttonText] is a text of the button that describes it`s meaning.
/// The button returns nothing, just hides popup.
Future<void> showNotificationPopUp({
  required BuildContext context,
  required String popUpTitle,
  required String popUpText,
  required String buttonText,
}) async {
  return showGenericPopUp(
    context: context,
    popUpTitle: popUpTitle,
    popUpText: popUpText,
    dialogOptionsBuilder: () => {
      buttonText: null,
    },
    barrierDismissible: true,
    buttonsWidth: 130,
  ).then((value) => null);
}
