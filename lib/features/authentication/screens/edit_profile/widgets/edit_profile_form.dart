import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/auth_controller.dart';
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

  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.currentUser.fullName);
    usernameController = TextEditingController(text: widget.currentUser.username);
    emailController = TextEditingController(text: widget.currentUser.email);
    phoneNumberController = TextEditingController(text: widget.currentUser.phoneNumber);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _handleEditProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final updatedUser = User(
        id: widget.currentUser.id,
        fullName: fullNameController.text.trim(),
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
      );

      try {
        await authController.updateUserProfile(updatedUser);
        Get.snackbar('Éxito', 'Perfil actualizado correctamente',
            snackPosition: SnackPosition.TOP, backgroundColor: TColors.success.withOpacity(0.1));
        setState(() => _isEditing = false);
      } catch (e) {
        Get.snackbar('Error', 'No se pudo actualizar el perfil',
            snackPosition: SnackPosition.TOP, backgroundColor: TColors.error.withOpacity(0.1));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildReadOnlyField(String label, String value, IconData icon) {
    final dark = THelperFunctions.isDarkMode(context);
    return ListTile(
      leading: Icon(icon, color: TColors.primary),
      title: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold, color: dark ? Colors.white : Colors.black87),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 14),
      ),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildEditableField(TextEditingController controller, String label, String? Function(String?) validator, IconData icon, {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: TColors.primary),
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
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Actualiza tu información de perfil fácilmente.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: TColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Botón Editar
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(_isEditing ? Iconsax.close_circle : Iconsax.edit),
                  color: TColors.primary,
                  onPressed: () => setState(() => _isEditing = !_isEditing),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Formulario
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: _isEditing
                    ? Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildEditableField(
                        fullNameController,
                        TTexts.firstName,
                            (value) => value == null || value.isEmpty ? 'Nombre requerido' : null,
                        Iconsax.user,
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      _buildEditableField(
                        usernameController,
                        TTexts.username,
                            (value) => value == null || value.isEmpty ? 'Usuario requerido' : null,
                        Iconsax.user_edit,
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      _buildEditableField(
                        emailController,
                        TTexts.email,
                            (value) => value == null || !GetUtils.isEmail(value) ? 'Email inválido' : null,
                        Iconsax.direct,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      _buildEditableField(
                        phoneNumberController,
                        TTexts.phoneNumber,
                            (value) => value == null || !GetUtils.isPhoneNumber(value) ? 'Teléfono inválido' : null,
                        Iconsax.call,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleEditProfile,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(TColors.buttonPrimary))
                              : const Text(TTexts.submit),
                        ),
                      ),
                    ],
                  ),
                )
                    : Column(
                  children: [
                    _buildReadOnlyField(TTexts.firstName, widget.currentUser.fullName, Iconsax.user),
                    _buildReadOnlyField(TTexts.username, widget.currentUser.username, Iconsax.user_edit),
                    _buildReadOnlyField(TTexts.email, widget.currentUser.email, Iconsax.direct),
                    _buildReadOnlyField(TTexts.phoneNumber, widget.currentUser.phoneNumber, Iconsax.call),
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
