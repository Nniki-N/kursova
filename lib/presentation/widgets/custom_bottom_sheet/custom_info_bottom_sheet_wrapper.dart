import 'package:flutter/material.dart';
import 'package:kursova/presentation/widgets/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:kursova/resources/app_colors.dart';

/// A wrapper for a [child] that by clicking on it shows a custom bottom sheet.
class CustomInfoBottomSheetWrapper extends StatelessWidget {
  final Widget child;
  final String infoTitle;
  final String infoText;

  const CustomInfoBottomSheetWrapper({
    super.key,
    required this.child,
    required this.infoTitle,
    required this.infoText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          barrierColor: AppColors.mainDarkColor.withOpacity(0.10),
          isScrollControlled: true,
          builder: (context) {
            return CustomBottomSheet(
              title: infoTitle,
              text: infoText,
            );
          },
        );
      },
      child: child,
    );
  }
}
