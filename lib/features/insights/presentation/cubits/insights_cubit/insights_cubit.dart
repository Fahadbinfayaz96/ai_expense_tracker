import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../expense/domain/entities/expense_entity.dart';
import '../../../../expense/domain/usecases/get_expense_usecase.dart';
import '../../../domain/usecases/generate_insights_usecase.dart';
import '../../../domain/usecases/get_cached_insight_usecase.dart';
import 'insights_state.dart';

class InsightCubit extends Cubit<InsightState> {
  final GetCachedInsightUseCase _cachedUseCase;
  final GenerateInsightsUseCase _generateUseCase;
  final GetExpensesUseCase _expensesUseCase;

  InsightCubit(
    this._generateUseCase,
    this._expensesUseCase,
    this._cachedUseCase,
  ) : super(const InsightInitial());

  Future<void> loadInsights() async {
    emit(const InsightLoading());

    final cachedResult = await _cachedUseCase();

    await cachedResult.fold(
      (failure) async {
        emit(InsightError(failure.message));
      },
      (cachedInsight) async {
        if (cachedInsight != null) {
          emit(InsightLoaded(cachedInsight));
          return;
        }

        await generateInsights();
      },
    );
  }

  Future<void> generateInsights() async {
    emit(const InsightLoading());

    final expensesResult = await _expensesUseCase();

    await expensesResult.fold(
      (failure) async {
        emit(InsightError(failure.message));
      },
      (expenses) async {
        if (expenses.isEmpty) {
          emit(const InsightError('Add some expenses first.'));
          return;
        }

        final json = jsonEncode(expenses.map(_expenseToJson).toList());

        final insightResult = await _generateUseCase(json);

        insightResult.fold(
          (failure) {
            emit(InsightError(failure.message));
          },
          (insight) {
            emit(InsightLoaded(insight));
          },
        );
      },
    );
  }

  Map<String, dynamic> _expenseToJson(Expense expense) {
    return {
      'merchant': expense.merchant,
      'amount': expense.amount,
      'date': expense.date.toIso8601String(),
      'category': expense.category.name,
    };
  }
}
