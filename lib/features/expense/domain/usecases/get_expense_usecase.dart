import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class GetExpensesUseCase {
  final ExpenseRepository _repository;

  const GetExpensesUseCase(this._repository);

  Future<Either<Failure, List<Expense>>> call() {
    return _repository.getExpenses();
  }
}
