import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/python.dart';

class CodeEditorController extends GetxController {
  final CodeController codeController = CodeController(
    text: '',
    language: python,
  );

  var output = ''.obs;

  Future<void> executeCode() async {
    final code = codeController.text;
    const language = 'python';

    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/compile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'language': language,
        'code': code,
      }),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body)['output'];
      output.value = result;
    } else {
      output.value = 'Error: ${response.body}';
    }
  }
}