import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/expense_repository.dart';

class DeleteExpenseUseCase {
  final ExpenseRepository _repository;

  const DeleteExpenseUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String id) {
    return _repository.deleteExpense(id);
  }
}
