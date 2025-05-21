import 'package:flutter/material.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';

//UI Element to display an Icon inside a box with shadows
class IconBox extends StatelessWidget {
  final int iconIndex;
  final double screenHeight;
  final BuildContext context;

  const IconBox({
    super.key,
    required this.iconIndex,
    required this.screenHeight,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();

    return Container(
      padding: EdgeInsets.all(screenHeight * 0.03),
      decoration: BoxDecoration(
        color: theme?.mainBackGroundColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: theme?.shadowColor ?? Colors.black,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Icon(
          IconData(iconIndex, fontFamily: 'MaterialIcons'),
          size: screenHeight * 0.08,
          color: theme?.iconColor,
        ),
      ),
    );
  }
}
