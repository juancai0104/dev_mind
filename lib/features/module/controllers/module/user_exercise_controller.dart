import 'package:get/get.dart';

import '../../../../utils/http/http_client.dart';

class UserExerciseController extends GetxController {
  Future<void> saveUserExercise(int userId, int exerciseId) async {
    try {
      await THttpHelper.post('user-exercises', {
        'userId': userId,
        'exerciseId': exerciseId
      });
    } catch (e) {
      Get.snackbar('Error', 'No se pudo guardar el ejercicio.');
    }
  }

  Future<void> resetUserLevelExercises(int userId, int moduleId, int difficultyId) async {
    try {
      await THttpHelper.delete('user-exercises/reset-level', data: {
        'userId': userId,
        'moduleId': moduleId,
        'difficultyId': difficultyId,
      });
      Get.snackbar('Éxito', 'Nivel restablecido correctamente.');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo restablecer el nivel.');
    }
  }
}

