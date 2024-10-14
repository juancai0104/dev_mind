import 'dart:convert';
import 'package:http/http.dart' as http;

class CodeEditorController {
  Future<String> executeCode({
    required String code,
    required int language,
    required int exerciseId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/compile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'exerciseId': exerciseId,
          'language': language,
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