import 'dart:math';
import 'package:expense_mate/src/features/categorypage/presentation/add_cashflow_page/add_cashflow_page.dart';
import 'package:expense_mate/src/features/categorypage/presentation/category_detail_page/cash_flow_list.dart';
import 'package:expense_mate/src/shared/presentation/widgets/add_cashflow_button.dart';
import 'package:expense_mate/src/shared/controllers/cashflow_controller.dart';
import 'package:expense_mate/src/shared/controllers/category_controller.dart';
import 'package:expense_mate/src/shared/domain/category_model.dart';
import 'package:expense_mate/src/shared/presentation/widgets/icon_box.dart';
import 'package:expense_mate/src/shared/presentation/widgets/menu_box.dart';
import 'package:expense_mate/src/shared/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:expense_mate/src/shared/domain/cashflow_model.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:expense_mate/src/shared/presentation/widgets/header_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// CashflowDetailPage is a page that can be accessed by clicking on any cashflow inside a [CashFlowList]
/// It is used to show information about the [Cashflow] e.g title, amount, location, notes...
///
/// Additionally it has a button on the top right of the screen to delete the [Cashflow] object and reschedule the daily notification
/// (To recalculate the expenses for that day- for more info [NotificationService])
/// And a [AddCashflowButton] to redirect a user to the [AddCashflowPage] with a preselected [Cashflow].

class CashflowDetailPage extends StatefulWidget {
  final Cashflow cashflow;
  const CashflowDetailPage({super.key, required this.cashflow});

  @override
  State<CashflowDetailPage> createState() => _CashflowDetailPageState();
}

class _CashflowDetailPageState extends State<CashflowDetailPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final TextStyle styling = GoogleFonts.roboto(
      fontSize: 20,
      color: theme?.textColor,
      fontWeight: FontWeight.w400,
    );

    final TextStyle notSpecified = GoogleFonts.roboto(
      fontSize: 19,
      color: theme?.secondaryBackgroundColor,
      fontWeight: FontWeight.w300,
    );

    CategoryController categoryController = Provider.of<CategoryController>(
      context,
    );
    CashflowController cashflowController = Provider.of<CashflowController>(
      context,
    );

    return Scaffold(
      backgroundColor: theme?.menuBoxScaffoldColor,
      body: Column(
        children: [
          Stack(
            children: [
              HeaderWidget(text: widget.cashflow.title),
              Positioned(
                right: screenWidth * 0.06,
                top: screenHeight * 0.09,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      theme?.mainBackGroundColor,
                    ),
                  ),
                  onPressed: () async {
                    cashflowController.removeCashflow(widget.cashflow);
                    await Future.delayed(const Duration(milliseconds: 200));
                    scheduledNotifications();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.delete, color: Colors.red),
                ),
              ),
            ],
          ),
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
                              iconIndex: getIconDataByCashflow(
                                widget.cashflow,
                                categoryController,
                              ),
                              screenHeight: screenHeight,
                              context: context,
                            ),
                            SizedBox(width: screenWidth * 0.08),
                            Column(
                              children: [
                                Text(
                                  widget.cashflow.isExpense
                                      ? 'Amount spent:'
                                      : 'Amount saved: ',
                                  style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: theme?.textColor,
                                  ),
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: screenWidth * 0.5,
                                    minWidth: screenWidth * 0.2,
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    widget.cashflow.isExpense
                                        ? '-${widget.cashflow.amount}'
                                        : '+${widget.cashflow.amount}',

                                    overflow: TextOverflow.ellipsis,

                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          widget.cashflow.isExpense
                                              ? Colors.redAccent
                                              : Colors.green,
                                      fontSize: max(
                                        15,
                                        40 -
                                            (widget.cashflow.amount)
                                                    .toString()
                                                    .length *
                                                2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.05),
                            Text(
                              "🗓️  ${formatDate(widget.cashflow.date)}",
                              style: styling,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            widget.cashflow.location == "" ||
                                    widget.cashflow.notes == null
                                ? Text(
                                  "📍  No location specified",
                                  style: notSpecified,
                                )
                                : Text(
                                  "📍  ${widget.cashflow.location}",
                                  style: styling,
                                ),
                            SizedBox(height: screenHeight * 0.02),
                            Container(
                              width: screenWidth * 0.8,
                              height: 250,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      theme?.secondaryBackgroundColor ??
                                      Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child:
                                    (widget.cashflow.notes == null ||
                                            widget.cashflow.notes == "")
                                        ? Text(
                                          "No description specified",
                                          style: notSpecified,
                                        )
                                        : Text(
                                          widget.cashflow.notes!,
                                          style: GoogleFonts.roboto(
                                            fontSize: 18,
                                            color: theme?.textColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom + 20,
                      ),
                      child: AddCashflowButton(
                        edit: true,
                        cashflow: widget.cashflow,
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

  /// This method searches through all the categories of the given [categoryController] and returns the iconIndex/codePoint
  /// of the first [Category] that matches the given [cashflow],
  int getIconDataByCashflow(
    Cashflow cashflow,
    CategoryController categoryController,
  ) {
    Category category = categoryController.categories.firstWhere(
      (cat) => cat.id == cashflow.categoryId,
    );
    return category.iconIndex;
  }

  /// This method formats a date (type: String) to a more visibly appealling format
  String formatDate(String date) {
    try {
      DateTime dateTime = DateTime.parse(date);

      // Get the day with ordinal suffix (1st, 2nd, 3rd, 4th, etc.)
      String day = _getDayWithOrdinal(dateTime.day);

      // Format the month and year
      String monthYear = DateFormat('MMMM yyyy').format(dateTime);

      return '$day $monthYear';
    } catch (e) {
      return 'Invalid date';
    }
  }

  // Helper method to format the date
  String _getDayWithOrdinal(int day) {
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }

    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  /// Cancels all the current notifications and schedules a new one with the current summary of expenses for that day
  /// It is used after deleting the in detail viewed [Cashflow].
  Future<void> scheduledNotifications() async {
    await NotificationService().cancelAllNotifications();

    final cashflowController = Provider.of<CashflowController>(
      // ignore: use_build_context_synchronously
      context,
      listen: false,
    );

    double dailySummary = cashflowController.dailySummary();

    await NotificationService().scheduleNotification(
      title: "Your Daily Summary 💰",
      body: "You spent ${dailySummary.toStringAsFixed(2)} today",
      hour: 23,
      minute: 59,
    );
  }
}
