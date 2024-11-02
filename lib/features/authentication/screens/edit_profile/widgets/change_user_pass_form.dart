import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dev_mind/utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/auth_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final AuthController authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final RxBool _currentPasswordVisible = false.obs;
  final RxBool _newPasswordVisible = false.obs;
  final RxBool _confirmPasswordVisible = false.obs;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      authController.updateUserPassword(
        currentPasswordController.text,
        newPasswordController.text,
      ).then((_){
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      });
    }
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required RxBool isPasswordVisible,
    String? Function(String?)? validator,
  }) {
    return Obx(
          () => TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: TColors.textSecondary, fontSize: 16),
          prefixIcon: Icon(Icons.lock_outline, color: TColors.primary),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
              color: TColors.primary,
            ),
            onPressed: () => isPasswordVisible.value = !isPasswordVisible.value,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: TColors.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: TColors.textSecondary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: TColors.primary, width: 2),
          ),
        ),
        obscureText: !isPasswordVisible.value,
        validator: validator ?? (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: dark ? Colors.black87 : Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: dark ? Colors.grey.shade900 : Colors.grey.shade500,
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cambio de Contraseña',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: TColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Elige una contraseña segura y fácil de recordar.',
                  style: TextStyle(color: TColors.textSecondary, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: currentPasswordController,
                  labelText: 'Contraseña Actual',
                  isPasswordVisible: _currentPasswordVisible,
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: newPasswordController,
                  labelText: 'Nueva Contraseña',
                  isPasswordVisible: _newPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    if (value.length < 8) {
                      return 'Debe tener al menos 8 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: confirmPasswordController,
                  labelText: 'Confirmar Nueva Contraseña',
                  isPasswordVisible: _confirmPasswordVisible,
                  validator: (value) {
                    if (value != newPasswordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Obx(() {
                  return authController.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.buttonPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _changePassword,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_reset),
                          SizedBox(width: 8),
                          Text(
                            'Actualizar Contraseña',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}