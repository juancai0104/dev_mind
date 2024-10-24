import 'package:dev_mind/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';

// HACER ENLACE PARA EN CASO DE QUE EL COOREO ELECTRONICO INGRESADO ESTE YA REGISTRADO QUE SE DEVUELVA AL LOGIN SCREEN

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              TSizes.defaultSpace,
              0,
              TSizes.defaultSpace,
              TSizes.defaultSpace
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const TSignupHeader(),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Account Form
              TSignupForm(),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Divider
              TFormDivider(dividerText: TTexts.orSignUpWith.capitalize!),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Social Buttons
              const TSocialButtons()
            ],
          ),
        ),
      ),
    );
  }
}

class TSignupHeader extends StatelessWidget {
  const TSignupHeader({
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
            const Text(TTexts.signUpTitle, style: TextStyle(color: TColors.white, fontSize: 24, fontWeight: FontWeight.w600)),
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