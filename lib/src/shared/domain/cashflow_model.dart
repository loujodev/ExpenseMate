class Cashflow {
  int? id;
  final int categoryId;
  final bool isExpense;
  final double amount;
  final String title;
  final String date;
  String? notes;
  String? location;

  Cashflow({
    this.id,
    required this.categoryId,
    required this.isExpense,
    required this.amount,
    required this.title,
    required this.date,
    this.notes,
    this.location,
  });
}
