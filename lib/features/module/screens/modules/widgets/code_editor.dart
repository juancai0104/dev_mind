import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/javascript.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../controllers/module/code_editor_controller.dart'; // Importa el controlador
import '../../../controllers/module/exercise_controller.dart'; // Importa el controlador de ejercicios
import '../../../models/exercise.dart'; // Importa el modelo Exercise

class CodeEditor extends StatefulWidget {
  final int moduleId;
  final int difficultyId; // Dificultad del ejercicio (1: Principiante, 2: Intermedio, 3: Avanzado)

  const CodeEditor({
    super.key,
    required this.moduleId,
    required this.difficultyId,
  });

  @override
  _CodeEditorState createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  String _output = '';
  late CodeController controller;
  bool _isExecuting = false;
  int currentExerciseIndex = 0;
  List<Exercise> exercises = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
    controller = CodeController(
      text: '',
      language: _getLanguage(widget.moduleId),
    );
  }

  Future<void> _loadExercises() async {
    try {
      ExerciseController exerciseController = ExerciseController();
      print(widget.moduleId);
      print(widget.difficultyId);
      exercises = await exerciseController.getByModuleIdAndDifficultyId(widget.moduleId, widget.difficultyId);
      setState(() {
        if (exercises.isNotEmpty) {
          controller = CodeController(
            text: '',
            language: _getLanguage(widget.moduleId),
          );
        }
      });
    } catch (e) {
      print('Error loading exercises: $e');
    }
  }

  dynamic _getLanguage(int moduleId) {
    switch (moduleId) {
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
    final language = _getLanguage(widget.moduleId);

    setState(() {
      _isExecuting = true;
    });

    CodeEditorController codeEditorController = CodeEditorController();
    try {
      final output = await codeEditorController.executeCode(
        code: code,
        moduleId: widget.moduleId,
        exerciseId: exercises[currentExerciseIndex].id,
      );

      // Decodificar la respuesta JSON y procesar el array de resultados
      final decodedResponse = jsonDecode(output);
      final results = decodedResponse['results'] as List<dynamic>;

      // Iterar sobre los resultados y construir la salida
      String formattedOutput = '';
      for (var result in results) {
        formattedOutput += 'Output: ${result['output']}\n';
        formattedOutput += 'OutputNew: ${result['outputNew']}';
        formattedOutput += 'Expected: ${result['expectedResult']}\n';
        formattedOutput += 'Correct: ${result['isCorrect']}\n\n';
      }

      setState(() {
        _output = formattedOutput;
      });

      // Verificar si el ejercicio fue resuelto correctamente
      bool allCorrect = results.every((result) => result['isCorrect'] == true);
      if (allCorrect) {
        _showSuccessModal();
      } else {
        _showFailureModal();
      }
    } catch (error) {
      setState(() {
        _output = 'Error al ejecutar el código: $error';
      });
    } finally {
      setState(() {
        _isExecuting = false;
      });
    }
  }

  void _showSuccessModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Correcto!'),
          content: const Text('Has resuelto el ejercicio correctamente.'),
          actions: [
            TextButton(
              child: const Text('Continuar'),
              onPressed: () {
                Navigator.pop(context);
                _goToNextExercise();
              },
            ),
          ],
        );
      },
    );
  }

  void _showFailureModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Incorrecto'),
          content: const Text('Tu código no ha pasado las pruebas. Revisa los resultados y vuelve a intentarlo.'),
          actions: [
            TextButton(
              child: const Text('Volver a intentar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _goToNextExercise() {
    if (currentExerciseIndex < exercises.length - 1) {
      setState(() {
        currentExerciseIndex++;
        _output = '';
        controller.clear();
      });
    } else {
      // Lógica para cuando el usuario termine todos los ejercicios
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('¡Felicidades!'),
            content: const Text('Has completado todos los ejercicios de este nivel.'),
            actions: [
              TextButton(
                child: const Text('Aceptar'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (exercises.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentExercise = exercises[currentExerciseIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Ejercicio ${currentExerciseIndex + 1}'),
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
                  currentExercise.description,
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
                width: double.infinity,
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
                    ),
                  )
                      : const Text('Ejecutar código'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}