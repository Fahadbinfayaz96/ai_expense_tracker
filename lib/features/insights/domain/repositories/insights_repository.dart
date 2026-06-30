import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/insights_entity.dart';

abstract interface class InsightsRepository {
  Future<Either<Failure, SpendingInsight>> generateInsights(
    String expensesJson,
  );

  Future<Either<Failure, SpendingInsight?>> getCachedInsight();

  Future<Either<Failure, Unit>> clearCache();
}
