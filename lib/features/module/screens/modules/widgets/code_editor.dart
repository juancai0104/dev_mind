import 'dart:convert';

import 'package:dev_mind/common/widgets/modules/dialogs/custom_dialog.dart';
import 'package:dev_mind/features/module/controllers/module/user_exercise_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:get/get.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../navigation_menu.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../authentication/controllers/auth_controller.dart';
import '../../../controllers/module/code_editor_controller.dart';
import '../../../controllers/module/exercise_controller.dart';
import '../../../models/exercise.dart';

class CodeEditor extends StatefulWidget {
  final int moduleId;
  final int difficultyId;

  const CodeEditor({
    super.key,
    required this.moduleId,
    required this.difficultyId,
  });

  @override
  _CodeEditorState createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  final AuthController authController = Get.find<AuthController>();
  String _output = '';
  late CodeController controller;
  bool _isExecuting = false;
  int currentExerciseIndex = 0;
  List<Exercise> exercises = [];
  bool allExercisesCompleted = false;

  @override
  void initState() {
    super.initState();
    allExercisesCompleted = false;
    currentExerciseIndex = 0;
    _loadExercises();
    controller = CodeController(
      text: '',
      language: _getLanguage(widget.moduleId),
    );
  }

  Future<void> _loadExercises() async {
    try {
      ExerciseController exerciseController = ExerciseController();

      final userId = authController.currentUser.value?.id ?? 1;

      print("Difficulty ${widget.difficultyId}");
      exercises = await exerciseController.getPendingExercises(userId, widget.moduleId, widget.difficultyId);

      setState(() {
        if (exercises.isEmpty) {
          allExercisesCompleted = true;
          _showLevelCompletionModal();
        } else {
          allExercisesCompleted = false;
        }
      });
    } catch (e) {
      print('Error loading exercises: $e');
    }
  }

  void _showLevelCompletionModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Iconsax.cup, color: TColors.accent, size: 28),
              SizedBox(width: 8),
              Text('¡Nivel completado!'),
            ],
          ),
          content: const Text(
            'Has completado todos los ejercicios de este nivel. '
            '¿Quieres avanzar al siguiente nivel o restablecer este nivel?'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetLevel();
              },
              style: TextButton.styleFrom(foregroundColor: TColors.accent),
              child: const Text('Restablecer nivel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _goToNextLevel();
              },
              style: TextButton.styleFrom(foregroundColor: TColors.accent),
              child: const Text('Siguiente nivel'),
            ),
          ],
        );
      },
    );
  }

  void _resetLevel() async {
    UserExerciseController userExerciseController = Get.put(UserExerciseController());
    final userId = authController.currentUser.value?.id ?? 1;

    await userExerciseController.resetUserLevelExercises(userId, widget.moduleId, widget.difficultyId);

    setState(() {
      allExercisesCompleted = false;
      currentExerciseIndex = 0;
    });
    _loadExercises();
  }

  void _goToNextLevel() {
    int nextDifficulty = widget.difficultyId + 1;

    if (nextDifficulty <= 3) {
      Get.offAll(() => CodeEditor(
        moduleId: widget.moduleId,
        difficultyId: nextDifficulty,
      ));
    } else {
      _showAllLevelsCompletedModal();
    }
  }

  void _showAllLevelsCompletedModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Iconsax.cake, color: TColors.accent, size: 28),
              SizedBox(width: 8),
              Text('¡Felicidades!'),
            ],
          ),
          content: const Text('Has completado todos los ejercicios de todos los niveles.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Get.offAll(() => const NavigationMenu());
              },
              style: TextButton.styleFrom(foregroundColor: TColors.accent),
              child: const Text('Volver al inicio'),
            ),
          ],
        );
      },
    );
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

      final decodedResponse = jsonDecode(output);
      final results = decodedResponse['results'] as List<dynamic>;

      String formattedOutput = '';
      for (var result in results) {
        //formattedOutput += '${result['output']}\n';
        formattedOutput += '${result['outputNew']}';
        formattedOutput += '${result['expectedResult']}\n';
        //formattedOutput += '${result['isCorrect']}\n\n';
      }

      setState(() {
        _output = formattedOutput;
      });

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
        return CustomDialog(
          title: '¡Correcto!',
          message: 'Has resuelto el ejercicio correctamente.',
          icon: Iconsax.tick_circle,
          iconColor: Colors.green,
          buttonText: 'Continuar',
          formattedOutput: _output,
          onButtonPressed: () async {
            Navigator.pop(context);

            UserExerciseController userExerciseController = Get.put(UserExerciseController());
            final userId = authController.currentUser.value?.id ?? 1;
            await userExerciseController.saveUserExercise(userId, exercises[currentExerciseIndex].id);

            if(mounted) {
              _goToNextExercise();
            }
          }
        );
      },
    );
  }

  void _showFailureModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Incorrecto',
          message: 'Tu código no ha pasado las pruebas. Revisa los resultados y vuelve a intentarlo.',
          icon: Iconsax.close_circle,
          iconColor: Colors.red,
          buttonText: 'Volver a intentar',
          formattedOutput: _output,
          onButtonPressed: () {
            Navigator.pop(context);
          },
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
      int nextLevel = widget.difficultyId + 1;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Iconsax.cake, color: Colors.green),
                SizedBox(width: 8),
                Text('¡Felicidades!')
              ],
            ),
            content: nextLevel <= 3
              ? const Text('Has completado todos los ejercicios de este nivel. ¿Quieres continuar al siguiente nivel o volver al inicio?')
              : const Text('¡Felicidades! Has completado todos los niveles. ¿Quieres volver al inicio o restablecer el nivel?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Get.offAll(() => const NavigationMenu());
                },
                style: TextButton.styleFrom(foregroundColor: TColors.accent),
                child: const Text('Ir al inicio')
              ),
              if(nextLevel <= 3)
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);

                      //int nextLevel = widget.difficultyId + 1;

                      Get.off(() => CodeEditor(
                        moduleId: widget.moduleId,
                        difficultyId: nextLevel
                      ));

                    },
                    style: TextButton.styleFrom(foregroundColor: TColors.accent),
                    child: const Text('Siguiente nivel')
                )
              else
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);

                    UserExerciseController userExerciseController = Get.put(UserExerciseController());
                    final userId = authController.currentUser.value?.id ?? 1;

                    await userExerciseController.resetUserLevelExercises(userId, widget.moduleId, widget.difficultyId);

                    setState(() {
                      currentExerciseIndex = 0;
                      _output = '';
                      controller.clear();
                    });
                  },
                  style: TextButton.styleFrom(foregroundColor: TColors.accent),
                  child: const Text('Restablecer nivel'),
                ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (allExercisesCompleted) {
      return Container(
        color: TColors.primary,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
              SizedBox(height: 16),
              Text(
                '¡Nivel completado!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    if (exercises.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentExercise = exercises[currentExerciseIndex];
    final totalExercises = exercises.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ejercicio ${currentExerciseIndex + 1} de $totalExercises'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              //Navigator.pop(context);
              Get.offAll(() => const NavigationMenu());
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