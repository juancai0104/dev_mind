import 'package:dev_mind/features/authentication/screens/login/login.dart';
import 'package:dev_mind/features/personalization/screens/settings/settings.dart';
import 'package:dev_mind/utils/constants/colors.dart';
import 'package:dev_mind/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

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
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
            () => Container(
          decoration: BoxDecoration(
            color: darkMode ? TColors.primary : TColors.secondary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(70)),
            boxShadow: [
              BoxShadow(
                color: darkMode ? Colors.black.withOpacity(0.5) : Colors.grey.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(10, -2),
              ),
            ],
          ),
          child: NavigationBar(
            height: 70,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) => controller.selectedIndex.value = index,
            backgroundColor: Colors.transparent,
            indicatorColor: darkMode ? Colors.deepPurple.withOpacity(0.1) : Colors.black.withOpacity(0.1),
            destinations: const [
              NavigationDestination(icon: Icon(Iconsax.home), label: 'Inicio'),
              NavigationDestination(icon: Icon(Iconsax.setting), label: 'Ajustes'),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    SettingsScreen(),
  ];
}
