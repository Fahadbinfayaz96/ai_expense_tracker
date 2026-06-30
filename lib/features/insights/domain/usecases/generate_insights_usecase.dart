import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/insights_entity.dart';
import '../repositories/insights_repository.dart';

class GenerateInsightsUseCase {
  final InsightsRepository repository;

  const GenerateInsightsUseCase(this.repository);

  Future<Either<Failure, SpendingInsight>> call(String expensesJson) {
    return repository.generateInsights(expensesJson);
  }
}
