import 'dart:math';
import 'package:expense_mate/src/features/categorypage/presentation/add_category_page/widgets/category_buttons.dart';
import 'package:expense_mate/src/shared/presentation/widgets/add_cashflow_button.dart';
import 'package:expense_mate/src/features/categorypage/presentation/category_detail_page/cash_flow_list.dart';
import 'package:expense_mate/src/shared/controllers/cashflow_controller.dart';
import 'package:expense_mate/src/shared/domain/cashflow_model.dart';
import 'package:expense_mate/src/shared/domain/category_model.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:expense_mate/src/shared/presentation/widgets/header_widget.dart';
import 'package:expense_mate/src/shared/presentation/widgets/icon_box.dart';
import 'package:expense_mate/src/shared/presentation/widgets/menu_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// CategoryDetailPage can be accessed by clicking on one of the [CategoryButtons].
/// It summarizes the expenses/savings made within that category and displays all [Cashflow] objects of that [Category] on a [CashFlowList]
///
///
/// Parameters:
/// -[category]: the category to show details about and to filter the [CashFlowList]
///
class CategoryDetailPage extends StatefulWidget {
  final Category category;

  const CategoryDetailPage({super.key, required this.category});
  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();
    final cashflowProvider = Provider.of<CashflowController>(context);
    final List<Cashflow> categoryCashflow =
        cashflowProvider.cashflows
            .where((i) => i.categoryId == widget.category.id)
            .toList();

    return Scaffold(
      backgroundColor: theme?.menuBoxScaffoldColor,
      body: Column(
        children: [
          HeaderWidget(text: widget.category.name),
          Expanded(
            flex: 7,
            child: MenuBox(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: screenWidth * 0.1),
                            IconBox(
                              iconIndex: widget.category.iconIndex,
                              screenHeight: screenHeight,
                              context: context,
                            ),
                            SizedBox(width: screenWidth * 0.08),
                            Column(
                              children: [
                                Text(
                                  cashflowSummary(categoryCashflow) > 0
                                      ? 'Total Savings'
                                      : 'Total Expenses: ',
                                  style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: theme?.textColor,
                                  ),
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: screenWidth * 0.3,
                                    minWidth: screenWidth * 0.2,
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    cashflowSummary(
                                      categoryCashflow,
                                    ).toString(),
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          cashflowSummary(categoryCashflow) > 0
                                              ? Colors.green
                                              : Colors.redAccent,
                                      fontSize: max(
                                        13,
                                        40 -
                                            (cashflowSummary(
                                                  categoryCashflow,
                                                ).toString().length *
                                                2),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          child: CashFlowList(cashflowList: categoryCashflow),
                        ),
                      ],
                    ),
                  ),
                  // Keep the button at the bottom
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AddCashflowButton(
                        edit: false,
                        chosenCategory: widget.category,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Adds up all expenses and savings, subtracts them from each other and returns the result
  double cashflowSummary(List<Cashflow> cashflows) {
    List<Cashflow> expenseList = cashflows.where((i) => i.isExpense).toList();
    List<Cashflow> savingsList =
        cashflows.where((i) => i.isExpense == false).toList();

    double expenses = 0;
    double savings = 0;

    for (var expense in expenseList) {
      expenses = expenses - expense.amount;
    }

    for (var saving in savingsList) {
      savings = savings + saving.amount;
    }

    return expenses + savings;
  }
}
