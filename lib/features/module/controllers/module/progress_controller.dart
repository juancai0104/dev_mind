import 'package:get/get.dart';
import '../../../../utils/http/http_client.dart';
import '../../models/progress.dart' as progress_model;

class ProgressController extends GetxController {
  var isLoading = false.obs;
  var progress = progress_model.Progress(userId: 0, moduleId: 0, progressPercentage: 0.0).obs;

  Future<void> fetchProgress(int userId, int moduleId) async {
    isLoading(true);
    try {
      var data = await THttpHelper.get('progresses?userId=$userId&moduleId=$moduleId');
      progress.value = progress_model.Progress.fromJson(data);
    } catch (e) {
      Get.snackbar('Error', 'No se pudo cargar el progreso.');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateProgress(progress_model.Progress updatedProgress) async {
    isLoading(true);
    try {
      await THttpHelper.put('progresses', updatedProgress.toJson());
      progress.value = updatedProgress;
    } catch (e) {
      Get.snackbar('Error', 'No se pudo actualizar el progreso.');
    } finally {
      isLoading(false);
    }
  }
}