import '../../../expense/domain/entities/expense_entity.dart';
import 'package:equatable/equatable.dart';

class Receipt extends Equatable {
  final String merchant;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;

  const Receipt({
    required this.merchant,
    required this.amount,
    required this.date,
    required this.category,
  });

  @override
  List<Object> get props => [merchant, amount, date, category];
}
