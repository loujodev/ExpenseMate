import 'package:expense_mate/src/features/categorypage/presentation/add_cashflow_page/add_cashflow_page.dart';
import 'package:expense_mate/src/shared/domain/cashflow_model.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ExpenseSwitchWidget is a switch to specify if [Cashflow] is an expense or a saving when
/// creating an instance of it on the [AddCashflowPage]
///
/// Parameters:
/// - [onExpenseChanged]: a setState()-method to update the value outside of this widget on [AddCashflowPage] if the selected value changes.

class ExpenseswitchWidget extends StatefulWidget {
  final void Function(bool) onExpenseChanged;
  const ExpenseswitchWidget({super.key, required this.onExpenseChanged});

  @override
  State<ExpenseswitchWidget> createState() => _ExpenseswitchWidgetState();
}

class _ExpenseswitchWidgetState extends State<ExpenseswitchWidget> {
  bool expense = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();

    final TextStyle styling = GoogleFonts.roboto(
      fontSize: 16,
      color: theme?.iconColor,
      fontWeight: FontWeight.w600,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(flex: 1),
        Expanded(child: Text("Saving", style: styling)),
        Expanded(
          flex: 2,
          child: Switch(
            value: expense,
            onChanged: (bool value) {
              setState(() {
                expense = value;
              });
              widget.onExpenseChanged(value);
            },
          ),
        ),
        Expanded(child: Text("Expense", style: styling)),
        Spacer(flex: 1),
      ],
    );
  }
}
