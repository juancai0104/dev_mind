import 'package:dev_mind/common/widgets/appbar/appbar.dart';
import 'package:dev_mind/common/widgets/modules/module_cards/module_card_java.dart';
import 'package:dev_mind/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';

class ModuleTheoryScreen extends StatelessWidget {
  final int languageId;

  const ModuleTheoryScreen({super.key, required this.languageId});

  @override
  Widget build(BuildContext context) {
    // Datos estáticos para los lenguajes
    final Map<int, String> staticContent = {
      1: "Python es un lenguaje de programación interpretado, interactivo y orientado a objetos. Es muy popular por su facilidad de aprendizaje y versatilidad.",
      2: "JavaScript es el lenguaje de programación de la web. Es ampliamente utilizado para desarrollar páginas web interactivas y aplicaciones web."
    };

    final Map<int, String> staticImages = {
      1: "assets/logos/languages/python.png", // Ruta de ejemplo para Python
      2: "assets/logos/languages/javascript.png", // Ruta de ejemplo para JavaScript
    };

    final String content = staticContent[languageId] ?? "No hay teoría disponible para este lenguaje.";
    final String imagePath = staticImages[languageId] ?? "assets/images/default.png";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teoría'),
        backgroundColor: TColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueGrey[50], // Fondo de color claro
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    imagePath, // Imagen desde assets
                    height: 200, // Altura de la imagen
                    width: double.infinity,
                    fit: BoxFit.cover, // Ajustar la imagen
                  )
                ]
              ),

            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
                content
            ),
          ],
        ),
      )
    );
  }
}