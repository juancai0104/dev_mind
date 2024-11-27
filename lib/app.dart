import 'package:dev_mind/utils/local_storage/storage_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:dev_mind/utils/theme/theme.dart';
import 'features/authentication/screens/onboarding/onboarding.dart';
import 'features/authentication/screens/login/login.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final localStorage = TLocalStorage();

    final isFirstTime = localStorage.readData<bool>('isFirstTime') ?? true;
    final isDarkMode = localStorage.readData<bool>('isDarkMode') ?? Get.isPlatformDarkMode;

    return GetMaterialApp(
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: isFirstTime ? const OnboardingScreen() : const LoginScreen(),
    );
  }
}