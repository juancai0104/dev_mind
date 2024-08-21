import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../controllers/onboarding/onboarding_controller.dart';
import 'package:dev_mind/features/authentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:dev_mind/features/authentication/screens/onboarding/widgets/onboarding_next_button.dart';
import 'package:dev_mind/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:dev_mind/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';


class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [
          // Horizontal Scrollable pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: TImages.google,
                title: TTexts.onBoardingTitle1,
                subtitle: TTexts.onBoardingTitle1
              ),
              OnBoardingPage(
                image: TImages.google,
                title: TTexts.onBoardingTitle1,
                subtitle: TTexts.onBoardingTitle1
              ),
              OnBoardingPage(
                image: TImages.google,
                title: TTexts.onBoardingTitle1,
                subtitle: TTexts.onBoardingTitle1
              )
            ],
          ),

          // Skip button
          const OnBoardingSkip(),

          // Dot navigation smoothPageIndicator
          const OnBoardingDotNavigation(),

          // Circular Button
          const OnBoardingNextButton()

        ],
      ),
    );
  }
}