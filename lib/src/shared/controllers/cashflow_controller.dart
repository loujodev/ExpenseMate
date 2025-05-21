import 'package:expense_mate/src/shared/domain/cashflow_model.dart';
import 'package:expense_mate/src/shared/presentation/overview/overview.dart';
import 'package:expense_mate/src/shared/services/database_service.dart';
import 'package:flutter/material.dart';

/// This Provider keeps track of the currently saved [Cashflow] objects and updates the database if changes are made.
class CashflowController extends ChangeNotifier {
  List<Cashflow> cashflows = [];
  DatabaseService databaseService = DatabaseService.instance;

  //Nested map for monthlySummary of expenses
  //-outer map for yearly distinction
  //-inner map with months as key and summary of expenses as value
  Map<int, Map<int, double>> yearlyMonthlyExpenses = {};

  CashflowController({this.cashflows = const []});

  void init() async {
    await loadCashflows();
    await loadyearlyMonthlyExpenses();
  }

  Future<void> loadCashflows() async {
    cashflows = (await databaseService.getCashflows()) ?? [];
    notifyListeners();
  }

  Future<void> loadyearlyMonthlyExpenses() async {
    cashflows = (await databaseService.getCashflows()) ?? [];

    yearlyMonthlyExpenses.clear();

    for (var cashflow in cashflows) {
      addToMonthlyTotals(cashflow);
    }
    notifyListeners();
  }

  void addCashflow(Cashflow cashflow) async {
    final id = await databaseService.addCashflow(
      cashflow.categoryId,
      cashflow.amount,
      cashflow.date,
      cashflow.isExpense,
      cashflow.notes ?? '',
      cashflow.title,
      cashflow.location ?? '',
    );
    cashflow.id =
        id; // Assign the generated id to the Cashflow object to ensure it can be deleted by id after being added.
    cashflows.add(cashflow);
    addToMonthlyTotals(cashflow);
    notifyListeners();
  }

  void removeCashflow(Cashflow cashflow) async {
    if (cashflow.id == null) {
      throw Exception('Cannot delete a cashflow without an id');
    }
    await databaseService.removeCashflow(cashflow.id!);
    cashflows.remove(cashflow);

    await loadyearlyMonthlyExpenses();

    notifyListeners();
  }

  //Used to cascadically delete the cashflows when a category is deleted
  void removeCashflowsByCategoryId(int categoryId) async {
    // Remove from the database
    await databaseService.removeCashflowsByCategoryId(categoryId);

    // Remove all cashflows with the given categoryId from the local list
    cashflows.removeWhere((cashflow) => cashflow.categoryId == categoryId);

    await loadyearlyMonthlyExpenses();

    notifyListeners();
  }

  void addToMonthlyTotals(Cashflow cashflow) {
    DateTime date = DateTime.parse(cashflow.date);
    int yearKey = date.year;
    int monthKey = date.month;

    //Create a new yearKey inside a map to show another bar graph on the dashboard page
    if (!yearlyMonthlyExpenses.containsKey(yearKey)) {
      yearlyMonthlyExpenses[yearKey] = {};

      // Create an empty bar for every month or create a bar for each month that exists
      // for (var i = 1; i <= 12; i++) {
      //   yearlyMonthlyExpenses[yearKey]![i] = 0;
      // }
    }

    if (cashflow.isExpense) {
      yearlyMonthlyExpenses[yearKey]![monthKey] =
          (yearlyMonthlyExpenses[yearKey]![monthKey] ?? 0) + cashflow.amount;
    }
  }

  int getStartMonth() {
    if (cashflows.isEmpty) {
      return DateTime.now().month;
    }

    cashflows.sort((a, b) => a.date.compareTo(b.date));

    return DateTime.parse(cashflows.first.date).month;
  }

  int getStartYear() {
    if (cashflows.isEmpty) {
      return DateTime.now().year;
    }

    cashflows.sort((a, b) => a.date.compareTo(b.date));

    return DateTime.parse(cashflows.first.date).year;
  }

  double getTotalExpensesSum() {
    double sum = 0;
    for (Cashflow cashflow in cashflows) {
      if (cashflow.isExpense) {
        sum = sum + cashflow.amount;
      }
    }
    return sum;
  }

  double getTotalSavingsSum() {
    double sum = 0;
    for (Cashflow cashflow in cashflows) {
      if (!cashflow.isExpense) {
        sum = sum + cashflow.amount;
      }
    }
    return sum;
  }

  ///Used for the progress bar inside the [Overview] widget
  double compareExpenseLastMonth() {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    // Handle year transition (if current month is January, last month is December of previous year)
    final lastMonth = currentMonth == 1 ? 12 : currentMonth - 1;
    final lastMonthYear = currentMonth == 1 ? currentYear - 1 : currentYear;

    final cashflowsThisMonth =
        cashflows.where((cashflow) {
          final date = DateTime.parse(cashflow.date);
          return date.month == currentMonth && date.year == currentYear;
        }).toList();

    final cashflowsLastMonth =
        cashflows.where((cashflow) {
          final date = DateTime.parse(cashflow.date);
          return date.month == lastMonth && date.year == lastMonthYear;
        }).toList();

    // Sum expenses for this month
    final sumThisMonth = cashflowsThisMonth
        .where((cashflow) => cashflow.isExpense)
        .fold(0.0, (sum, cashflow) => sum + cashflow.amount);

    // Sum expenses for last month
    final sumLastMonth = cashflowsLastMonth
        .where((cashflow) => cashflow.isExpense)
        .fold(0.0, (sum, cashflow) => sum + cashflow.amount);

    // Avoid division by zero
    if (sumLastMonth == 0) {
      return 0.0;
    }

    return sumThisMonth / sumLastMonth;
  }

  Future<void> updateCashflow(Cashflow cashflow) async {
    if (cashflow.id == null) {
      throw Exception('Cannot update cashflow without an id');
    }

    // Update in database
    await databaseService.updateCashflow(
      cashflow.id!,
      cashflow.categoryId,
      cashflow.amount,
      cashflow.date,
      cashflow.isExpense,
      cashflow.notes ?? '',
      cashflow.title,
      cashflow.location ?? '',
    );

    // Update in local state
    final index = cashflows.indexWhere((element) => element.id == cashflow.id);
    if (index != -1) {
      cashflows[index] = cashflow;
    }

    await loadyearlyMonthlyExpenses();
    notifyListeners();
  }

  ///Sums up the daily expenses
  double dailySummary() {
    double dailySummary = 0;
    List<Cashflow> cashflowsToday =
        cashflows
            .where(
              (cashflow) =>
                  DateTime.parse(cashflow.date).day == DateTime.now().day,
            )
            .toList();

    for (var cashflow in cashflowsToday) {
      if (cashflow.isExpense) {
        dailySummary += cashflow.amount;
      }
    }
    return dailySummary;
  }
}
