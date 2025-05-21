import 'package:expense_mate/src/features/categorypage/presentation/cashflow_detail_page/cashflow_detail_page.dart';
import 'package:expense_mate/src/features/categorypage/presentation/category_detail_page/category_detail_page.dart';
import 'package:expense_mate/src/features/dashboardpage/dashboard_page.dart';
import 'package:expense_mate/src/shared/controllers/category_controller.dart';
import 'package:expense_mate/src/shared/domain/cashflow_model.dart';
import 'package:expense_mate/src/shared/domain/category_model.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// CashFlowList is a a list of two nested [ListView.builder] to display a list of cashflows.
/// The first [ListView.builder] is used to display the months of all existing cashflows.
/// The second [ListView.builder] is used to display the cashflows beneath the corresponding month.
///
/// Example:
///
/// -MAY
/// ---Cashflow1
/// ---Cashflow2
/// February
/// ---Cashflow1
/// ---Cashflow1
///
/// It is used on the [DashboardPage] and on the [CategoryDetailPage].
/// Depending on which page it used on it either shows all cashflows that were added by the user
/// or just the ones that match the category of the [CategoryDetailPage]
///
/// Parameters:
/// -[cashflowList]: the list of cashflows that should be displayed. It is already prefiltered before it is given as an parameter to display on the [CategoryDetailPage]
///
class CashFlowList extends StatefulWidget {
  final List<Cashflow> cashflowList;

  const CashFlowList({super.key, required this.cashflowList});

  @override
  State<CashFlowList> createState() => _CashFlowListState();
}

class _CashFlowListState extends State<CashFlowList> {
  @override
  Widget build(BuildContext context) {
    CategoryController categoryController = Provider.of<CategoryController>(
      context,
    );
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenWidth * 0.04;
    final double spacing = screenHeight * 0.01;
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();

    final monthlySplit = mapOfMonhtlyLists(widget.cashflowList);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: monthlySplit.length,
      itemBuilder: (context, index) {
        String monthKey = monthlySplit.keys.elementAt(index);
        List<Cashflow> monthlyCashflows = monthlySplit[monthKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: padding),
              child: Text(
                monthKey,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme?.textColor,
                  fontSize: 16,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemCount: monthlyCashflows.length,
              itemBuilder: (BuildContext context, int cashflowIndex) {
                Cashflow cashflow = monthlyCashflows[cashflowIndex];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CashflowDetailPage(cashflow: cashflow),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: spacing),
                    padding: EdgeInsets.all(padding),
                    height: 70,
                    color: theme?.mainBackGroundColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: theme?.mainBackGroundColor,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: theme?.shadowColor ?? Colors.black,
                                blurRadius: 4,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              size: 20,
                              color: theme?.iconColor,
                              IconData(
                                getIconDataByCashflow(
                                  cashflow,
                                  categoryController,
                                ),
                                fontFamily: 'MaterialIcons',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: padding),
                        // Title & Date
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cashflow.title,
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: theme?.iconColor,
                                ),
                              ),
                              Text(
                                formatHourMinuteDate(cashflow.date),
                                style: GoogleFonts.roboto(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: theme?.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          cashflow.isExpense
                              ? '-${cashflow.amount.toString()}'
                              : '+${cashflow.amount.toString()}',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: theme?.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  String formatMonthYear(String date) {
    final convert = DateTime.parse('$date-01');
    return DateFormat('MMMM yyyy').format(convert);
  }

  String formatHourMinuteDate(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);

    if (dateTime.hour == 0 && dateTime.minute == 0) {
      // Nur Datum anzeigen (z.B. "Apr 11")
      return DateFormat('MMM dd').format(dateTime);
    } else {
      // Datum und Uhrzeit anzeigen (z.B. "Apr 11 - 21:45")
      return '${DateFormat('MMM dd').format(dateTime)} - ${DateFormat('HH:mm').format(dateTime)}';
    }
  }

  Map<String, List<Cashflow>> mapOfMonhtlyLists(List<Cashflow> cashflowList) {
    //Iterates over all Cashflows inside the List and creates a List of cashflows
    //for each month of the cashflows inside the List
    //Returns a Map of Lists with the month of the cashflows inside the list as key

    final monthlyLists = <String, List<Cashflow>>{};
    if (cashflowList.isEmpty) return monthlyLists;

    cashflowList.sort((b, a) => a.date.compareTo(b.date));

    List<Cashflow> tempList = [];
    String temp = formatMonthYear(cashflowList.first.date);

    for (var cashflow in cashflowList) {
      if (temp == formatMonthYear(cashflow.date)) {
        tempList.add(cashflow);
      } else {
        monthlyLists[temp] = tempList;
        tempList = [cashflow];
        temp = formatMonthYear(cashflow.date);
      }
    }

    monthlyLists[temp] = tempList;
    return monthlyLists;
  }

  int getIconDataByCashflow(
    Cashflow cashflow,
    CategoryController categoryController,
  ) {
    try {
      return categoryController.categories
          .firstWhere(
            (cat) => cat.id == cashflow.categoryId,
            orElse:
                () => Category(
                  id: 0,
                  name: 'Unknown',
                  iconIndex: 0xe59b,
                ), // Default icon
          )
          .iconIndex;
    } catch (e) {
      return 0xe59b; // Fallback icon code
    }
  }
}
