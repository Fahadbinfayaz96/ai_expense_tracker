import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/insights_entity.dart';
import '../repositories/insights_repository.dart';

class GetCachedInsightUseCase {
  final InsightsRepository repository;

  const GetCachedInsightUseCase(this.repository);

  Future<Either<Failure, SpendingInsight?>> call() {
    return repository.getCachedInsight();
  }
}
