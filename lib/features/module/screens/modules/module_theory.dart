import 'package:dev_mind/common/widgets/appbar/appbar.dart';
import 'package:dev_mind/features/module/screens/modules/widgets/code_editor.dart';
import 'package:dev_mind/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/module/module_controller.dart';

class ModuleTheoryScreen extends StatelessWidget {
  final int languageId;
  final ModuleController controller = Get.put(ModuleController());

  ModuleTheoryScreen({super.key, required this.languageId});

  @override
  Widget build(BuildContext context) {
    controller.getByModuleId(languageId);
    final dark = THelperFunctions.isDarkMode(context);

    final Map<int, String> staticImages = {
      1: "assets/logos/languages/python.png",
      2: "assets/logos/languages/java.png",
    };

    final String imagePath = staticImages[languageId] ?? "assets/images/default.png";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teoría'),
        iconTheme: IconThemeData(
          color: dark ? TColors.grey : TColors.black,
        ),
      ),
      body: Obx(() {
        if(controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if(controller.moduleList.isEmpty) {
          return const Center(child: Text('No hay teoría disponible.'));
        }

        final module = controller.moduleList.first;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/logos/languages/${module.moduleId == 1 ? "python.png" : "java.png"}",
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Text(
                      module.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.beginner,
                        side: const BorderSide(color: TColors.beginner),
                      ),
                      onPressed: () => Get.to(() => CodeEditor(
                        moduleId: module.moduleId,
                        difficultyId: 1,
                      )),
                      child: const Text(TTexts.beginner)
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.intermediate,
                          side: const BorderSide(color: TColors.intermediate),
                        ),
                        onPressed: () => Get.to(() => CodeEditor(
                          moduleId: module.moduleId,
                          difficultyId: 2,
                        )),
                        child: const Text(TTexts.intermediate)
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.advanced,
                          side: const BorderSide(color: TColors.advanced),
                        ),
                        onPressed: () => Get.to(() => CodeEditor(
                          moduleId: module.moduleId,
                          difficultyId: 3,
                        )),
                        child: const Text(TTexts.advanced)
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      })
    );
  }
}