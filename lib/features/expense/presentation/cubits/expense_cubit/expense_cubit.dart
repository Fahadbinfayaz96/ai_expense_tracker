import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../insights/domain/usecases/clear_cached_insight_usecase.dart';
import '../../../domain/entities/expense_entity.dart';
import '../../../domain/usecases/add_expense_usecase.dart';
import '../../../domain/usecases/delete_expense_usecase.dart';
import '../../../domain/usecases/get_expense_usecase.dart';
import '../../../domain/usecases/update_expense_usecase.dart';
import 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final GetExpensesUseCase _getExpensesUseCase;
  final AddExpenseUseCase _addExpenseUseCase;
  final UpdateExpenseUseCase _updateExpenseUseCase;
  final DeleteExpenseUseCase _deleteExpenseUseCase;
  final ClearCachedInsightUseCase _clearCachedInsightUseCase;

  ExpenseCubit(
    this._getExpensesUseCase,
    this._addExpenseUseCase,
    this._updateExpenseUseCase,
    this._deleteExpenseUseCase,
    this._clearCachedInsightUseCase,
  ) : super(const ExpenseInitial());

  Future<void> loadExpenses() async {
    emit(const ExpenseLoading());

    final result = await _getExpensesUseCase();

    result.fold(
      (failure) => emit(ExpenseError(failure.message)),
      (expenses) => emit(ExpenseLoaded(expenses)),
    );
  }

  Future<void> addExpense(Expense expense) async {
    final result = await _addExpenseUseCase(expense);

    await result.fold(
      (failure) async {
        emit(ExpenseError(failure.message));
      },
      (_) async {
        await _clearCachedInsightUseCase();
        await loadExpenses();
      },
    );
  }

  Future<void> updateExpense(Expense expense) async {
    final result = await _updateExpenseUseCase(expense);

    await result.fold(
      (failure) async {
        emit(ExpenseError(failure.message));
      },
      (_) async {
        await _clearCachedInsightUseCase();
        await loadExpenses();
      },
    );
  }

  Future<void> deleteExpense(String id) async {
    final result = await _deleteExpenseUseCase(id);

    await result.fold(
      (failure) async {
        emit(ExpenseError(failure.message));
      },
      (_) async {
        await _clearCachedInsightUseCase();
        await loadExpenses();
      },
    );
  }
}
