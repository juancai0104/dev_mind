import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/javascript.dart'; // Puedes agregar más lenguajes si es necesario

class CodeEditor extends StatefulWidget {
  final String? languageName;
  final String exerciseTitle;
  final String exerciseDescription;
  final int exerciseId;

  const CodeEditor({
    super.key,
    this.languageName,
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
      language: _getLanguage(widget.languageName ?? 'python'),
    );
  }

  // Función para seleccionar el lenguaje basado en el parámetro recibido
  dynamic _getLanguage(String languageName) {
    switch (languageName) {
      case 'python':
        return python; // Importado desde highlight/languages/python.dart
      case 'javascript':
        return javascript; // Importado desde highlight/languages/javascript.dart
      default:
        return python; // Lenguaje por defecto si no se pasa uno válido
    }
  }

  Future<void> executeCode() async {
    if (_isExecuting) return;

    final code = controller.text;
    final language = widget.languageName ?? 'python';

    setState(() {
      _isExecuting = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/compile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'exerciseId': widget.exerciseId,
          'language': language,
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        final output = jsonDecode(response.body)['output'];
        setState(() {
          _output = output;
        });
      } else {
        setState(() {
          _output = 'Error: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _output = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isExecuting = false;
      });
    }
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
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  widget.exerciseDescription,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                          minLines: 20,
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
              child: ElevatedButton(
                onPressed: _isExecuting ? null : executeCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6F61),
                  foregroundColor: Colors.white,
                ),
                child: _isExecuting
                    ? const CircularProgressIndicator()
                    : const Text('Ejecutar código'),
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