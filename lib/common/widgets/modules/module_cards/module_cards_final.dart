import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../features/module/controllers/module/progress_controller.dart';
import '../../../../features/module/screens/modules/module_theory.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../custom_shapes/containers/rounded_container.dart';
import '../../custom_shapes/containers/rounded_images.dart';

class ModuleCard extends StatelessWidget {
  final int languageId;
  final int userId;

  const ModuleCard({
    super.key,
    required this.languageId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final textStyle = TextStyle(
      color: dark ? Colors.white : Colors.black87,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );

    // Crea un controlador único para esta tarjeta, basado en languageId y userId.
    final ProgressController progressController = Get.put(
      ProgressController(userId: userId, moduleId: languageId),
      tag: 'progress_${userId}_$languageId', // Usando un tag único para cada controlador
    );

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

    final moduleColor = colors[languageId] ?? TColors.buttonPrimary;

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
                          color: moduleColor.withOpacity(0.8),
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
              child: Column(
                children: [
                  // Progress Bar
                  Obx(() {
                    if (progressController.isLoading.value) {
                      return const SizedBox(
                        height: 4,
                        child: LinearProgressIndicator(),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progressController.progress.value.progressPercentage / 100,
                            backgroundColor: moduleColor.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(moduleColor),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${progressController.progress.value.progressPercentage.toStringAsFixed(1)}%',
                              style: textStyle.copyWith(
                                color: moduleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              progressController.progress.value.progressPercentage == 100
                                  ? Icons.code_sharp
                                  : Icons.code_off_sharp,
                              color: moduleColor,
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
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
