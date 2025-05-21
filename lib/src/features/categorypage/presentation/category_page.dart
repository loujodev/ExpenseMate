import 'package:expense_mate/src/features/categorypage/presentation/add_category_page/add_category_page.dart';
import 'package:expense_mate/src/features/categorypage/presentation/category_detail_page/category_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:expense_mate/src/features/categorypage/presentation/add_category_page/widgets/category_buttons.dart';
import 'package:expense_mate/src/shared/presentation/overview/overview.dart';

///CategoryPage is the second of the three main pages inside the app
///It displays an [Overview] of the total expenses and savings the user has made.
///And provides [CategoryButtons] to redirect the user to a [CategoryDetailPage] or [AddCategoryPage]
///
class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();

    return Scaffold(
      backgroundColor: theme?.mainBackGroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.1),
            Overview(),
            SizedBox(height: screenHeight * 0.05),
            CategoryButtons(),
          ],
        ),
      ),
    );
  }
}
