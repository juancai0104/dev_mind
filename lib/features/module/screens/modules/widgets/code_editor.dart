import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/javascript.dart'; // Puedes agregar más lenguajes si es necesario

class CodeEditor extends StatefulWidget {
  final String? languageName; // Permitir que languageName sea null

  const CodeEditor({super.key, this.languageName});

  @override
  _CodeEditorState createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  String _output = '';
  CodeController? controller; // Cambiar a opcional

  @override
  void initState() {
    super.initState();

    // Inicializa el controlador basado en el lenguaje pasado como parámetro
    setState(() {
      controller = CodeController(
        text: '',
        language: _getLanguage(widget.languageName ?? 'python'),
      );
    });
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
    if (controller == null) return;

    final code = controller!.text;
    final language = widget.languageName ?? 'python'; // Si es null, usa 'python'

    print('Code: $code');
    print('Language: $language');

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
      final output = jsonDecode(response.body)['output'];
      setState(() {
        _output = output;
      });
      print('Output: $output');
    } else {
      setState(() {
        _output = 'Error: ${response.body}';
      });
      print('Error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Asegúrate de que el controller no es null
    if (controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Ejercicio en ${widget.languageName?.toUpperCase() ?? 'PYTHON'}'),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text(
                'Implementa una función en Python llamada multiplicacion(val1, val2) que calcule la multiplicación entre dos números. La función debe imprimir el resultado de la multiplicación de val1 y val2.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0), // Ajuste del padding horizontal
              child: CodeTheme(
                data: CodeThemeData(styles: a11yLightTheme),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: constraints.maxWidth),
                        child: CodeField(
                          controller: controller!,
                          minLines: 20,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: executeCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6F61),
                foregroundColor: Colors.white,
              ),
              child: const Text('Ejecutar código'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _output,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}