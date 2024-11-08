import 'package:dev_mind/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/auth_controller.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final tokenController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final authController = Get.find<AuthController>();

  @override
  void dispose() {
    tokenController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () => Get.back(), icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              // Image
              Image(image: const AssetImage(TImages.google), width: THelperFunctions.screenWidth() * 0.6),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Title and subtitle
              Text(TTexts.changeYourPasswordTitle, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(TTexts.changeYourPasswordSubtitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwSections),

              TextFormField(
                controller: tokenController,
                decoration: const InputDecoration(labelText: "Código de restablecimiento"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Nueva contraseña"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Confirmar contraseña"),
              ),
              const SizedBox(height: 24),

              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: (){
                      final token = tokenController.text.trim();
                      final newPassword = newPasswordController.text.trim();
                      final confirmPassword = confirmPasswordController.text.trim();

                      if (newPassword == confirmPassword) {
                        authController.confirmResetPassword(token, newPassword);
                      } else {
                        Get.snackbar("Error", "Las contraseñas no coinciden.");
                      }
                    },
                    child: const Text(TTexts.done)
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: (){},
                    child: const Text(
                        TTexts.resendEmail,
                        style: TextStyle(color: TColors.accent)
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}