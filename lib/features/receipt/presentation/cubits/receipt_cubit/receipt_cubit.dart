import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/scan_receipt_usecase.dart';
import 'receipt_state.dart';

class ReceiptCubit extends Cubit<ReceiptState> {
  final ScanReceiptUseCase _scanReceiptUseCase;

  ReceiptCubit(this._scanReceiptUseCase) : super(const ReceiptInitial());

  Future<void> scanReceipt(File image) async {
    emit(const ReceiptLoading());

    final result = await _scanReceiptUseCase(image);

    result.fold(
      (failure) => emit(ReceiptError(failure.message)),
      (receipt) => emit(ReceiptLoaded(receipt)),
    );
  }
}
