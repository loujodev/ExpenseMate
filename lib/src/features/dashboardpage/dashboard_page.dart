import 'package:expense_mate/src/features/auth/data/auth_repository.dart';
import 'package:expense_mate/src/shared/presentation/widgets/add_cashflow_button.dart';
import 'package:expense_mate/src/features/categorypage/presentation/category_detail_page/cash_flow_list.dart';
import 'package:expense_mate/src/shared/controllers/cashflow_controller.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:expense_mate/src/features/dashboardpage/presentation/bar_graphs/bar_graph.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:math';

/// DashboardPage is the first of the three main pages inside the app to display an overview for the user,
///
/// This widget shows:
/// - Personalized greeting
/// - Interactive [BarGraph]s of yearly expenses(only expenses, no savings) for every year there are cashflows for
/// - [AddCashflowButton] to add new expenses/savings
/// - List of recent cash flows
///
///
/// The page uses a PageView to allow swiping between different years of data.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final AuthRepository _authRepository = AuthRepository();
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();
    final cashflowProvider = Provider.of<CashflowController>(context);
    final yearlyData = cashflowProvider.yearlyMonthlyExpenses;

    //Sort the map so the most recent year gets displayed first
    final sortedYearlyData = Map.fromEntries(
      yearlyData.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
    );

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: theme?.mainBackGroundColor,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.05,
                        top: screenHeight * 0.1,
                      ),
                      child:
                          _authRepository.currentUser!.displayName == null
                              ? Text(
                                "Hello there 👋 ",
                                style: TextStyle(
                                  fontSize: 35,
                                  color: theme?.textColor,
                                ),
                              )
                              : // If the user has a display name yet, use it
                              // Otherwise use a generic greeting while the username is being set
                              Text(
                                "Hello ${_authRepository.currentUser?.displayName} 💰 ",
                                style: TextStyle(
                                  fontSize: 35,
                                  color: theme?.textColor,
                                ),
                              ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Container(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.3,
                    decoration: BoxDecoration(
                      color: theme?.mainBackGroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: theme?.shadowColor ?? Colors.black,
                          blurRadius: 7,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          //Builds a page for every distinct year there is a cashflow for
                          child: PageView.builder(
                            controller: pageController,
                            itemCount: sortedYearlyData.keys.length,
                            itemBuilder: (context, index) {
                              final year = sortedYearlyData.keys.elementAt(
                                index,
                              );
                              final monthlyData = sortedYearlyData[year]!;
                              return Column(
                                children: [
                                  SizedBox(height: screenHeight * 0.03),
                                  Text(
                                    "$year",
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: theme?.textColor,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Expanded(
                                    child: BarGraph(
                                      monthlyData: monthlyData,
                                      maxValue:
                                          monthlyData.values.reduce(max) * 1.1,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        // If there are no cashflows saved a text is displayed
                        sortedYearlyData.keys.isEmpty
                            ? Center(
                              child: Text(
                                "Add some expenses to see them displayed here",
                                style: GoogleFonts.roboto(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                  color: theme?.textColor,
                                ),
                              ),
                            )
                            //Indicator to let the user know he can see data from earlier years as well by swiping pages
                            : SmoothPageIndicator(
                              controller: pageController,
                              count:
                                  sortedYearlyData.keys.isNotEmpty
                                      ? sortedYearlyData.keys.length
                                      : 0,
                              effect: WormEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                activeDotColor:
                                    theme?.purpleThemeColor ??
                                    Colors.purpleAccent,
                              ),
                            ),
                        SizedBox(height: screenHeight * 0.01),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  AddCashflowButton(edit: false),
                  SizedBox(height: screenHeight * 0.01),
                  CashFlowList(cashflowList: cashflowProvider.cashflows),
                  SizedBox(height: screenHeight * 0.15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
