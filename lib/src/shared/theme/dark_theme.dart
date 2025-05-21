import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  extensions: [
    CustomThemeColorsExtension(
      mainBackGroundColor: const Color.fromARGB(255, 21, 21, 21),
      secondaryBackgroundColor: const Color.fromARGB(255, 64, 64, 64),
      textColor: const Color.fromARGB(255, 255, 255, 255),
      iconColor: const Color.fromARGB(255, 255, 255, 255),
      purpleThemeColor: const Color.fromARGB(255, 109, 32, 241),
      shadowColor: const Color.fromARGB(255, 44, 44, 44),
      buttonColor: const Color.fromARGB(255, 77, 77, 77),
      menuBoxScaffoldColor: const Color.fromARGB(255, 109, 32, 241),
    ),
  ],
);
