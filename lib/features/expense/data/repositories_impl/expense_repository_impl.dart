import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_datasource.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;

  ExpenseRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Expense>>> getExpenses() async {
    try {
      final models = await localDataSource.getExpenses();

      final expenses = models.map((e) => e.toEntity()).toList();

      return Right(expenses);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (_) {
      return const Left(
        UnknownFailure('An unexpected error occurred while loading expenses.'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> addExpense(Expense expense) async {
    try {
      await localDataSource.addExpense(ExpenseModel.fromEntity(expense));

      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (_) {
      return const Left(
        UnknownFailure(
          'An unexpected error occurred while saving the expense.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateExpense(Expense expense) async {
    try {
      await localDataSource.updateExpense(ExpenseModel.fromEntity(expense));

      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (_) {
      return const Left(
        UnknownFailure(
          'An unexpected error occurred while updating the expense.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteExpense(String id) async {
    try {
      await localDataSource.deleteExpense(id);

      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (_) {
      return const Left(
        UnknownFailure(
          'An unexpected error occurred while deleting the expense.',
        ),
      );
    }
  }
}
