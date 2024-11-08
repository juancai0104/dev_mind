import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:dev_mind/features/authentication/screens/password_configuration/reset_password.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/auth_controller.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final emailController = TextEditingController();
  final authController = Get.find<AuthController>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
            TSizes.defaultSpace,
            0,
            TSizes.defaultSpace,
            TSizes.defaultSpace
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headings
            const TForgetPasswordHeader(),
            const SizedBox(height: TSizes.spaceBtwSections),
            Text(TTexts.forgetPasswordSubtitle, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Text field
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                  labelText: TTexts.email,
                  prefixIcon: Icon(Iconsax.direct_right)
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Submit button
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      final email = emailController.text.trim();
                      if(email.isNotEmpty) {
                        authController.resetPassword(email);
                      } else {
                        Get.snackbar("Error", "Por favor ingresa tu correo electrónico.");
                      }
                    },
                    child: const Text(TTexts.sendToken)
                )
            )
          ],
        ),
      ),
    );
  }
}

class TForgetPasswordHeader extends StatelessWidget {
  const TForgetPasswordHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -THelperFunctions.screenHeight() * 0.04,
          right: -THelperFunctions.screenWidth() * 0.1,
          child: Container(
            width: THelperFunctions.screenWidth() * 1.1,
            height: THelperFunctions.screenHeight() * 0.2,
            padding: const EdgeInsets.all(0),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100)),
                color: TColors.primary
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(TTexts.forgetPasswordTitle, style: TextStyle(color: TColors.white, fontSize: 24, fontWeight: FontWeight.w600)),
            Image(
              height: 100,
              image: AssetImage(dark ? TImages.nameAppLogo : TImages.nameAppLogo),
            ),
          ],
        ),

      ],
    );
  }
}