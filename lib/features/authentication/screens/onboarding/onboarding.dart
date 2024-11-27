import 'package:dev_mind/features/authentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:dev_mind/features/authentication/screens/onboarding/widgets/onboarding_next_button.dart';
import 'package:dev_mind/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:dev_mind/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../features/authentication/screens/login/login.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../controllers/onboarding/onboarding_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  void _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);

    Get.offAll(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
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
              ),
            ],
          ),

          const OnBoardingSkip(),

          const OnBoardingDotNavigation(),
          Obx(
                () => controller.currentPageIndex.value == 2
                ? const OnBoardingNextButton()
                : const OnBoardingNextButton(),
          ),
        ],
      ),
    );
  }
}