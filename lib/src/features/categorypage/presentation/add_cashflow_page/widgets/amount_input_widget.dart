import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// AmountInputWidget is a TextField where the user can input values for saving a [Cashflow].
///
/// This widget:
/// - Only allows digits with decimal points as input
/// - Validates the input format
/// - Updates the state in [AddCashflowPage]
///
/// Parameters:
/// - [controller]: A [TextEditingController] from the [AddCashflowPage] to manage the input value
///
class AmountInputWidget extends StatelessWidget {
  final TextEditingController controller;
  const AmountInputWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        style: TextStyle(
          color: theme?.textColor ?? Colors.white,
          fontFamily: GoogleFonts.roboto().fontFamily,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Enter a valid amount";
          }
          return null;
        },
        controller: controller,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
        ], // Allows digits and one decimal point
        keyboardType: TextInputType.numberWithOptions(
          decimal: true,
        ), // Shows numeric keyboard on mobile

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

          hintText: 'Enter an amount',
          filled: true,
          fillColor: theme?.mainBackGroundColor,
        ),
      ),
    );
  }
}
