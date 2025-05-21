import 'package:expense_mate/src/features/categorypage/presentation/add_cashflow_page/add_cashflow_page.dart';
import 'package:expense_mate/src/features/dashboardpage/dashboard_page.dart';
import 'package:expense_mate/src/shared/domain/cashflow_model.dart';
import 'package:expense_mate/src/shared/domain/category_model.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The AddCashflowButton is used to either save a new [Cashflow] or edit an existing one
/// It is used on the [DashboardPage] and the [CashlowDetailPage]
///
/// Parameters:
/// [edit] : bool indicating wether a new cashflow gets created or an existing [cashflow] should get edited
/// [cashflow] : optional, the cashflow to edit. Is given if [edit] is true and gets passed to [AddCashflowPage]
/// [chosenCategory] : opitonal, given if [edit] is true and gets passed to [AddCashflowPage]

class AddCashflowButton extends StatefulWidget {
  final bool edit;
  final Cashflow? cashflow;
  final Category? chosenCategory; //
  const AddCashflowButton({
    super.key,
    required this.edit,
    this.cashflow,
    this.chosenCategory,
  });
  @override
  State<AddCashflowButton> createState() => _AddCashflowButtonState();
}

class _AddCashflowButtonState extends State<AddCashflowButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();
    final TextStyle styling = GoogleFonts.roboto(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
        color: theme?.purpleThemeColor,
        borderRadius: BorderRadius.all(Radius.circular(35)),
        boxShadow: [
          BoxShadow(
            color: theme?.shadowColor ?? Colors.blue,
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color?>(theme?.buttonColor),
        ),

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AddCashflowPage(
                    edit: widget.edit,
                    cashflow: widget.cashflow,
                    chosenCategory: widget.chosenCategory,
                  ),
            ),
          );
        },
        child: Center(
          child: Text(
            widget.edit ? "Edit" : "Add Expense/Saving",
            style: styling,
          ),
        ),
      ),
    );
  }
}
