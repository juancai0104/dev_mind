import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/javascript.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../controllers/module/code_editor_controller.dart'; // Importa el controlador

class CodeEditor extends StatefulWidget {
  final int? languageId;
  final String exerciseTitle;
  final String exerciseDescription;
  final int exerciseId;

  const CodeEditor({
    super.key,
    this.languageId,
    required this.exerciseTitle,
    required this.exerciseDescription,
    required this.exerciseId,
  });

  @override
  _CodeEditorState createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  String _output = '';
  late CodeController controller;
  bool _isExecuting = false;

  @override
  void initState() {
    super.initState();
    controller = CodeController(
      text: '',
      language: _getLanguage(widget.languageId ?? 1),
    );
  }

  dynamic _getLanguage(int languageId) {
    switch (languageId) {
      case 1:
        return python;
      case 2:
        return javascript;
      default:
        return python;
    }
  }

  Future<void> executeCode() async {
    if (_isExecuting) return;

    final code = controller.text;
    final language = widget.languageId ?? 1;

    setState(() {
      _isExecuting = true;
    });

    CodeEditorController codeEditorController = CodeEditorController();
    final output = await codeEditorController.executeCode(
      code: code,
      language: language,
      exerciseId: widget.exerciseId,
    );

    // Decodificar la respuesta JSON y procesar el array de resultados
    final decodedResponse = jsonDecode(output);
    final results = decodedResponse['results'] as List<dynamic>;

    // Iterar sobre los resultados y construir la salida
    String formattedOutput = '';
    for (var result in results) {
      formattedOutput += 'Output: ${result['output']}\n';
      formattedOutput += 'Expected: ${result['expectedResult']}\n';
      formattedOutput += 'Correct: ${result['isCorrect']}\n\n';
    }

    setState(() {
      _output = formattedOutput;
      _isExecuting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exerciseTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: TColors.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  widget.exerciseDescription,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CodeTheme(
                data: CodeThemeData(styles: a11yLightTheme),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                          maxWidth: constraints.maxWidth,
                        ),
                        child: CodeField(
                          controller: controller,
                          minLines: 10,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,  // Esto hace que el botón ocupe todo el ancho disponible
                child: ElevatedButton(
                  onPressed: _isExecuting ? null : executeCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6F61),
                    foregroundColor: Colors.white,
                  ),
                  child: _isExecuting
                      ? const SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ))
                      : const Text('Ejecutar código'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _output,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}