import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/receipt_entity.dart';
import '../repositories/receipt_repository.dart';

class ScanReceiptUseCase {
  final ReceiptRepository _repository;

  const ScanReceiptUseCase(this._repository);

  Future<Either<Failure, Receipt>> call(File image) {
    return _repository.scanReceipt(image);
  }
}
