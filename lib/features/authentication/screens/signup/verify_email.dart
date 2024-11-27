import 'package:dev_mind/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/success_screen/success_screen.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../login/login.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () => Get.offAll(() => const LoginScreen()), icon: const Icon(CupertinoIcons.clear))
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
              Text(TTexts.confirmEmail, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text('correo@gmail.com', style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(TTexts.confirmEmailSubtitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => Get.to(
                            () => SuccessScreen(
                          imagePath: TImages.google,
                          title: TTexts.yourAccountCreatedTitle,
                          subtitle: TTexts.yourAccountCreatedSubtitle,
                          onPressed: () => Get.to(() => const LoginScreen()),
                        )
                    ),
                    child: const Text(TTexts.tContinue)
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: (){},
                    child: const Text(TTexts.resendEmail, style: TextStyle(color: TColors.accent))
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}