import 'dart:async';
import 'package:dev_mind/features/authentication/screens/login/login.dart';
import 'package:dev_mind/features/module/screens/home/home.dart';
import 'package:dev_mind/utils/constants/colors.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../navigation_menu.dart';
import '../models/users.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

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
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;

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
        Get.snackbar('Éxito', 'Registro completado correctamente', snackPosition: SnackPosition.TOP);
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
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(timeout);

      print('Respuesta de login - Status: ${response.statusCode}');
      print('Respuesta de login - Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        currentUser.value = User.fromJson(data);
        isAuthenticated.value = true;
        Get.offAll(() => const NavigationMenu());
        Get.snackbar('Éxito', 'Inicio de sesión exitoso', snackPosition: SnackPosition.TOP);
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


        Get.offAll(() => LoginScreen());
        Get.snackbar('Éxito', 'Sesión cerrada correctamente', snackPosition: SnackPosition.TOP);
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
        Get.snackbar('Éxito', 'Perfil actualizado correctamente', snackPosition: SnackPosition.TOP);
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
        body: jsonEncode({'currentPassword': currentPassword, 'newPassword': newPassword}),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        Get.snackbar('Éxito', 'Contraseña actualizada correctamente', snackPosition: SnackPosition.TOP);
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
  // En el AuthController de Flutter

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Limpiar sesiones previas
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();

      // Iniciar proceso de Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Se canceló el inicio de sesión con Google');
      }

      // Obtener credenciales de Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Crear credencial de Firebase
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Autenticar con Firebase
      final firebase_auth.UserCredential firebaseResult =
      await _firebaseAuth.signInWithCredential(credential);

      final firebase_auth.User? firebaseUser = firebaseResult.user;
      if (firebaseUser == null) {
        throw Exception('No se pudo obtener la información del usuario');
      }

      // Preparar datos para el backend
      final Map<String, dynamic> userData = {
        'id': firebaseUser.uid,
        'googleId': firebaseUser.uid,
        'fullName': firebaseUser.displayName ?? '',
        'email': firebaseUser.email ?? '',
        'username': firebaseUser.email?.split('@')[0] ?? '',
        'phoneNumber': firebaseUser.phoneNumber ?? '',
      };

      // Enviar datos al backend
      final response = await http.post(
        Uri.parse('$apiUrl/google-signin'),
        headers: _headers,
        body: jsonEncode(userData),
      ).timeout(timeout);

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        currentUser.value = User(
          id: responseData['id'] is int
              ? responseData['id']
              : int.tryParse(responseData['id'].toString()),
          googleId: responseData['googleId'] as String?,
          fullName: responseData['fullName'] ?? '',
          username: responseData['username'] ?? '',
          phoneNumber: responseData['phoneNumber'] ?? '',
          email: responseData['email'] ?? '',
        );

        isAuthenticated.value = true;

        Get.off(
              () => const NavigationMenu(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );

        Get.snackbar(
          'Éxito',
          'Inicio de sesión con Google exitoso',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(10),
          borderRadius: 10,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
      } else {
        // Manejar el error específico de correo existente
        if (responseData['code'] == 'EMAIL_EXISTS') {
          Get.snackbar(
            'Error',
            'Este correo ya está registrado con una cuenta normal. Por favor, inicie sesión con su contraseña o use otro correo.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: TColors.error.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
            margin: const EdgeInsets.all(10),
            borderRadius: 10,
            icon: const Icon(Icons.error_outline, color: Colors.white),
          );
        } else {
          throw Exception(responseData['error'] ?? 'Error en la autenticación con el servidor');
        }
      }
    } catch (e) {
      print('Error detallado en signInWithGoogle: $e');

      // Limpiar estado en caso de error
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      currentUser.value = null;
      isAuthenticated.value = false;

      Get.snackbar(
        'Error',
        'No se pudo completar el inicio de sesión con Google: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: TColors.error.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Método para cerrar sesión con Google
  Future<void> signOutFromGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      await logout();
    } catch (e) {
      _handleException(e, 'Cierre de sesión de Google');
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

  void _handleTimeout() {
    errorMessage.value = 'La operación tardó demasiado tiempo';
    Get.snackbar(
      'Error de conexión',
      'El servidor no responde. Por favor, intenta más tarde.',
      snackPosition: SnackPosition.TOP,
    );
  }

  void _handleException(dynamic e, String operation) {
    print('Error en $operation: $e');
    errorMessage.value = 'Error de conexión: $e';
    Get.snackbar(
      'Error',
      'Ocurrió un error durante la $operation',
      snackPosition: SnackPosition.TOP,
    );
  }


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