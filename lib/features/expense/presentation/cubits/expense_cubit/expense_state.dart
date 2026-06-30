import 'package:equatable/equatable.dart';

import '../../../domain/entities/expense_entity.dart';

sealed class ExpenseState extends Equatable {
  const ExpenseState();
  @override
  List<Object?> get props => [];
}

final class ExpenseInitial extends ExpenseState {
  const ExpenseInitial();
}

final class ExpenseLoading extends ExpenseState {
  const ExpenseLoading();
}

final class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;

  const ExpenseLoaded(this.expenses);
  @override
  List<Object?> get props => [expenses];
}

final class ExpenseError extends ExpenseState {
  final String message;

  const ExpenseError(this.message);
  @override
  List<Object?> get props => [message];
}
