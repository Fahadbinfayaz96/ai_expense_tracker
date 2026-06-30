import 'package:equatable/equatable.dart';

enum ExpenseCategory {
  food,
  shopping,
  travel,
  utilities,
  entertainment,
  others,
}

class Expense extends Equatable {
  final String id;
  final String merchant;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;

  const Expense({
    required this.id,
    required this.merchant,
    required this.amount,
    required this.date,
    required this.category,
  });

  @override
  List<Object> get props => [id, merchant, amount, date, category];
}
