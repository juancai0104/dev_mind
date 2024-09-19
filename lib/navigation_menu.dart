import 'package:dev_mind/features/authentication/screens/login/login.dart';
import 'package:dev_mind/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'features/authentication/screens/password_configuration/forget_password.dart';
import 'features/authentication/screens/password_configuration/forget_password.dart';
import 'features/authentication/screens/password_configuration/reset_password.dart';
import 'features/authentication/screens/signup/signup.dart';
import 'features/module/screens/home/home.dart';
import 'features/module/screens/modules/module_theory.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
        bottomNavigationBar: Obx(
              () => NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) => controller.selectedIndex.value = index,
            backgroundColor: darkMode ? Colors.black : Colors.white,
            indicatorColor: darkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
            destinations: const [
              NavigationDestination(icon: Icon(Iconsax.home), label: 'Inicio'),
              NavigationDestination(icon: Icon(Iconsax.shop), label: 'Tienda'),
              NavigationDestination(icon: Icon(Iconsax.heart), label: 'Lista de deseos'),
              NavigationDestination(icon: Icon(Iconsax.user), label: 'Perfil'),
            ],
          ),
        ),
        body: Obx(() => controller.screens[controller.selectedIndex.value])
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    //ForgotPasswordScreen(),//Container(color: Colors.purple),
    //ChangePasswordScreen(),//Container(color: Colors.orange),
    const ForgetPassword(),//Container(color: Colors.blue)
    const ModuleTheoryScreen(languageId: 1),
    const ModuleTheoryScreen(languageId: 2)
  ];
}