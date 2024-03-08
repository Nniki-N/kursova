import 'package:flutter/material.dart';
import 'package:kursova/presentation/widgets/custom_popups/show_custom_popup.dart';

/// Shows a notification dialog popup.
/// 
/// The button of the popup returns nothing, just hides popup.
Future<void> showNotificationPopUp({
  required BuildContext context,
  required String title,
  required String text,
  required String buttonText,
}) async {
  return showGenericPopUp(
    context: context,
    title: title,
    text: text,
    dialogOptionsBuilder: () => {
      buttonText: null,
    },
    barrierDismissible: true,
    buttonsWidth: 130,
  ).then((value) => null);
}
