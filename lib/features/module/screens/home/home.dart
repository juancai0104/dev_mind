import 'package:flutter/material.dart';
import 'package:dev_mind/features/module/screens/home/widgets/home_appbar.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/modules/module_cards/module_cards_final.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../authentication/controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authController = Get.find<AuthController>();

    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.4,
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
            child: Obx(() {
              final userId = authController.currentUser.value?.id;
              if (userId == null) {
                return const Center(
                  child: Text(
                    'Por favor inicia sesión para ver los módulos',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }
              return GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: (160 / 249),
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ModuleCard(languageId: 1, userId: userId),
                  ModuleCard(languageId: 2, userId: userId),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}