import 'package:dev_mind/features/module/models/module.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class ModuleController extends GetxController {
  var moduleList = <Module>[].obs;
  var isLoading = true.obs;

  Future<void> getByModuleId(int moduleId) async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/theories/module/$moduleId'),
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