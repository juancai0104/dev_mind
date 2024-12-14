import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/user_validation_controller.dart';
import '../../../models/users.dart';

class TSignupForm extends StatefulWidget {
  const TSignupForm({super.key});

  @override
  State<TSignupForm> createState() => _TSignupFormState();
}

class _TSignupFormState extends State<TSignupForm> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  final authController = Get.find<AuthController>();
  final validationController = Get.put(UserValidationController());

  bool _obscurePassword = true;
  bool _termsAccepted = false;

  @override
  void initState() {
    super.initState();

    emailController.addListener(() {
      validationController.validateEmail(emailController.text);
    });

    usernameController.addListener(() {
      validationController.validateUsername(usernameController.text);
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El email es requerido';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Ingresa un email válido';
    }
    if (!validationController.isEmailAvailable.value) {
      return 'Este email ya está registrado';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre de usuario es requerido';
    }
    if (!validationController.isUsernameAvailable.value) {
      return 'Este nombre de usuario ya está en uso';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La contraseña es requerida';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El teléfono es requerido';
    }
    if (!GetUtils.isPhoneNumber(value)) {
      return 'Ingresa un número de teléfono válido';
    }
    return null;
  }

  Future<void> _handleSignup() async {
    if (!_termsAccepted) {
      Get.snackbar(
        'Error',
        'Debes aceptar los términos y condiciones',
        backgroundColor: TColors.error.withOpacity(0.1),
        colorText: TColors.error,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final isEmailValid = await validationController.checkEmailAvailability(emailController.text);
    final isUsernameValid = await validationController.checkUsernameAvailability(usernameController.text);

    if (!isEmailValid || !isUsernameValid) {
      Get.snackbar(
        'Error',
        'El email o nombre de usuario ya están en uso',
        backgroundColor: TColors.error.withOpacity(0.1),
        colorText: TColors.error,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final user = User(
        fullName: '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
        username: usernameController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      authController.signup(user);
    }
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: firstNameController,
                    validator: (value) => _validateRequired(value, 'El nombre'),
                    decoration: InputDecoration(
                      labelText: TTexts.firstName,
                      prefixIcon: Icon(Iconsax.user, color: TColors.secondary),
                      filled: true,
                      fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwInputFields / 2),
                Expanded(
                  child: TextFormField(
                    controller: lastNameController,
                    validator: (value) => _validateRequired(value, 'El apellido'),
                    decoration: InputDecoration(
                      labelText: TTexts.lastName,
                      prefixIcon: Icon(Iconsax.user, color: TColors.secondary),
                      filled: true,
                      fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            Obx(() => TextFormField(
              controller: usernameController,
              validator: _validateUsername,
              decoration: InputDecoration(
                labelText: TTexts.username,
                prefixIcon: const Icon(Iconsax.user_edit, color: TColors.secondary),
                suffixIcon: validationController.isValidating.value
                    ? const CircularProgressIndicator(strokeWidth: 2)
                    : Icon(
                  validationController.isUsernameAvailable.value
                      ? Icons.check_circle
                      : Icons.error,
                  color: validationController.isUsernameAvailable.value
                      ? Colors.green
                      : Colors.red,
                ),
                filled: true,
                fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            )),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            Obx(() => TextFormField(
              controller: emailController,
              validator: _validateEmail,
              decoration: InputDecoration(
                labelText: TTexts.email,
                prefixIcon: const Icon(Iconsax.direct, color: TColors.secondary),
                suffixIcon: validationController.isValidating.value
                    ? const CircularProgressIndicator(strokeWidth: 2)
                    : Icon(
                  validationController.isEmailAvailable.value
                      ? Icons.check_circle
                      : Icons.error,
                  color: validationController.isEmailAvailable.value
                      ? Colors.green
                      : Colors.red,
                ),
                filled: true,
                fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            )),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            TextFormField(
              controller: phoneNumberController,
              validator: _validatePhone,
              decoration: InputDecoration(
                labelText: TTexts.phoneNumber,
                prefixIcon: Icon(Iconsax.call, color: TColors.secondary),
                filled: true,
                fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Contraseña Field
            TextFormField(
              controller: passwordController,
              validator: _validatePassword,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: TTexts.password,
                prefixIcon: const Icon(Iconsax.password_check, color: TColors.secondary),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Iconsax.eye_slash : Iconsax.eye, color: TColors.secondary),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                filled: true,
                fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            Row(
              children: [
                Checkbox(
                  value: _termsAccepted,
                  onChanged: (value) {
                    setState(() {
                      _termsAccepted = value!;
                    });
                  },
                ),
                Flexible( // O también puedes usar Expanded
                  child: Text(TTexts.acceptTerms),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            // Botón de Registro
            SizedBox(

              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSignup,
                child: Text(TTexts.createAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
