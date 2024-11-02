import 'dart:async';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserValidationController extends GetxController {
  final String apiUrl = 'http://10.0.2.2:3000/api/auth';


  var isEmailAvailable = true.obs;
  var isUsernameAvailable = true.obs;
  var isValidating = false.obs;


  Timer? _emailDebounceTimer;
  Timer? _usernameDebounceTimer;

  // Headers para las peticiones HTTP
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Verificar disponibilidad del email
  Future<bool> checkEmailAvailability(String email) async {
    if (email.isEmpty) return true;

    isValidating.value = true;

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/check-email'),
        headers: _headers,
        body: jsonEncode({'email': email}),
      );

      isEmailAvailable.value = response.statusCode == 200;
      return isEmailAvailable.value;
    } catch (e) {
      print('Error checking email availability: $e');
      return false;
    } finally {
      isValidating.value = false;
    }
  }

  Future<bool> checkUsernameAvailability(String username) async {
    if (username.isEmpty) return true;

    isValidating.value = true;

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/check-username'),
        headers: _headers,
        body: jsonEncode({'username': username}),
      );

      isUsernameAvailable.value = response.statusCode == 200;
      return isUsernameAvailable.value;
    } catch (e) {
      print('Error checking username availability: $e');
      return false;
    } finally {
      isValidating.value = false;
    }
  }


  void validateEmail(String email) {
    _emailDebounceTimer?.cancel();
    _emailDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      checkEmailAvailability(email);
    });
  }


  void validateUsername(String username) {
    _usernameDebounceTimer?.cancel();
    _usernameDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      checkUsernameAvailability(username);
    });
  }

  @override
  void onClose() {
    _emailDebounceTimer?.cancel();
    _usernameDebounceTimer?.cancel();
    super.onClose();
  }
}