import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  extensions: [
    CustomThemeColorsExtension(
      mainBackGroundColor: const Color.fromARGB(255, 239, 239, 239),
      secondaryBackgroundColor: const Color.fromARGB(255, 193, 193, 193),
      textColor: const Color.fromARGB(255, 0, 0, 0),
      iconColor: const Color.fromARGB(255, 109, 32, 241),
      purpleThemeColor: const Color.fromARGB(255, 109, 32, 241),
      shadowColor: const Color.fromARGB(255, 144, 143, 143),
      buttonColor: const Color.fromARGB(255, 109, 32, 241),
      menuBoxScaffoldColor: const Color.fromARGB(255, 109, 32, 241),
    ),
  ],
);
