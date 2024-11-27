import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/onboarding/onboarding_controller.dart';


class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({super.key});
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      right: screenWidth * 0.05,
      bottom: TDeviceUtils.getBottomNavigationBarHeight() + screenHeight * 0.02,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: ElevatedButton(
          onPressed: () => OnBoardingController.instance.nextPage(),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: dark ? TColors.primary : TColors.secondary,
            side: BorderSide(color: dark ? TColors.primary : TColors.accent, width: 1.5),
            padding: EdgeInsets.all(screenWidth * 0.012),
            elevation: 2,
          ),
          child: Icon(
            Iconsax.arrow_right_14,
            size: screenWidth * 0.06,
          ),
        ),
      ),
    );
  }
}