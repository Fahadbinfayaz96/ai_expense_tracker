import '../../../expense/domain/entities/expense_entity.dart';
import '../../domain/entities/receipt_entity.dart';

class ReceiptModel extends Receipt {
  const ReceiptModel({
    required super.merchant,
    required super.amount,
    required super.date,
    required super.category,
  });

  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    return ReceiptModel(
      merchant: (json['merchant'] ?? 'Unknown').toString(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ExpenseCategory.others,
      ),
    );
  }
}
