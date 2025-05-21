import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:flutter/material.dart';

//UI element to display content inside a ClipRRect
class MenuBox extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final double edges = 60;
  final Widget body;

  const MenuBox({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();
    return Container(
      decoration: BoxDecoration(
        color: theme?.mainBackGroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(edges),
          topRight: Radius.circular(edges),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(edges),
          topRight: Radius.circular(edges),
        ),
        child: body,
      ),
    );
  }
}
