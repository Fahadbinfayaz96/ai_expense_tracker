import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/insights_entity.dart';
import '../../domain/repositories/insights_repository.dart';
import '../datasources/insights_local_datasource.dart';
import '../datasources/insights_remote_datasource.dart';
import '../models/insight_cache_model.dart';

class InsightsRepositoryImpl implements InsightsRepository {
  final InsightsRemoteDataSource _remote;
  final InsightsLocalDataSource _local;

  InsightsRepositoryImpl(this._remote, this._local);

  @override
  Future<Either<Failure, SpendingInsight>> generateInsights(
    String expensesJson,
  ) async {
    try {
      final insight = await _remote.generateInsights(expensesJson);

      // Cache failure should not prevent the user from seeing the report.
      try {
        await _local.cacheInsight(
          InsightCacheModel(
            report: insight.report,
            generatedAt: DateTime.now(),
          ),
        );
      } on CacheException {
        // Ignore cache failures.
      }

      return Right(insight);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(
        UnknownFailure(
          'An unexpected error occurred while generating insights.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, SpendingInsight?>> getCachedInsight() async {
    try {
      final cached = await _local.getCachedInsight();

      if (cached == null) {
        return const Right(null);
      }

      return Right(SpendingInsight(report: cached.report));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (_) {
      return const Left(
        UnknownFailure(
          'An unexpected error occurred while loading cached insights.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> clearCache() async {
    try {
      await _local.clearCache();

      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (_) {
      return const Left(
        UnknownFailure(
          'An unexpected error occurred while clearing cached insights.',
        ),
      );
    }
  }
}
