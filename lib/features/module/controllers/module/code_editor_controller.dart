import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CodeEditorController {
  final baseUrl = dotenv.env['API_URL'];
  Future<String> executeCode({
    required String code,
    required int moduleId,
    required int exerciseId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/compile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'exerciseId': exerciseId,
          'moduleId': moduleId,
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error: ${response.body}';
      }
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}