import '../../domain/entities/insights_entity.dart';

class SpendingInsightModel extends SpendingInsight {
  const SpendingInsightModel({required super.report});

  factory SpendingInsightModel.fromText(String text) {
    return SpendingInsightModel(report: text);
  }
}
