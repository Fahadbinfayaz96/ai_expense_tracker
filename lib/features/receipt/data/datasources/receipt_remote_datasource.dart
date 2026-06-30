import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/receipt_model.dart';

const String _receiptPrompt = '''
You are an OCR receipt parser.

Analyze the attached receipt image.

Return ONLY valid JSON.

{
  "merchant":"",
  "amount":0,
  "date":"2026-06-29",
  "category":"food"
}

Rules:

- No markdown
- No explanation
- No code fences

Category MUST be exactly one of:

food
shopping
travel
utilities
entertainment
others

If merchant is missing use "Unknown".

If amount is missing use 0.

If date is missing use today's date.

Date format must be yyyy-MM-dd.
''';

abstract interface class ReceiptRemoteDataSource {
  Future<ReceiptModel> scanReceipt(File image);
}

class ReceiptRemoteDataSourceImpl implements ReceiptRemoteDataSource {
  final ApiClient _client;

  ReceiptRemoteDataSourceImpl(this._client);

  @override
  Future<ReceiptModel> scanReceipt(File image) async {
    try {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      final extension = image.path.split('.').last.toLowerCase();

      final mimeType = switch (extension) {
        'png' => 'image/png',
        'webp' => 'image/webp',
        'heic' => 'image/heic',
        _ => 'image/jpeg',
      };

      final response = await _client.dio.post(
        'models/gemini-2.5-flash:generateContent',
        data: {
          'contents': [
            {
              'parts': [
                {'text': _receiptPrompt},
                {
                  'inline_data': {'mime_type': mimeType, 'data': base64Image},
                },
              ],
            },
          ],
        },
      );

      final candidates = response.data['candidates'];

      if (candidates == null || candidates.isEmpty) {
        throw const ServerException(
          'AI could not read the receipt. Please try another image.',
        );
      }

      final text = candidates[0]['content']['parts'][0]['text'] as String;

      final cleaned = _cleanResponse(text);

      final json = jsonDecode(cleaned) as Map<String, dynamic>;

      return ReceiptModel.fromJson(json);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['error']?['message'] ??
            'Unable to connect to the AI service.',
      );
    } on FormatException {
      throw const ServerException('AI returned an invalid response.');
    } on ServerException {
      rethrow;
    } catch (_) {
      throw const ServerException('Failed to scan the receipt.');
    }
  }

  String _cleanResponse(String response) {
    return response.replaceAll('```json', '').replaceAll('```', '').trim();
  }
}
