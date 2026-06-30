import 'package:equatable/equatable.dart';

import '../../../domain/entities/receipt_entity.dart';

sealed class ReceiptState extends Equatable {
  const ReceiptState();

  @override
  List<Object?> get props => [];
}

final class ReceiptInitial extends ReceiptState {
  const ReceiptInitial();
}

final class ReceiptLoading extends ReceiptState {
  const ReceiptLoading();
}

final class ReceiptLoaded extends ReceiptState {
  final Receipt receipt;

  const ReceiptLoaded(this.receipt);

  @override
  List<Object?> get props => [receipt];
}

final class ReceiptError extends ReceiptState {
  final String message;

  const ReceiptError(this.message);

  @override
  List<Object?> get props => [message];
}
