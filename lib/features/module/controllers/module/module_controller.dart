import 'package:dev_mind/features/module/models/module.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class ModuleController extends GetxController {
  var moduleList = <Module>[].obs;
  var isLoading = true.obs;
  final baseUrl = dotenv.env['API_URL'];

  Future<void> getByModuleId(int moduleId) async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('$baseUrl/theories/module/$moduleId'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        moduleList.value = [Module.fromJson(jsonData)];
      } else {
        throw Exception('Failed to load exercises');
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }
}