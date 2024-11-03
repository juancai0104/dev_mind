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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [

          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            physics: const BouncingScrollPhysics(),
            children: const [
              OnBoardingPage(
                image: TImages.devMindHorizontal,
                title: TTexts.onBoardingH1Title,
                subtitle: TTexts.onBoardingH1Subtitle,

              ),
              OnBoardingPage(
                image: TImages.relax,
                title: TTexts.onBoardingH2Title,
                subtitle: TTexts.onBoardingH2Subtitle,

              ),
              OnBoardingPage(
                image: TImages.holdingPhone,
                title: TTexts.onBoardingH3Title,
                subtitle: TTexts.onBoardingH3subtitle,

              )
            ],
          ),


          const OnBoardingSkip(),


          const OnBoardingDotNavigation(),


          const OnBoardingNextButton()
        ],
      ),
    );
  }
}