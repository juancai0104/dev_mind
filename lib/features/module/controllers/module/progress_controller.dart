import 'package:get/get.dart';
import '../../../../utils/http/http_client.dart';
import '../../../authentication/controllers/auth_controller.dart';
import '../../models/progress.dart' as progress_model;

class ProgressController extends GetxController {
  var isLoading = false.obs;
  var progress = progress_model.Progress(userId: 0, moduleId: 0, progressPercentage: 0.0).obs;
  final authController = Get.find<AuthController>();

  final int userId;
  final int moduleId;

  ProgressController({
    required this.userId,
    required this.moduleId,
  });

  @override
  void onInit() {
    super.onInit();
    fetchProgress();
  }

  Future<void> fetchProgress() async {
    isLoading(true);
    print('Fetching progress for userId: $userId, moduleId: $moduleId');
    try {
      var data = await THttpHelper.get('/progresses/progress/$userId/$moduleId');
      data['progressPercentage'] = double.tryParse(data['progressPercentage'].toString()) ?? 0.0;
      progress.value = progress_model.Progress.fromJson(data);
    } catch (e) {
      print('Error fetching progress: $e');
    } finally {
      isLoading(false);
    }
  }


  Future<void> updateProgress(progress_model.Progress updatedProgress) async {
    isLoading(true);
    try {
      await THttpHelper.put('/progresses/progress/${updatedProgress.userId}', updatedProgress.toJson());
      progress.value = updatedProgress;
    } catch (e) {
      print('Error updating progress: $e');
      Get.snackbar('Error', 'No se pudo actualizar el progreso.');
    } finally {
      isLoading(false);
    }
  }
}
