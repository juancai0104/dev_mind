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
}