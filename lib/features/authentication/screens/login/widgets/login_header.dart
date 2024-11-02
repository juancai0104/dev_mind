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

    return Stack(
      clipBehavior: Clip.none,
      children: [
        //const Positioned(top: -550, right: -300, child: TCircularContainer(width: 800, height: 800, backgroundColor: TColors.secondary)),
        //const Positioned(top: -150, right: -150, child: TCircularContainer(backgroundColor: TColors.secondary)),
        Positioned(
          top: -THelperFunctions.screenHeight() * 0.08,
          right: -THelperFunctions.screenWidth() * 0.3,
          child: Container(
            width: THelperFunctions.screenWidth() * 1.4,
            height: THelperFunctions.screenHeight() * 0.38,
            padding: const EdgeInsets.all(0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(400)),
              color: TColors.secondary
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image(
              height: 150,
              image: AssetImage(dark ? TImages.lightAppLogo : TImages.darkAppLogo),
            ),
            Text(TTexts.loginTitle, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.sm),
            Text(TTexts.loginSubtitle, style: Theme.of(context).textTheme.bodyMedium)
          ],
        ),
      ],
    );
  }
}