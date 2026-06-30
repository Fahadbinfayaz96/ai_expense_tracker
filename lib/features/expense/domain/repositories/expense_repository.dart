import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/expense_entity.dart';

abstract interface class ExpenseRepository {
  Future<Either<Failure, List<Expense>>> getExpenses();

  Future<Either<Failure, Unit>> addExpense(Expense expense);

  Future<Either<Failure, Unit>> updateExpense(Expense expense);

  Future<Either<Failure, Unit>> deleteExpense(String id);
}
