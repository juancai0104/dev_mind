import 'package:dev_mind/common/widgets/appbar/appbar.dart';
import 'package:dev_mind/common/widgets/modules/module_cards/module_card_java.dart';
import 'package:dev_mind/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';

class ModuleTheoryScreen extends StatelessWidget {
  final int languageId;

  const ModuleTheoryScreen({super.key, required this.languageId});

  @override
  Widget build(BuildContext context) {
    final Map<int, String> staticContent = {
      1: "Python es un lenguaje de programación interpretado, interactivo y orientado a objetos. Es muy popular por su facilidad de aprendizaje y versatilidad. En esta sección aprenderás sobre su sintaxis básica, estructuras de datos como listas y diccionarios, y funciones. En los ejercicios siguientes pondrás en práctica estos conceptos para resolver problemas reales.",
      2: "JavaScript es el lenguaje de programación de la web. Es utilizado para desarrollar páginas web interactivas y aplicaciones. En esta sección explorarás cómo funcionan las variables, funciones y eventos en JavaScript. Los ejercicios siguientes te permitirán interactuar con el DOM y manipular elementos de una página web.",
    };

    final Map<int, String> staticImages = {
      1: "assets/logos/languages/python.png",
      2: "assets/logos/languages/java.png",
    };

    final String content = staticContent[languageId] ?? "No hay teoría disponible para este lenguaje.";
    final String imagePath = staticImages[languageId] ?? "assets/images/default.png";

    return Scaffold(
      appBar: AppBar(title: const Text('Teoría')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container con fondo de color
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueGrey[50], // Fondo de color claro
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen antes del contenido
                  Image.asset(
                    imagePath, // Imagen desde assets
                    height: 200, // Altura de la imagen
                    width: double.infinity,
                    fit: BoxFit.contain, // Ajustar la imagen
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  // Texto de la teoría
                  Text(
                    content,
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
                    onPressed: (){},
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
                      onPressed: (){},
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
                      onPressed: (){},
                      child: const Text(TTexts.advanced)
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}