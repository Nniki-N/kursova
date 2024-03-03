import 'package:flutter/material.dart';
import 'package:kursova/resources/app_colors.dart';
import 'package:kursova/resources/app_typography.dart';
import 'package:kursova/resources/app_ui_constants.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void showCustomSnackbar({
  required BuildContext context,
  required String title,
  required String text,
  int displayDurationInSeconds = 4,
}) =>
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar(
        title: title,
        text: text,
      ),
      curve: Curves.linearToEaseOut,
      animationDuration: const Duration(milliseconds: 600),
      displayDuration: Duration(seconds: displayDurationInSeconds),
    );

class CustomSnackBar extends StatefulWidget {
  const CustomSnackBar({
    Key? key,
    required this.title,
    required this.text,
  }) : super(key: key);

  final String title;
  final String text;

  @override
  State<CustomSnackBar> createState() => _CustomSnackBarState();
}

class _CustomSnackBarState extends State<CustomSnackBar> {
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
          color: AppColors.snackbarBackgroundColor,
          borderRadius: BorderRadius.circular(
            AppUIConstants.commonBorderRadius,
          ),
          border: Border.all(
            width: AppUIConstants.commonBorderWidth,
            color: AppColors.snackbarBorderColor,
          ),
        ),
        child: Column(
          textDirection: TextDirection.ltr,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle(
              style: AppTypography.h2Style.copyWith(
                color: AppColors.snackbarForegroundColor,
              ),
              child: Text(widget.title),
            ),
            const SizedBox(height: 5),
            DefaultTextStyle(
              style: AppTypography.mainTextStyle.copyWith(
                color: AppColors.snackbarForegroundColor,
              ),
              child: Text(widget.text),
            ),
          ],
        ),
      ),
    );
  }
}
