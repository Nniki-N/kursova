import 'package:flutter/material.dart';
import 'package:kursova/resources/app_colors.dart';
import 'package:kursova/resources/app_typography.dart';
import 'package:kursova/resources/app_ui_constants.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

/// Shows a custom error snackbar on top of the screen with animation of appearing and disappearing.
/// The snackbar will disappear after [displayDurationInSeconds] seconds.
void showCustomErrorSnackbar({
  required BuildContext context,
  required String title,
  required String text,
  int displayDurationInSeconds = 4,
}) =>
    showTopSnackBar(
      Overlay.of(context),
      CustomErrorSnackBar(
        title: title,
        text: text,
      ),
      curve: Curves.linearToEaseOut,
      animationDuration: const Duration(milliseconds: 600),
      displayDuration: Duration(seconds: displayDurationInSeconds),
    );

class CustomErrorSnackBar extends StatefulWidget {
  const CustomErrorSnackBar({
    Key? key,
    required this.title,
    required this.text,
  }) : super(key: key);

  final String title;
  final String text;

  @override
  State<CustomErrorSnackBar> createState() => _CustomErrorSnackBarState();
}

class _CustomErrorSnackBarState extends State<CustomErrorSnackBar> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 30,
        ),
        constraints: const BoxConstraints(
          maxWidth: 800,
          minWidth: 300,
        ),
        decoration: BoxDecoration(
          color: AppColors.snackbarErrorBackgroundColor,
          borderRadius: BorderRadius.circular(
            AppUIConstants.commonBorderRadius,
          ),
          border: Border.all(
            width: AppUIConstants.commonBorderWidth,
            color: AppColors.snackbarErrorBorderColor,
          ),
        ),
        child: Column(
          textDirection: TextDirection.ltr,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle(
              style: AppTypography.h2Style.copyWith(
                color: AppColors.snackbarErrorForegroundColor,
              ),
              child: Text(widget.title),
            ),
            const SizedBox(height: 5),
            DefaultTextStyle(
              style: AppTypography.mainTextStyle.copyWith(
                color: AppColors.snackbarErrorForegroundColor,
              ),
              child: Text(widget.text),
            ),
          ],
        ),
      ),
    );
  }
}
