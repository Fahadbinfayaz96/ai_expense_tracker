import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class UpdateExpenseUseCase {
  final ExpenseRepository _repository;

  const UpdateExpenseUseCase(this._repository);

  Future<Either<Failure, Unit>> call(Expense expense) {
    return _repository.updateExpense(expense);
  }
}
