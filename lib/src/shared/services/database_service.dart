import 'dart:io';
import 'package:expense_mate/src/shared/controllers/cashflow_controller.dart';
import 'package:expense_mate/src/shared/controllers/category_controller.dart';
import 'package:expense_mate/src/shared/domain/cashflow_model.dart';
import 'package:expense_mate/src/shared/domain/category_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();
  static Database? _db;

  //Category table
  final String _categoryTable = "category";
  final String _categoryIdColumn = "id";
  final String _categoryNameColumn = "name";
  final String _categoryIconCodeColumn = "icon";

  // Cashflow table
  final String _cashflowTable = "cashflow";
  final String _cashflowIdColumnName = "id";
  final String _cashflowCategoryId = "category_id";
  final String _cashflowIsExpenseColumn = "is_expense";
  final String _cashflowAmountColumn = "amount";
  final String _cashflowDateColumn = "date";
  final String _cashflowNotesColumn = "notes";
  final String _cashflowTitleColumn = 'title';
  final String _cashflowLocationColumn = 'location';

  //ProfilePicture
  final String _pictureTable = "picture";
  final String _picturIdColumnName = "id";
  final String _picturePathColumnName = "path";
  final int profilePictureId = 1;

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1, // Adding the required version parameter
      onCreate: (db, version) {
        db.execute('''
            CREATE TABLE $_categoryTable (
              $_categoryIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
              $_categoryNameColumn TEXT NOT NULL,
              $_categoryIconCodeColumn INTEGER NOT NULL 
            )
        ''');
        db.execute('''
          CREATE TABLE $_cashflowTable (
            $_cashflowIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
            $_cashflowCategoryId INTEGER NOT NULL,
            $_cashflowTitleColumn TEXT NOT NULL,
            $_cashflowIsExpenseColumn INTEGER NOT NULL, -- 0 for false, 1 for true
            $_cashflowAmountColumn REAL NOT NULL,
            $_cashflowDateColumn TEXT NOT NULL, -- ISO8601 strings (YYYY-MM-DD)
            $_cashflowLocationColumn TEXT,
            $_cashflowNotesColumn TEXT,
            FOREIGN KEY ($_cashflowCategoryId) 
              REFERENCES $_categoryTable($_categoryIdColumn)
              ON DELETE CASCADE
          )
        ''');
        db.execute('''
            CREATE TABLE $_pictureTable (
              $_picturIdColumnName INTEGER PRIMARY KEY,
              $_picturePathColumnName TEXT NOT NULL
            )
        ''');

        //3 Initial Categories to make it easier for the user to use the app
        db.insert(_categoryTable, {
          _categoryNameColumn: "Groceries",
          _categoryIconCodeColumn: 0xe59b,
        });
        db.insert(_categoryTable, {
          _categoryNameColumn: "Transport",
          _categoryIconCodeColumn: 0xe1d7,
        });
        db.insert(_categoryTable, {
          _categoryNameColumn: "Media",
          _categoryIconCodeColumn: 0xe687,
        });
      },
    );

    return database;
  }

  Future<void> addCategory(String categoryName, int iconCode) async {
    final db = await database;
    await db.insert(_categoryTable, {
      _categoryNameColumn: categoryName,
      _categoryIconCodeColumn: iconCode,
    });
  }

  Future<int> addCashflow(
    int categoryId,
    double amount,
    String date,
    bool isExpense,
    String description,
    String title,
    String location,
  ) async {
    final db = await database;
    return await db.insert(_cashflowTable, {
      _cashflowCategoryId: categoryId,
      _cashflowAmountColumn: amount,
      _cashflowDateColumn: date,
      _cashflowIsExpenseColumn: isExpense ? 1 : 0,
      _cashflowNotesColumn: description,
      _cashflowTitleColumn: title,
      _cashflowLocationColumn: location,
    });
  }

  Future<void> addPicture(String path) async {
    final db = await database;
    await db.insert(_pictureTable, {
      _picturIdColumnName: 1,
      _picturePathColumnName: path,
    });
  }

  Future<String?> getProfilePicturePath() async {
    final db = await database;
    final data = await db.query(
      _pictureTable,
      where: '$_picturIdColumnName = ?',
      whereArgs: [profilePictureId],
      limit: 1, //Profile Picture always has the id 1
    );

    if (data.isEmpty) {
      return null;
    }
    final path = data.first[_picturePathColumnName] as String?;
    return path;
  }

  Future<void> addOrUpdateProfilePicture(String path) async {
    final db = await database;

    final existing = await db.query(
      _pictureTable,
      where: '$_picturIdColumnName = ?',
      whereArgs: [profilePictureId],
    );

    if (existing.isEmpty) {
      await db.insert(_pictureTable, {
        _picturIdColumnName: profilePictureId,
        _picturePathColumnName: path,
      });
    } else {
      await db.update(
        _pictureTable,
        {_picturePathColumnName: path},
        where: '$_picturIdColumnName = ?',
        whereArgs: [profilePictureId],
      );
    }
  }

  Future<void> removeProfilePicture() async {
    final db = await database;
    await db.delete(
      _pictureTable,
      where: '$_picturIdColumnName = ?',
      whereArgs: [profilePictureId],
    );
  }

  Future<List<Category>?> getCategories() async {
    final db = await database;
    final data = await db.query(_categoryTable);
    List<Category> categories =
        data
            .map(
              (e) => Category(
                id: e[_categoryIdColumn] as int,
                name: e[_categoryNameColumn] as String,
                iconIndex: e[_categoryIconCodeColumn] as int,
              ),
            )
            .toList();
    return categories;
  }

  Future<void> removeCategory(int categoryId) async {
    final db = await database;
    await db.delete(_categoryTable, where: 'id = ?', whereArgs: [categoryId]);
  }

  Future<List<Cashflow>?> getCashflows() async {
    final db = await database;
    final data = await db.query(_cashflowTable);
    List<Cashflow> cashflows =
        data
            .map(
              (e) => Cashflow(
                id: e[_cashflowIdColumnName] as int,
                categoryId: e[_cashflowCategoryId] as int,
                amount: e[_cashflowAmountColumn] as double,
                date: (e[_cashflowDateColumn] as String),
                isExpense: e[_cashflowIsExpenseColumn] == 1,
                notes: (e[_cashflowNotesColumn] as String?) ?? '',
                title: (e[_cashflowTitleColumn] as String?) ?? '',
                location: (e[_cashflowLocationColumn] as String?) ?? '',
              ),
            )
            .toList();
    return cashflows;
  }

  Future<List<Cashflow>?> getCashflowsById(int cashflowId) async {
    final db = await database;
    final data = await db.query(
      _cashflowTable,
      where: 'id = ?',
      whereArgs: [cashflowId],
    );
    List<Cashflow> cashflows =
        data
            .map(
              (e) => Cashflow(
                id: e[_cashflowIdColumnName] as int,
                categoryId: e[_cashflowCategoryId] as int,
                amount: e[_cashflowAmountColumn] as double,
                date: (e[_cashflowDateColumn] as String),
                isExpense: e[_cashflowIsExpenseColumn] == 1,
                notes: (e[_cashflowNotesColumn] as String?) ?? '',
                title: (e[_cashflowTitleColumn] as String?) ?? '',
                location: (e[_cashflowLocationColumn] as String?) ?? '',
              ),
            )
            .toList();
    return cashflows;
  }

  Future<void> removeCashflow(int cashflowId) async {
    final db = await database;
    await db.delete(_cashflowTable, where: 'id = ?', whereArgs: [cashflowId]);
  }

  Future<void> removeCashflowsByCategoryId(int categoryId) async {
    final db = await database;
    await db.delete(
      _cashflowTable,
      where: '$_cashflowCategoryId = ?',
      whereArgs: [categoryId],
    );
  }

  Future<void> updateCashflow(
    int id,
    int categoryId,
    double amount,
    String date,
    bool isExpense,
    String notes,
    String title,
    String location,
  ) async {
    final db = await database;
    await db.update(
      'cashflow',
      {
        'category_id': categoryId,
        'amount': amount,
        'date': date,
        'is_expense': isExpense ? 1 : 0,
        'notes': notes,
        'title': title,
        'location': location,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Source for some of the code: https://stackoverflow.com/questions/52741460/sqlite-connections-returns-null-in-flutter
  Future<void> deleteDatabaseFile({
    required CategoryController categoryController,
    required CashflowController cashflowController,
  }) async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");

    // Check if the database file exists
    final file = File(databasePath);
    if (await file.exists()) {
      // Clear controllers before deleting the database
      categoryController.categories.clear();
      cashflowController.cashflows.clear();
      cashflowController.yearlyMonthlyExpenses.clear();

      // Close existing database connection
      if (_db != null) {
        await _db!.close();
        _db = null;
      }

      await file.delete(); // Delete the database file

      // Create a new empty database
      _db = await getDatabase();

      // Give a small delay to ensure database creation completes
      await Future.delayed(Duration(milliseconds: 300));

      // Reload data to the providers
      await categoryController.loadCategories();
      await cashflowController.loadCashflows();
      await cashflowController.loadyearlyMonthlyExpenses();
    } else {
      throw Exception("Database file does not exist.");
    }
  }
}
