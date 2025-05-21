import 'package:auto_size_text/auto_size_text.dart';
import 'package:expense_mate/src/shared/controllers/cashflow_controller.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

///This widget gives an overview of the total expenses and saving of the user that were saved
///It shows a progress bar that compares the expenses of the current month compared to the ones made the month before
///If no expenses were made last month the widget displays a blank progress bar.
class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  @override
  Widget build(BuildContext context) {
    final CashflowController cashflowController =
        Provider.of<CashflowController>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final double comparison = cashflowController.compareExpenseLastMonth();
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();
    final TextStyle overviewFont = GoogleFonts.roboto(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: theme?.textColor,
    );

    final TextStyle labelFont = GoogleFonts.roboto(color: theme?.textColor);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Total Expenses", style: labelFont),
                    Text(
                      cashflowController.getTotalExpensesSum().toString(),
                      style: overviewFont,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Total Savings", style: labelFont),
                    Text(
                      cashflowController.getTotalSavingsSum().toString(),
                      style: overviewFont,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              comparison == 0
                  ? Text(
                    'No expenses made last month to compare with:',
                    style: labelFont,
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        'Expenses compared to last month:',
                        style: labelFont,
                      ),
                      (comparison > 10000000000)
                          //:D
                          ? Text("Way too much mate", style: labelFont)
                          : AutoSizeText(
                            '${(comparison * 100).toStringAsFixed(1)}%',
                            style: labelFont,
                          ),
                    ],
                  ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: LinearProgressIndicator(
                    value: comparison,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      comparison > 1 ? Colors.red : Colors.green,
                    ),
                    minHeight: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
