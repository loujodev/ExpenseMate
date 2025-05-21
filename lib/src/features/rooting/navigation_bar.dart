import 'package:expense_mate/src/features/rooting/root.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:flutter/material.dart';

///Custom NavigationBar that indicates which page the user is currently on
///
///Parameters:
///[selectedIndex] : index of the page the user wants to direct to
///[onDestinationSelected] : function to update a [PageController] outside of this widget in [MainScreen] and trigger the animation

class NavigationBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const NavigationBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();

    return Container(
      height: screenHeight * 0.1,
      width: screenWidth * 0.85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme?.buttonColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: selectedIndex == 0 ? Colors.white : Colors.white54,
              ),
              onPressed: () => onDestinationSelected(0),
            ),
            IconButton(
              icon: Icon(
                Icons.category,
                color: selectedIndex == 1 ? Colors.white : Colors.white54,
              ),
              onPressed: () => onDestinationSelected(1),
            ),
            IconButton(
              icon: Icon(
                Icons.account_circle,
                color: selectedIndex == 2 ? Colors.white : Colors.white54,
              ),
              onPressed: () => onDestinationSelected(2),
            ),
          ],
        ),
      ),
    );
  }
}
