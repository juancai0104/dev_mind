import 'package:dev_mind/utils/local_storage/storage_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dev_mind/utils/theme/theme.dart';
import 'features/authentication/screens/onboarding/onboarding.dart';
import 'features/authentication/screens/login/login.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isFirstTime = true;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFirstTime = prefs.getBool('isFirstTime') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localStorage = TLocalStorage();
    final isDarkMode = localStorage.readData<bool>('isDarkMode') ?? Get.isPlatformDarkMode;

    return GetMaterialApp(
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: _isFirstTime ? const OnBoardingScreen() : const LoginScreen(),
    );
  }
}