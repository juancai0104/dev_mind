import 'dart:async';

import 'package:dev_mind/features/authentication/screens/login/login.dart';
import 'package:dev_mind/features/module/screens/home/home.dart';
import 'package:dev_mind/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../navigation_menu.dart';
import '../models/users.dart';

class AuthController extends GetxController {
  // Variables de estado
  var currentUser = Rxn<User>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isAuthenticated = false.obs;

  // Variables de configuración
  final String apiUrl = 'http://10.0.2.2:3000/api/auth';
  final String apiUrlUpdate = 'http://10.0.2.2:3000/api/users';
  final Duration timeout = const Duration(seconds: 10);


  // Encabezados de las peticiones HTTP
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

// Métodos para autenticación
  Future<void> signup(User user) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('Iniciando registro con email: ${user.email}');

      final response = await http.post(
        Uri.parse('$apiUrl/signup'),
        headers: _headers,
        body: jsonEncode(user.toJson()),
      ).timeout(timeout);

      print('Respuesta de registro - Status: ${response.statusCode}');
      print('Respuesta de registro - Body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        currentUser.value = User.fromJson(data);
        isAuthenticated.value = true;
        Get.to(() => const LoginScreen());
        Get.snackbar('Éxito', 'Registro completado correctamente',
            snackPosition: SnackPosition.TOP);
      } else {
        _handleError(response);
      }
    } on TimeoutException {
      _handleTimeout();
    } catch (e) {
      _handleException(e, 'registro');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('Iniciando login con email: $email');

      final response = await http.post(
        Uri.parse('$apiUrl/login'),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(timeout);

      print('Respuesta de login - Status: ${response.statusCode}');
      print('Respuesta de login - Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        currentUser.value = User.fromJson(data);
        isAuthenticated.value = true;
        Get.offAll(() => const NavigationMenu());
        Get.snackbar('Éxito', 'Inicio de sesión exitoso',
            snackPosition: SnackPosition.TOP);
      } else {
        _handleError(response);
      }
    } on TimeoutException {
      _handleTimeout();
    } catch (e) {
      _handleException(e, 'login');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/logout'),
        headers: _headers,
      ).timeout(timeout);

      if (response.statusCode == 200) {
        currentUser.value = null;
        isAuthenticated.value = false;
        Get.to(LoginScreen());
        Get.snackbar('Éxito', 'Sesión cerrada correctamente',
            snackPosition: SnackPosition.TOP);
      } else {
        _handleError(response);
      }
    } on TimeoutException {
      _handleTimeout();
    } catch (e) {
      _handleException(e, 'logout');
    } finally {
      isLoading.value = false;
    }
  }
// Métodos para actualizar el perfil de usuario
  Future<void> updateUserProfile(User user) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.put(
        Uri.parse('$apiUrlUpdate/update/${user.id}'),
        headers: _headers,
        body: jsonEncode(user.toJson()),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        currentUser.value = user;
      } else {
        _handleError(response);
      }
    } on TimeoutException {
      _handleTimeout();
    } catch (e) {
      _handleException(e, 'actualización de perfil');
    } finally {
      isLoading.value = false;
    }
  }
// Método para actualizar la contraseña del usuario
  Future<void> updateUserPassword(String currentPassword, String newPassword) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.put(
        Uri.parse('$apiUrlUpdate/update-password/${currentUser.value!.id}'),
        headers: _headers,
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        Get.snackbar('Éxito', 'Contraseña actualizada correctamente',
            snackPosition: SnackPosition.TOP);
      } else {
        _handleError(response);
      }
    } on TimeoutException {
      _handleTimeout();
    } catch (e) {
      _handleException(e, 'cambio de contraseña');
    } finally {
      isLoading.value = false;
    }
  }

// Método para autenticación con Google
  Future<void> googleAuth() async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/google'),
        headers: _headers,
      ).timeout(timeout);

      if (response.statusCode == 200) {
        // Manejar la respuesta de autenticación de Google
        print('Google Auth response: ${response.body}');
      } else {
        _handleError(response);
      }
    } catch (e) {
      _handleException(e, 'autenticación de Google');
    }
  }

  // Métodos privados para manejar errores
  void _handleError(http.Response response) {
    try {
      final errorData = jsonDecode(response.body);
      errorMessage.value = errorData['error'] ?? 'Error desconocido';
    } catch (e) {
      errorMessage.value = 'Error en la respuesta del servidor';
    }
    Get.snackbar(
      'Error',
      errorMessage.value,
      snackPosition: SnackPosition.TOP,
      backgroundColor: TColors.error,
    );
  }
  // Método para manejar errores de tiempo de espera
  void _handleTimeout() {
    errorMessage.value = 'La operación tardó demasiado tiempo';
    Get.snackbar(
      'Error de conexión',
      'El servidor no responde. Por favor, intenta más tarde.',
      snackPosition: SnackPosition.TOP,
    );
  }
// Método para manejar excepciones
  void _handleException(dynamic e, String operation) {
    print('Error en $operation: $e');
    errorMessage.value = 'Error de conexión: $e';
    Get.snackbar(
      'Error',
      'Ocurrió un error durante la $operation',
      snackPosition: SnackPosition.TOP,
    );
  }

  // Método para verificar el estado de autenticación
  Future<bool> checkAuthStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/check-auth'),
        headers: _headers,
      ).timeout(timeout);

      isAuthenticated.value = response.statusCode == 200;
      return isAuthenticated.value;
    } catch (e) {
      print('Error verificando estado de autenticación: $e');
      return false;
    }
  }
}