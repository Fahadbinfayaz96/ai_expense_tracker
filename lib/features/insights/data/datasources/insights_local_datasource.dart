import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../models/insight_cache_model.dart';

abstract interface class InsightsLocalDataSource {
  Future<InsightCacheModel?> getCachedInsight();

  Future<void> cacheInsight(InsightCacheModel insight);

  Future<void> clearCache();
}

class InsightsLocalDataSourceImpl implements InsightsLocalDataSource {
  static const _boxName = 'insights';

  Future<Box<InsightCacheModel>> get _box async =>
      Hive.openBox<InsightCacheModel>(_boxName);

  @override
  Future<InsightCacheModel?> getCachedInsight() async {
    try {
      final box = await _box;

      return box.get('latest');
    } on HiveError catch (e) {
      throw CacheException(e.message);
    } catch (_) {
      throw const CacheException(
        'An unexpected error occurred while loading cached insights.',
      );
    }
  }

  @override
  Future<void> cacheInsight(InsightCacheModel insight) async {
    try {
      final box = await _box;

      await box.put('latest', insight);
    } on HiveError catch (e) {
      throw CacheException(e.message);
    } catch (_) {
      throw const CacheException(
        'An unexpected error occurred while caching insights.',
      );
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final box = await _box;

      await box.clear();
    } on HiveError catch (e) {
      throw CacheException(e.message);
    } catch (_) {
      throw const CacheException(
        'An unexpected error occurred while clearing cached insights.',
      );
    }
  }
}
