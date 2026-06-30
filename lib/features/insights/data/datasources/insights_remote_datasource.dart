import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/insights_model.dart';

const String _insightPrompt = '''
You are a financial assistant.

You will receive a JSON array of expenses.

Generate a spending report.

The report MUST include:

1. Total Spending

2. Category-wise Breakdown

3. Largest Expense

4. Spending Trends

5. One actionable recommendation.

Return the report in Markdown.

Format it like this:

# Spending Report

## Total Spending

₹12,540

## Category Breakdown

- Food: ₹5,200
- Shopping: ₹2,800
- Travel: ₹1,600

## Largest Expense

MacBook Charger — ₹3,500

## Spending Trends

...

## Recommendation

...

Do not return JSON.

Do not return markdown code fences.
''';

abstract interface class InsightsRemoteDataSource {
  Future<SpendingInsightModel> generateInsights(String expensesJson);
}

class InsightsRemoteDataSourceImpl implements InsightsRemoteDataSource {
  final ApiClient _client;

  InsightsRemoteDataSourceImpl(this._client);

  @override
  Future<SpendingInsightModel> generateInsights(String expensesJson) async {
    try {
      final response = await _client.dio.post(
        'models/gemini-2.5-flash:generateContent',
        data: {
          'contents': [
            {
              'parts': [
                {'text': '$_insightPrompt\n\nExpenses:\n$expensesJson'},
              ],
            },
          ],
        },
      );

      final candidates = response.data['candidates'];

      if (candidates == null || candidates.isEmpty) {
        throw const ServerException('AI could not generate spending insights.');
      }

      final report = candidates[0]['content']['parts'][0]['text'] as String;

      return SpendingInsightModel.fromText(report);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['error']?['message'] ??
            'Unable to connect to the AI service.',
      );
    } on ServerException {
      rethrow;
    } catch (_) {
      throw const ServerException('Failed to generate spending insights.');
    }
  }
}
