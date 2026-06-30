import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/receipt_entity.dart';
import '../../domain/repositories/receipt_repository.dart';
import '../datasources/receipt_remote_datasource.dart';

class ReceiptRepositoryImpl implements ReceiptRepository {
  final ReceiptRemoteDataSource _remoteDataSource;

  ReceiptRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Receipt>> scanReceipt(File image) async {
    try {
      final receipt = await _remoteDataSource.scanReceipt(image);

      return Right(receipt);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(
        UnknownFailure(
          'An unexpected error occurred while scanning the receipt.',
        ),
      );
    }
  }
}
