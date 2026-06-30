import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/receipt_entity.dart';

abstract interface class ReceiptRepository {
  Future<Either<Failure, Receipt>> scanReceipt(File image);
}
