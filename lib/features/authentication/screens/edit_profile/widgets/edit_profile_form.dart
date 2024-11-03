import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/user_validation_controller.dart';
import '../../../models/users.dart';

class EditProfileForm extends StatefulWidget {
  final User currentUser;

  const EditProfileForm({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController fullNameController;
  late final TextEditingController usernameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneNumberController;
  final authController = Get.find<AuthController>();
  final validationController = Get.put(UserValidationController());

  bool _isLoading = false;
  bool _isEditing = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.currentUser.fullName);
    usernameController = TextEditingController(text: widget.currentUser.username);
    emailController = TextEditingController(text: widget.currentUser.email);
    phoneNumberController = TextEditingController(text: widget.currentUser.phoneNumber);

    fullNameController.addListener(_onFieldChanged);
    usernameController.addListener(() {
      _onFieldChanged();
      if (usernameController.text != widget.currentUser.username) {
        validationController.validateUsername(usernameController.text);
      }
    });
    emailController.addListener(() {
      _onFieldChanged();
      if (emailController.text != widget.currentUser.email) {
        validationController.validateEmail(emailController.text);
      }
    });
    phoneNumberController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final hasChanges =
        fullNameController.text != widget.currentUser.fullName ||
            usernameController.text != widget.currentUser.username ||
            emailController.text != widget.currentUser.email ||
            phoneNumberController.text != widget.currentUser.phoneNumber;

    if (hasChanges != _hasChanges) {
      setState(() => _hasChanges = hasChanges);
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email requerido';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Email inválido';
    }
    if (value != widget.currentUser.email && !validationController.isEmailAvailable.value) {
      return 'Este email ya está en uso';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Usuario requerido';
    }
    if (value != widget.currentUser.username && !validationController.isUsernameAvailable.value) {
      return 'Este nombre de usuario ya está en uso';
    }
    return null;
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  Future<void> _handleEditProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final newEmail = emailController.text.trim();
    final newUsername = usernameController.text.trim();


    if (newEmail != widget.currentUser.email) {
      final isEmailAvailable = await validationController.checkEmailAvailability(newEmail);
      if (!isEmailAvailable) {
        Get.snackbar(
          'Error',
          'El email ya está en uso',
          backgroundColor: TColors.error.withOpacity(0.1),
          colorText: TColors.error,
        );
        return;
      }
    }

    if (newUsername != widget.currentUser.username) {
      final isUsernameAvailable = await validationController.checkUsernameAvailability(newUsername);
      if (!isUsernameAvailable) {
        Get.snackbar(
          'Error',
          'El nombre de usuario ya está en uso',
          backgroundColor: TColors.error.withOpacity(0.1),
          colorText: TColors.error,
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      final updatedUser = User(
        id: widget.currentUser.id,
        fullName: fullNameController.text.trim(),
        username: newUsername,
        email: newEmail,
        phoneNumber: phoneNumberController.text.trim(),
      );

      await authController.updateUserProfile(updatedUser);

      Get.snackbar(
        'Éxito',
        'Perfil actualizado correctamente',
        backgroundColor: TColors.success.withOpacity(0.1),
        colorText: TColors.success,
      );

      setState(() {
        _isEditing = false;
        _hasChanges = false;
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo actualizar el perfil',
        backgroundColor: TColors.error.withOpacity(0.1),
        colorText: TColors.error,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildReadOnlyField(String label, String value, IconData icon) {
    final dark = THelperFunctions.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.2))),
      ),
      child: ListTile(
        leading: Icon(icon, color: TColors.primary),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: dark ? Colors.white70 : Colors.black87,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: dark ? Colors.white : Colors.black,
          ),
        ),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _buildEditableField(
      TextEditingController controller,
      String label,
      String? Function(String?) validator,
      IconData icon, {
        TextInputType? keyboardType,
        bool showValidationIcon = false,
        bool isEmailField = false, // Añadimos este parámetro para diferenciar campos
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: TColors.primary),
          suffixIcon: showValidationIcon
              ? Obx(() => validationController.isValidating.value
              ? const SizedBox(
            width: 20,//
            height: 20,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
              : Icon(
            isEmailField
                ? (validationController.isEmailAvailable.value
                ? Iconsax.tick_circle
                : Iconsax.close_circle)
                : (validationController.isUsernameAvailable.value
                ? Iconsax.tick_circle
                : Iconsax.close_circle),
            color: isEmailField
                ? (validationController.isEmailAvailable.value
                ? Colors.green
                : Colors.red)
                : (validationController.isUsernameAvailable.value
                ? Colors.green
                : Colors.red),
          ))
              : null,
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: TColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: TColors.error, width: 2),
          ),
        ),
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
                color: dark ? Colors.grey.shade900 : Colors.grey.shade300,
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Mi Perfil',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: TColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isEditing ? Iconsax.close_circle : Iconsax.edit,
                      color: TColors.primary,
                    ),
                    onPressed: () => setState(() => _isEditing = !_isEditing),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      child: child,
                    ),
                  );
                },
                child: _isEditing
                    ? Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildEditableField(
                        fullNameController,
                        TTexts.firstName,
                            (value) => _validateRequired(value, 'El nombre completo'),
                        Iconsax.user,
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      _buildEditableField(
                        usernameController,
                        TTexts.username,
                        _validateUsername,
                        Iconsax.user_edit,
                        showValidationIcon: true,
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      _buildEditableField(
                        emailController,
                        TTexts.email,
                        _validateEmail,
                        Iconsax.direct,
                        keyboardType: TextInputType.emailAddress,
                        showValidationIcon: true,
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      _buildEditableField(
                        phoneNumberController,
                        TTexts.phoneNumber,
                            (value) => _validateRequired(value, 'El teléfono'),
                        Iconsax.call,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _isEditing = false;
                                  fullNameController.text = widget.currentUser.fullName;
                                  usernameController.text = widget.currentUser.username;
                                  emailController.text = widget.currentUser.email;
                                  phoneNumberController.text = widget.currentUser.phoneNumber!;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red), // Color del borde
                                padding: const EdgeInsets.symmetric(vertical: 15.0), // Padding opcional
                              ),
                              child: const Text(TTexts.cancel),
                            ),
                          ),
                          const SizedBox(width: TSizes.spaceBtwItems),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _hasChanges && !_isLoading ? _handleEditProfile : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _hasChanges ? Colors.blue : Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 15.0),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                                  : const Text(TTexts.submit),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                )
                    : Column(
                  children: [
                    _buildReadOnlyField(TTexts.firstName, widget.currentUser.fullName, Iconsax.user),
                    _buildReadOnlyField(TTexts.username, widget.currentUser.username, Iconsax.user_edit),
                    _buildReadOnlyField(TTexts.email, widget.currentUser.email, Iconsax.direct),
                    _buildReadOnlyField(TTexts.phoneNumber, widget.currentUser.phoneNumber ?? 'null', Iconsax.call),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}