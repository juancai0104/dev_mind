import 'package:dev_mind/features/module/models/exercise.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExerciseController {
  Future<List<Exercise>> getByModuleIdAndDifficultyId(int moduleId, int difficultyId) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/api/exercises/$moduleId/$difficultyId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      print(jsonData.map((json) => Exercise.fromJson(json)).toList());
      return jsonData.map((json) => Exercise.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }
}