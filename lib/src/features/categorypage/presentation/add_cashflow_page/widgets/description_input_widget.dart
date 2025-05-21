import 'package:expense_mate/src/features/categorypage/presentation/add_cashflow_page/add_cashflow_page.dart';
import 'package:expense_mate/src/shared/domain/cashflow_model.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// DescriptionInputWidget is an optional TextField that allows the user to enter a text when creating a [Cashflow]
///
///
/// This widget:
/// - Has no validators and can be empty due to it being an optional property of [Cashflow]
///
/// Parameters:
/// - [controller]: A [TextEditingController] passed from the AddCashflowPage to access the entered text outside of this widget in [AddCashflowPage].
///
class DescriptionInputWidget extends StatelessWidget {
  final TextEditingController controller;
  const DescriptionInputWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        child: TextField(
          style: TextStyle(
            color: theme?.textColor ?? Colors.white,
            fontFamily: GoogleFonts.roboto().fontFamily,
          ),
          controller: controller,
          maxLines: 10,
          onChanged: (value) {},
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: theme?.secondaryBackgroundColor ?? Colors.grey,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: theme?.secondaryBackgroundColor ?? Colors.grey,
                width: 2,
              ),
            ),
            hintText: 'Enter a description (optional)',
            filled: true,
            fillColor: theme?.mainBackGroundColor,
          ),
        ),
      ),
    );
  }
}
