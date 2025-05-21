import 'package:expense_mate/src/features/categorypage/presentation/add_cashflow_page/add_cashflow_page.dart';
import 'package:expense_mate/src/shared/domain/cashflow_model.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// DescriptionInputWidget is a TextField that allows the user to enter a name for a [Cashflow]
///
///
/// This widget:
/// - Has a validator that ensures the title can not be empty.
///
/// Parameters:
/// - [controller]: A [TextEditingController] passed from the AddCashflowPage to access the entered text outside of this widget in [AddCashflowPage].

class TitleInputWidget extends StatelessWidget {
  final TextEditingController controller;
  const TitleInputWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.07,
        child: TextFormField(
          style: TextStyle(
            color: theme?.textColor ?? Colors.white,
            fontFamily: GoogleFonts.roboto().fontFamily,
          ),
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter a valid title";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: theme?.mainBackGroundColor ?? Colors.grey,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: theme?.secondaryBackgroundColor ?? Colors.grey,
                width: 2.0,
              ),
            ),
            hintText: 'Enter a title', // Changed to match numeric input
            filled: true,
            fillColor: theme?.mainBackGroundColor,
          ),
        ),
      ),
    );
  }
}
