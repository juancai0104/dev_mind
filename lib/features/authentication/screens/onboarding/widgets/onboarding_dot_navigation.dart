import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/onboarding/onboarding_controller.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Positioned(
      bottom: TDeviceUtils.getBottomNavigationBarHeight() + 2,
      left: screenWidth * 0.05,
      right: screenWidth * 0.05,
      child: SmoothPageIndicator(
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        count: 3,
        effect: ExpandingDotsEffect(
          activeDotColor: dark ? TColors.primary : TColors.secondary,
          dotHeight: screenWidth * 0.025,
          dotWidth: screenWidth * 0.05,
          spacing: screenWidth * 0.015,
          expansionFactor: 3,
          dotColor: dark ? TColors.light.withOpacity(0.2) : TColors.dark.withOpacity(0.2),
        ),
      ),
    );
  }
}