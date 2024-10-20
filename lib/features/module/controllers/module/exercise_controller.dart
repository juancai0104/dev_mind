import 'package:dev_mind/features/module/models/exercise.dart';
import '../../../../utils/http/http_client.dart';

class ExerciseController {
  Future<List<Exercise>> getPendingExercises(int userId, int moduleId, int difficultyId) async {
    try {
      final data = await THttpHelper.get('exercises/$userId/$moduleId/$difficultyId');

      if (data is List) {
        return data.map((json) => Exercise.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected data format, expected a list');
      }
    } catch (e) {
      throw Exception('Failed to load incomplete exercises: $e');
    }
  }
}