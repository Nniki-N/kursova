import 'package:country_flags/country_flags.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kursova/core/app_localization.dart';
import 'package:kursova/resources/app_colors.dart';
import 'package:kursova/resources/app_typography.dart';

class LanguageDropdown extends StatefulWidget {
  const LanguageDropdown({super.key});

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  late Locale selectedLocale;
  final List<Locale> locales = AppLocalization.supportedLocales;

  @override
  void didChangeDependencies() {
    selectedLocale = context.locale;
    super.didChangeDependencies();
  }

  String languageText({required Locale locale}) {
    if (locale.languageCode == AppLocalization.ukLocale.languageCode) {
      return 'УК';
    } else {
      return 'US';
    }
  }

  @override
  Widget build(BuildContext context) {
    const double dropdownWidth = 88;

    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          value: selectedLocale,
          onChanged: (locale) {
            if (locale == null) {
              return;
            }

            setState(() {
              selectedLocale = locale;
              context.setLocale(locale);
            });
          },
          customButton: Container(
            width: dropdownWidth,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: AppColors.mainDarkColor.withOpacity(0.25),
                  blurRadius: 50,
                  spreadRadius: 3,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CountryFlag.fromCountryCode(
                  selectedLocale.countryCode!,
                  height: 20,
                  width: 26,
                  borderRadius: 0,
                ),
                const SizedBox(width: 8),
                Text(
                  languageText(locale: selectedLocale),
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                  style: AppTypography.secondTextStyle,
                ),
              ],
            ),
          ),
          items: locales
              .map(
                (locale) => DropdownMenuItem<Locale>(
                  value: locale,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CountryFlag.fromCountryCode(
                        locale.countryCode!,
                        height: 20,
                        width: 26,
                        borderRadius: 0,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        languageText(locale: locale),
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.center,
                        style: AppTypography.secondTextStyle,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          buttonStyleData: ButtonStyleData(
            elevation: 8,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.mainDarkColor.withOpacity(0.25),
                  blurRadius: 50,
                  spreadRadius: 3,
                )
              ],
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 15),
          ),
          dropdownStyleData: DropdownStyleData(
            width: dropdownWidth,
            padding: EdgeInsets.zero,
            scrollPadding: EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: AppColors.backgroundColor,
            ),
            offset: const Offset(0, -5),
          ),
        ),
      ),
    );
  }
}
