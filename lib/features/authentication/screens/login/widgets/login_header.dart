import 'package:dev_mind/utils/device/device_utility.dart';
import 'package:flutter/material.dart';

import '../../../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -screenHeight * 0.08,
          right: -screenWidth * 0.4,
          child: Container(
            width: screenWidth * 1.4,
            height: screenHeight * 0.3,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(400)),
              color: TColors.secondary,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image(
                height: screenHeight * 0.1,
                image: AssetImage(dark ? TImages.lightAppLogo : TImages.darkAppLogo),
              ),
              Text(
                TTexts.loginTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.end,
              ),
              const SizedBox(height: TSizes.sm),
              Text(
                TTexts.loginSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
