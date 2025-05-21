import 'package:expense_mate/src/shared/controllers/cashflow_controller.dart';
import 'package:expense_mate/src/shared/domain/category_model.dart';
import 'package:expense_mate/src/shared/services/database_service.dart';
import 'package:flutter/material.dart';

///Controller to keep track of the categories and update the database
class CategoryController extends ChangeNotifier {
  List<Category> categories = [];
  DatabaseService databaseService = DatabaseService.instance;

  CategoryController({this.categories = const []});

  Future<void> init() async {
    await loadCategories();
  }

  Future<void> loadCategories() async {
    categories = (await databaseService.getCategories()) ?? [];
    notifyListeners();
  }

  Future<void> addCategory(Category category) async {
    await databaseService.addCategory(category.name, category.iconIndex);
    await loadCategories();
  }

  Future<void> removeCategory(
    Category category,
    CashflowController cashflowcontroller,
  ) async {
    await databaseService.removeCategory(category.id as int);
    categories.remove(category);

    //Removes all the cashflows of the category that gets deleted
    cashflowcontroller.removeCashflowsByCategoryId(category.id!);
    notifyListeners();
  }
}
