import 'package:expense_mate/src/features/categorypage/presentation/add_category_page/widgets/add_category_button.dart';
import 'package:expense_mate/src/features/categorypage/presentation/add_category_page/widgets/icon_select.dart';
import 'package:expense_mate/src/features/categorypage/presentation/category_page.dart';
import 'package:expense_mate/src/shared/config/config.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:expense_mate/src/shared/presentation/widgets/header_widget.dart';
import 'package:expense_mate/src/shared/presentation/widgets/menu_box.dart';
import 'package:flutter/material.dart';
import 'package:expense_mate/src/shared/controllers/category_controller.dart';
import 'package:provider/provider.dart';
import 'package:expense_mate/src/shared/domain/category_model.dart' as ct;

/// AddCategoryPage is a page that can be accessed by clicking the [AddCategoryButton] on the [CategoryPage]
///
///
/// This widget:
/// - Contains a textfield to enter a custom name for your category
/// - Contains a [SelectIconWidget], which is a CupertinoPicker to display and select predefined icons (can be found in config.dart)
/// - Contains a button to create and save [ct.Category] object to the database
/// - Has two optional parameters which are used to temporarily store the values for the [ct.Category] object before saving them
///

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  ///Parameters to temporarily store the values for creating the [ct.Category]
  String? _category;
  IconData? _icon = expenseCategories[0]['icon'];

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryController>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();

    return Scaffold(
      backgroundColor: theme?.menuBoxScaffoldColor,
      body: Column(
        children: [
          const HeaderWidget(text: "Add Category"),
          Expanded(
            flex: 7,
            child: MenuBox(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: screenHeight * 0.05),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _category = value;
                        });
                      },
                      style: TextStyle(color: theme?.textColor),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Enter a name for your category',
                        filled: true,
                        fillColor: theme?.mainBackGroundColor,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    SelectIconWidget(
                      initialValue: 'Groceries',
                      onChanged: (String value, IconData icon) {
                        setState(() {
                          _icon = icon;
                        });
                      },
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (_category != null && _icon != null) {
                          final category = ct.Category(
                            name: _category!,
                            iconIndex: _icon!.codePoint,
                          );
                          categoryProvider.addCategory(category);
                          setState(() {
                            _category = null;
                            _icon = expenseCategories[0]['icon'];
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Save', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
