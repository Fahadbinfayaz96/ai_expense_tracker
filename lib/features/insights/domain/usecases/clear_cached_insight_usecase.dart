import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/insights_repository.dart';

class ClearCachedInsightUseCase {
  final InsightsRepository repository;

  const ClearCachedInsightUseCase(this.repository);

  Future<Either<Failure, Unit>> call() {
    return repository.clearCache();
  }
}
