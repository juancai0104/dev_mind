import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';
import 'features/authentication/controllers/auth_controller.dart';

void main() async {
  await GetStorage.init();
  Get.put(AuthController());
  runApp(const App());
}