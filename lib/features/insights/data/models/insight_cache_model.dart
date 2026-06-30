import 'package:hive/hive.dart';

part 'insight_cache_model.g.dart';

@HiveType(typeId: 2)
class InsightCacheModel {
  @HiveField(0)
  final String report;

  @HiveField(1)
  final DateTime generatedAt;

  const InsightCacheModel({required this.report, required this.generatedAt});
}
