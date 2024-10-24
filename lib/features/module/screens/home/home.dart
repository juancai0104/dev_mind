import 'package:flutter/material.dart';
import 'package:dev_mind/features/module/screens/home/widgets/home_appbar.dart';
import '../../../../common/widgets/modules/module_cards/module_cards_final.dart';
import '../../../../utils/constants/image_strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo con opacidad
          Opacity(
            opacity: 0.4, // Cambia el valor de la opacidad según prefieras
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(TImages.darkAppLogo),
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Contenido de la pantalla
          const Column(
            children: [
              THomeAppBar(),
            ],
          ),
          Positioned(
            top: size.height * 0.3,
            left: 16,
            right: 16,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: (160 / 249),
              crossAxisSpacing: 10,
              mainAxisSpacing: 20,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                ModuleCard(languageId: 1),
                ModuleCard(languageId: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
