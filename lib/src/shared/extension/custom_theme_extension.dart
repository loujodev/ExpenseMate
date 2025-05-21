import 'package:flutter/material.dart';

class CustomThemeColorsExtension
    extends ThemeExtension<CustomThemeColorsExtension> {
  final Color? mainBackGroundColor;
  final Color? secondaryBackgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final Color? purpleThemeColor;
  final Color? shadowColor;
  final Color? buttonColor;
  final Color? menuBoxScaffoldColor;

  CustomThemeColorsExtension({
    required this.mainBackGroundColor,
    required this.secondaryBackgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.purpleThemeColor,
    required this.shadowColor,
    required this.buttonColor,
    required this.menuBoxScaffoldColor,
  });

  @override
  ThemeExtension<CustomThemeColorsExtension> copyWith({
    Color? mainBackGroundColor,
    Color? secondaryBackgroundColor,
    Color? textColor,
    Color? secondaryTextColor,
    Color? barChartColor,
    Color? shadowColor,
    Color? menuBoxScaffoldColor,
  }) {
    return CustomThemeColorsExtension(
      mainBackGroundColor: mainBackGroundColor ?? this.mainBackGroundColor,
      secondaryBackgroundColor:
          secondaryBackgroundColor ?? this.secondaryBackgroundColor,
      textColor: textColor ?? this.textColor,
      iconColor: iconColor ?? iconColor,
      purpleThemeColor: barChartColor ?? purpleThemeColor,
      shadowColor: shadowColor ?? this.shadowColor,
      buttonColor: buttonColor ?? buttonColor,
      menuBoxScaffoldColor: menuBoxScaffoldColor ?? this.menuBoxScaffoldColor,
    );
  }

  @override
  ThemeExtension<CustomThemeColorsExtension> lerp(
    ThemeExtension<CustomThemeColorsExtension>? other,
    double t,
  ) {
    if (other is! CustomThemeColorsExtension) {
      return this;
    }
    return CustomThemeColorsExtension(
      mainBackGroundColor: Color.lerp(
        mainBackGroundColor,
        other.mainBackGroundColor,
        t,
      ),
      secondaryBackgroundColor: Color.lerp(
        secondaryBackgroundColor,
        other.secondaryBackgroundColor,
        t,
      ),
      textColor: Color.lerp(textColor, other.textColor, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      purpleThemeColor: Color.lerp(iconColor, other.iconColor, t),
      shadowColor: Color.lerp(iconColor, other.iconColor, t),
      buttonColor: Color.lerp(iconColor, other.iconColor, t),
      menuBoxScaffoldColor: Color.lerp(iconColor, other.iconColor, t),
    );
  }
}
