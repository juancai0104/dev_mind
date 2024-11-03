import 'package:dev_mind/utils/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../controllers/onboarding/onboarding_controller.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: TDeviceUtils.getAppBarHeight(),
      right: TSizes.defaultSpace,
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 300),
        child: TextButton(
          onPressed: () => OnBoardingController.instance.skipPage(),
          style: TextButton.styleFrom(
            splashFactory: NoSplash.splashFactory, // Quita el efecto splash
          ),
          child: Text(
            'Omitir',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: TColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}