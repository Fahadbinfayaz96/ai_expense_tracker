import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../models/expense_model.dart';

abstract interface class ExpenseLocalDataSource {
  Future<List<ExpenseModel>> getExpenses();

  Future<void> addExpense(ExpenseModel expense);

  Future<void> updateExpense(ExpenseModel expense);

  Future<void> deleteExpense(String id);
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final Box<ExpenseModel> box;

  ExpenseLocalDataSourceImpl(this.box);

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    try {
      return box.values.toList();
    } on HiveError catch (e) {
      throw CacheException(e.message);
    } catch (_) {
      throw const CacheException(
        'An unexpected error occurred while loading expenses.',
      );
    }
  }

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    try {
      await box.put(expense.id, expense);
    } on HiveError catch (e) {
      throw CacheException(e.message);
    } catch (_) {
      throw const CacheException(
        'An unexpected error occurred while saving the expense.',
      );
    }
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    try {
      await box.put(expense.id, expense);
    } on HiveError catch (e) {
      throw CacheException(e.message);
    } catch (_) {
      throw const CacheException(
        'An unexpected error occurred while updating the expense.',
      );
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      await box.delete(id);
    } on HiveError catch (e) {
      throw CacheException(e.message);
    } catch (_) {
      throw const CacheException(
        'An unexpected error occurred while deleting the expense.',
      );
    }
  }
}
