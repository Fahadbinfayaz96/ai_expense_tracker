import 'package:equatable/equatable.dart';

import '../../../domain/entities/insights_entity.dart';

sealed class InsightState extends Equatable {
  const InsightState();

  @override
  List<Object?> get props => [];
}

final class InsightInitial extends InsightState {
  const InsightInitial();
}

final class InsightLoading extends InsightState {
  const InsightLoading();
}

final class InsightLoaded extends InsightState {
  final SpendingInsight insight;

  const InsightLoaded(this.insight);

  @override
  List<Object?> get props => [insight];
}

final class InsightError extends InsightState {
  final String message;

  const InsightError(this.message);

  @override
  List<Object?> get props => [message];
}
