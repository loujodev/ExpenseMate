import 'package:expense_mate/src/features/categorypage/presentation/cashflow_detail_page/cashflow_detail_page.dart';
import 'package:expense_mate/src/features/categorypage/presentation/category_detail_page/category_detail_page.dart';
import 'package:expense_mate/src/shared/controllers/category_controller.dart';
import 'package:expense_mate/src/shared/domain/cashflow_model.dart';
import 'package:expense_mate/src/shared/domain/category_model.dart' as ctg;
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:expense_mate/src/features/categorypage/presentation/add_cashflow_page/add_cashflow_page.dart';

/// CategoryPicker is a CupertinoPicker that allows the user to select one of the saved categories.
/// It is used inside [AddCashflowPage]
///
/// This widget:
/// - Allows browsing through the saved instances of [ctg.Category] and selecting an instance to store it inside [_CategoryPickerState.selectedCategory]
/// - Will automatically select the first [ctg.Category] of [CategoryController.categories] if no [initialCategory] is provided
///
///
/// Parameters:
/// - [initialCategory]: (optional) An initially selected category. Given if the [AddCashflowPage] is accessed through the [CategoryDetailPage]
/// or accessed through the [CashflowDetailPage] to edit the category of an existing [Cashflow].
///
/// - [onCategorySelected]: a setState()-Method to update the value of the selected category on [AddCashflowPage] if the selected item changes.
class CategoryPicker extends StatefulWidget {
  final ctg.Category? initialCategory;
  final Function(ctg.Category) onCategorySelected;
  const CategoryPicker({
    super.key,
    this.initialCategory,
    required this.onCategorySelected,
  });

  @override
  _CategoryPickerState createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {
  ctg.Category? selectedCategory;
  late CategoryController categoryProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    categoryProvider = Provider.of<CategoryController>(context, listen: false);

    // Use the initialCategory if provided, otherwise default to the first category
    if (widget.initialCategory != null) {
      selectedCategory = widget.initialCategory;
    } else if (categoryProvider.categories.isNotEmpty) {
      selectedCategory = categoryProvider.categories.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();
    final categories = categoryProvider.categories;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 350,
                color: theme?.mainBackGroundColor,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoButton(
                          child: const Text('Done'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem:
                              selectedCategory != null
                                  ? categories.indexOf(selectedCategory!)
                                  : 0,
                        ),
                        itemExtent: 40,
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            selectedCategory = categories[index];
                          });
                          widget.onCategorySelected(categories[index]);
                        },
                        children:
                            categories.map((category) {
                              return Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      color: theme?.textColor,
                                      IconData(
                                        category.iconIndex,
                                        fontFamily: 'MaterialIcons',
                                      ),
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      category.name,
                                      style: TextStyle(color: theme?.textColor),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: theme?.mainBackGroundColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: theme?.secondaryBackgroundColor ?? Colors.amber,
              width: 2.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (selectedCategory != null)
                Row(
                  children: [
                    Icon(
                      color: theme?.textColor,
                      IconData(
                        selectedCategory!.iconIndex,
                        fontFamily: 'MaterialIcons',
                      ),
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      selectedCategory!.name,
                      style: TextStyle(
                        color: theme?.textColor ?? Colors.white,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  'Select a category',
                  style: TextStyle(color: theme?.textColor),
                ),
              Icon(Icons.arrow_drop_down, color: theme?.mainBackGroundColor),
            ],
          ),
        ),
      ),
    );
  }
}
