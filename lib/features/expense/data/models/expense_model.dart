import 'package:hive/hive.dart';
import '../../domain/entities/expense_entity.dart';
import 'expense_category.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 0)
class ExpenseModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String merchant;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final ExpenseCategoryModel category;

  const ExpenseModel({
    required this.id,
    required this.merchant,
    required this.amount,
    required this.date,
    required this.category,
  });

  Expense toEntity() {
    return Expense(
      id: id,
      merchant: merchant,
      amount: amount,
      date: date,
      category: _toEntityCategory(category),
    );
  }

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      merchant: expense.merchant,
      amount: expense.amount,
      date: expense.date,
      category: _toModelCategory(expense.category),
    );
  }

  static ExpenseCategory _toEntityCategory(ExpenseCategoryModel category) {
    switch (category) {
      case ExpenseCategoryModel.food:
        return ExpenseCategory.food;
      case ExpenseCategoryModel.shopping:
        return ExpenseCategory.shopping;
      case ExpenseCategoryModel.travel:
        return ExpenseCategory.travel;
      case ExpenseCategoryModel.utilities:
        return ExpenseCategory.utilities;
      case ExpenseCategoryModel.entertainment:
        return ExpenseCategory.entertainment;
      case ExpenseCategoryModel.others:
        return ExpenseCategory.others;
    }
  }

  static ExpenseCategoryModel _toModelCategory(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return ExpenseCategoryModel.food;
      case ExpenseCategory.shopping:
        return ExpenseCategoryModel.shopping;
      case ExpenseCategory.travel:
        return ExpenseCategoryModel.travel;
      case ExpenseCategory.utilities:
        return ExpenseCategoryModel.utilities;
      case ExpenseCategory.entertainment:
        return ExpenseCategoryModel.entertainment;
      case ExpenseCategory.others:
        return ExpenseCategoryModel.others;
    }
  }
}
