import 'package:dev_mind/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:dev_mind/common/widgets/custom_shapes/containers/rounded_images.dart';
import 'package:dev_mind/utils/constants/image_strings.dart';
import 'package:dev_mind/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../features/module/screens/modules/module_theory.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class ModuleCard extends StatelessWidget {
  final int languageId;

  const ModuleCard({super.key, required this.languageId});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final textStyle = TextStyle(
      color: dark ? Colors.white : Colors.black87,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );

    // Define language-specific properties
    final Map<int, String> languageNames = {
      1: 'Python',
      2: 'JavaScript',
    };

    final Map<int, String> languageSubtitles = {
      1: 'From zero to pro',
      2: 'From zero to hero',
    };

    final Map<int, String> imagePaths = {
      1: TImages.python,
      2: TImages.js,
    };

    final Map<int, Color> colors = {
      1: Colors.deepPurpleAccent,
      2: TColors.buttonPrimary,
    };

    final Map<int, String> durations = {
      1: '60 minutos',
      2: '~ 45 minutos',
    };

    return GestureDetector(
      onTap: () {
        Get.to(() => ModuleTheoryScreen(languageId: languageId));
      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: dark ? Colors.grey.shade900 : Colors.grey.shade500,
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
          borderRadius: BorderRadius.circular(TSizes.moduleImageRadius),
          gradient: LinearGradient(
            colors: dark
                ? [Colors.grey.shade800, Colors.black]
                : [Colors.white, Colors.grey.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TRoundedContainer(
                height: 180,
                padding: const EdgeInsets.all(TSizes.sm),
                backgroundColor: dark ? Colors.black : Colors.white,
                child: Stack(
                  children: [
                    TRoundedImage(
                      imageUrl: imagePaths[languageId] ?? TImages.js,
                      applyImageRadius: true,
                    ),
                    Positioned(
                      bottom: -1,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(TSizes.sm),
                        decoration: BoxDecoration(
                          color: (colors[languageId] ?? TColors.buttonPrimary)
                              .withOpacity(0.8),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(TSizes.moduleImageRadius),
                            bottomRight: Radius.circular(TSizes.moduleImageRadius),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              languageNames[languageId] ?? 'Language',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              languageSubtitles[languageId] ?? '',
                              style: textStyle.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    durations[languageId] ?? 'Duration',
                    style: textStyle,
                  ),
                  Icon(
                    Icons.code,
                    color: colors[languageId] ?? TColors.buttonPrimary,
                    size: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
