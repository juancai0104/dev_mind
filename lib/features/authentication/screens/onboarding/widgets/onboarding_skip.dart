import 'package:dev_mind/features/authentication/screens/login/login.dart';
import 'package:dev_mind/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../controllers/onboarding/onboarding_controller.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      top: TDeviceUtils.getAppBarHeight() + screenHeight * 0.03,
      right: screenWidth * 0.05,
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 300),
        child: TextButton(
          onPressed: () => Get.to(() => LoginScreen()),
          style: TextButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
          ),
          child: Text(
            'Omitir',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: TColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: screenWidth * 0.045,
            ),
          ),
        ),
      ),
    );
  }
}