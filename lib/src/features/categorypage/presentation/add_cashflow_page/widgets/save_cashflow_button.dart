import 'package:expense_mate/src/features/categorypage/presentation/add_cashflow_page/add_cashflow_page.dart';
import 'package:expense_mate/src/shared/domain/cashflow_model.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// SaveCashflowButton is used on the [AddCashflowPage] to save an instance of [Cashflow] to the local database.
/// On press it executes the given method which is specified outside of the widget in [AddCashflowPage]
///
/// Parameters:
/// [save]: A method to save a [Cashflow]. Implemented outside of this widget in [AddCashflowPage].
///
class SaveCashflowButton extends StatelessWidget {
  final VoidCallback save;
  const SaveCashflowButton({super.key, required this.save});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();
    final TextStyle styling = GoogleFonts.roboto(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );
    return Container(
      decoration: BoxDecoration(
        color: theme?.purpleThemeColor,
        borderRadius: BorderRadius.all(Radius.circular(35)),
        boxShadow: [
          BoxShadow(
            color: theme?.shadowColor ?? Colors.blue,
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.07,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color?>(theme?.buttonColor),
        ),
        onPressed: save,
        child: Center(child: Text("Save", style: styling)),
      ),
    );
  }
}
