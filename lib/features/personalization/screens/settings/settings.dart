import 'package:dev_mind/features/authentication/screens/edit_profile/widgets/edit_profile_appbar.dart';
import 'package:dev_mind/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:dev_mind/features/module/screens/home/widgets/home_appbar.dart';
import 'package:dev_mind/utils/constants/colors.dart';
import 'package:get/get.dart';

import '../../../authentication/screens/edit_profile/edit_profile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    // Determina si el modo actual es oscuro
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            const THomeAppBar(),
            const SizedBox(height: 20),

            // Label sin animación
            Text(
              'Configuración de la cuenta',
              style: TextStyle(
                fontSize: 26,
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Botón Editar perfil
            GestureDetector(
              onTap: () {
                Get.to(() => const EditProfile());
              },
              child: MouseRegion(
                onEnter: (_) => setState(() => hovering = true),
                onExit: (_) => setState(() => hovering = false),
                child: Container(
                  width: 400,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: hovering ? Colors.blueAccent : TColors.accent,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: hovering
                        ? [BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)]
                        : [],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.edit, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Editar perfil',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Información sobre el modo actual sin animaciones
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [Colors.black, Colors.grey[850]!]
                      : [Colors.orangeAccent, Colors.yellowAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ícono sin animación
                  Icon(
                    isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isDarkMode ? 'Modo Oscuro Activado' : 'Modo Claro Activado',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
