import 'package:expense_mate/src/features/categorypage/presentation/add_category_page/widgets/add_category_button.dart';
import 'package:expense_mate/src/features/categorypage/presentation/category_detail_page/category_detail_page.dart';
import 'package:expense_mate/src/features/categorypage/presentation/category_page.dart';
import 'package:expense_mate/src/shared/controllers/cashflow_controller.dart';
import 'package:expense_mate/src/shared/controllers/category_controller.dart';
import 'package:expense_mate/src/shared/controllers/theme_controller.dart';
import 'package:expense_mate/src/shared/domain/category_model.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// CategoryButtons is [SliverGrid] of Buttons directing to various pages.
/// It can be found on the [CategoryPage].
///
///
/// This widget:
/// - Creates a button for every existing category inside the categories list of the [CategoryController].
/// - Creates an [AddCategoryButton] at the end of the grid.
/// - Each button (except for the [AddCategoryButton]) redirects to the corresponding [CategoryDetailPage] of the category.

class CategoryButtons extends StatefulWidget {
  const CategoryButtons({super.key});

  @override
  State<CategoryButtons> createState() => _CategoryButtonsState();
}

class _CategoryButtonsState extends State<CategoryButtons> {
  @override
  Widget build(BuildContext context) {
    final double padding = MediaQuery.of(context).size.width * 0.04;
    final double spacing = MediaQuery.of(context).size.width * 0.03;
    final categoryController = Provider.of<CategoryController>(context);
    final cashflowController = Provider.of<CashflowController>(context);
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();
    final themeController = Provider.of<ThemeController>(context);

    return CustomScrollView(
      shrinkWrap: true, // Ensures the grid takes only the required space
      physics: const NeverScrollableScrollPhysics(), // Disables scrolling
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(padding),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              childAspectRatio: 1,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index < categoryController.categories.length) {
                final category = categoryController.categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CategoryDetailPage(category: category),
                      ),
                    );
                  },
                  onLongPress: () {
                    _showCategoryDeleteOption(
                      context,
                      category,
                      categoryController,
                      cashflowController,
                      themeController,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.03,
                    ),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          size: 30,
                          color: theme?.iconColor,
                          IconData(
                            category.iconIndex,
                            fontFamily: 'MaterialIcons',
                          ),
                        ),
                        Text(
                          category.name,
                          style: GoogleFonts.roboto(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: theme?.iconColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return AddCategoryButton();
              }
            }, childCount: categoryController.categories.length + 1),
          ),
        ),
      ],
    );
  }

  void _showCategoryDeleteOption(
    BuildContext context,
    Category category,
    CategoryController categoryController,
    CashflowController cashflowController,
    ThemeController themeController,
  ) {
    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => CupertinoTheme(
            data: CupertinoThemeData(
              brightness:
                  themeController.isDark ? Brightness.dark : Brightness.light,
            ),
            child: CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                    _showAlertDialog(
                      context,
                      category,
                      categoryController,
                      cashflowController,
                      themeController,
                    );
                  },
                  child: Text(
                    'Delete Category',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ),
          ),
    );
  }

  /// Shows an alert dialog when the user decides to delete a category and informs him about the cascading deletion.
  /// ToDo: ThemeSpecific colors.
  // In your _showAlertDialog method:
  void _showAlertDialog(
    BuildContext context,
    Category category,
    CategoryController categoryController,
    CashflowController cashflowController,
    ThemeController themeController,
  ) {
    showCupertinoDialog<void>(
      context: context,
      builder:
          (BuildContext context) => CupertinoTheme(
            data: CupertinoThemeData(
              brightness:
                  themeController.isDark ? Brightness.dark : Brightness.light,
            ),
            child: CupertinoAlertDialog(
              title: const Text(
                'If you delete the category, all associated expenses/savings are also deleted',
              ),
              content: const Text('Do you want to proceed?'),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () => Navigator.pop(context),
                  child: const Text('No'),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () async {
                    categoryController.removeCategory(
                      category,
                      cashflowController,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          ),
    );
  }
}
