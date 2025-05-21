import 'package:expense_mate/src/features/categorypage/presentation/add_category_page/add_category_page.dart';
import 'package:expense_mate/src/features/categorypage/presentation/add_category_page/widgets/category_buttons.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:flutter/material.dart';

/// AddCategory is the last button displayed inside [CategoryButtons].
/// Clicking on it redirects the user to the [AddCategoryPage]
class AddCategoryButton extends StatefulWidget {
  const AddCategoryButton({super.key});

  @override
  State<AddCategoryButton> createState() => _AddCategoryButtonState();
}

class _AddCategoryButtonState extends State<AddCategoryButton> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddCategoryPage()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(screenHeight * 0.03),
        decoration: BoxDecoration(
          color: theme?.mainBackGroundColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: theme?.shadowColor ?? Colors.black,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(Icons.add, size: 25, color: theme?.iconColor),
      ),
    );
  }
}
