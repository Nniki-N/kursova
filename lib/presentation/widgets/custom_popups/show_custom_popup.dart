import 'package:flutter/material.dart';
import 'package:kursova/presentation/widgets/custom_buttons/custom_main_button.dart';
import 'package:kursova/resources/app_colors.dart';
import 'package:kursova/resources/app_typography.dart';
import 'package:kursova/resources/app_ui_constants.dart';

typedef DialogOptionsBuilder<T> = Map<String, T?> Function();

/// A custom basic method to show dialog popup.
///
/// [popUpTitle] is a text that is shown as a title of a dialog popup.
///
/// [popUpText] is a text that is shown as a text of a dialog popup.
///
/// [dialogOptionsBuilder] is a map of names of buttons and values that they return.
Future<T?> showGenericPopUp<T>({
  required BuildContext context,
  required String popUpTitle,
  required String popUpText,
  required DialogOptionsBuilder dialogOptionsBuilder,
  required bool barrierDismissible,
  double buttonsWidth = double.infinity,
}) async {
  final options = dialogOptionsBuilder();

  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierDismissible ? 'barrierLabel' : null,
    barrierColor: AppColors.popupOverlayColor.withOpacity(0.5),
    builder: (context) {
      const double spaceBetweenButtons = 20;

      return Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 30,
          ),
          margin: const EdgeInsets.all(20),
          constraints: const BoxConstraints(
            minWidth: 200,
            maxWidth: 520,
          ),
          decoration: BoxDecoration(
            color: AppColors.popupBackgroundColor,
            borderRadius: BorderRadius.circular(
              AppUIConstants.commonBorderRadius,
            ),
            border: Border.all(
              width: AppUIConstants.commonBorderWidth,
              color: AppColors.popupBorderColor,
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.mainShadowColor,
                blurRadius: 250,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                popUpTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: AppTypography.h1Style,
              ),
              const SizedBox(height: 20),
              const PopUpSeparator(),
              const SizedBox(height: 15),
              Text(
                popUpText,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                textAlign: TextAlign.center,
                style: AppTypography.mainTextStyle,
              ),
              const SizedBox(height: 35),
              Row(
                // Defines how to layout buttons.
                mainAxisAlignment: MainAxisAlignment.center,
                children: options.keys.map(
                  (optionTitle) {
                    final T? optionValue = options[optionTitle];

                    // Add space
                    final bool isFirst = options.keys.length > 1 &&
                        optionTitle == options.keys.first;
                    final bool isLast = options.keys.length > 1 &&
                        optionTitle == options.keys.first;

                    // If optionValue is false, then returns a CustomColors.lightRedColor button.
                    // In any other case returns a CustomColors.mainColor button.
                    if (optionValue == false) {
                      // Red button.
                      return Flexible(
                        child: Container(
                          margin: EdgeInsets.only(
                            right: isLast ? 0 : spaceBetweenButtons / 2,
                            left: isFirst ? 0 : spaceBetweenButtons / 2,
                          ),
                          child: CustomMainButton(
                            onTap: () {
                              if (optionValue != null) {
                                Navigator.of(context).pop(optionValue);
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            text: optionTitle,
                            width: buttonsWidth,
                            height: 44,
                            backgroundColor:
                                AppColors.denyButtonBackgroundColor,
                            foregroundColor:
                                AppColors.denyButtonForegroundColor,
                            borderColor: AppColors.denyButtonBorderColor,
                          ),
                        ),
                      );
                    } else {
                      // Green button.
                      return Flexible(
                        child: Container(
                          margin: EdgeInsets.only(
                            right: isLast ? 0 : spaceBetweenButtons / 2,
                            left: isFirst ? 0 : spaceBetweenButtons / 2,
                          ),
                          child: CustomMainButton(
                            onTap: () {
                              if (optionValue != null) {
                                Navigator.of(context).pop(optionValue);
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            text: optionTitle,
                            width: buttonsWidth,
                            height: 44,
                          ),
                        ),
                      );
                    }
                  },
                ).toList(),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class PopUpSeparator extends StatelessWidget {
  const PopUpSeparator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const double separatorLineWidth = 92;
    const double separatorLineHeight = 2;
    const double separatorDotSize = 7;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: separatorLineWidth,
          height: separatorLineHeight,
          decoration: BoxDecoration(
            color: AppColors.mainDarkColor,
            borderRadius: BorderRadius.circular(separatorLineHeight),
          ),
        ),
        const SizedBox(width: 14),
        Container(
          width: separatorDotSize,
          height: separatorDotSize,
          decoration: BoxDecoration(
            color: AppColors.mainDarkColor,
            borderRadius: BorderRadius.circular(separatorDotSize),
          ),
        ),
        const SizedBox(width: 14),
        Container(
          width: separatorLineWidth,
          height: separatorLineHeight,
          decoration: BoxDecoration(
            color: AppColors.mainDarkColor,
            borderRadius: BorderRadius.circular(separatorLineHeight),
          ),
        ),
      ],
    );
  }
}
