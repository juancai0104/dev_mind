import 'package:dev_mind/common/widgets/list_tiles/settings_menu_tile.dart';
import 'package:dev_mind/features/personalization/screens/settings/widgets/section_heading.dart';
import 'package:dev_mind/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:dev_mind/features/module/screens/home/widgets/home_appbar.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/local_storage/storage_utility.dart';
import '../../../../utils/notification_service.dart';
import '../../../authentication/screens/edit_profile/edit_profile.dart';
import '../../../authentication/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  final TLocalStorage _localStorage = TLocalStorage();
  bool isDarkMode = false;
  final authController = Get.find<AuthController>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool areNotificationsEnabled = true;
  TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);

  @override
  void initState() {
    super.initState();
    isDarkMode = _localStorage.readData<bool>('isDarkMode') ?? Get.isPlatformDarkMode;
    areNotificationsEnabled = _localStorage.readData<bool>('areNotificationsEnabled') ?? true;
    final savedTime = _localStorage.readData<String>('selectedTime');
    if (savedTime != null) {
      final parts = savedTime.split(':');
      selectedTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;
    final photoUrl = user?.photoURL;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: THomeAppBar(),
          ),
          Positioned(
            top: 180,
            left: MediaQuery.of(context).size.width * 0.44,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null
                      ? const Icon(Icons.person, size: 25, color: Colors.grey)
                      : null,
                ),
              ),
            ),
          ),
          Positioned(
            top: 270,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TSectionHeading(
                  title: TTexts.accountSettingsTitle,
                  showActionButton: false,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                TSettingsMenuTile(
                  icon: Iconsax.safe_home,
                  title: TTexts.settingsMyProfileTitle,
                  subTitle: TTexts.settingsMyProfileSubtitle,
                  onTap: () => Get.to(() => const EditProfile()),
                ),
              ],
            ),
          ),
          Positioned(
            top: 420,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TSectionHeading(
                  title: TTexts.appSettingsTitle,
                  showActionButton: false,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                TSettingsMenuTile(
                  icon: Iconsax.document_favorite,
                  title: TTexts.settingsPreferencesTitle,
                  subTitle: TTexts.settingsPreferencesSubtitle,
                  trailing: Switch(
                    value: isDarkMode,
                    activeColor: TColors.primary,
                    inactiveThumbColor: TColors.accent,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value;
                      });
                      _changeTheme(value);
                    },
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                TSettingsMenuTile(
                  icon: Iconsax.notification,
                  title: 'Notificaciones diarias',
                  subTitle: areNotificationsEnabled
                      ? 'Activadas a las ${selectedTime.format(context)}'
                      : 'Desactivadas',
                  trailing: Switch(
                    value: areNotificationsEnabled,
                    activeColor: TColors.primary,
                    inactiveThumbColor: TColors.accent,
                    onChanged: _toggleNotifications,
                  ),
                ),
                if (areNotificationsEnabled)
                  ListTile(
                    title: const Text('Hora de la notificación'),
                    subtitle: Text(
                      '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                    ),
                    trailing: const Icon(Icons.edit),
                    onTap: () => _selectTime(context),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width * 0.25,
            child: ElevatedButton.icon(
              icon: const Icon(Iconsax.logout, size: 28),
              label: const Text(
                TTexts.logout,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.error,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              onPressed: () {
                authController.signOutFromGoogle();
                authController.checkAuthStatus();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _changeTheme(bool isDark) {
    _localStorage.saveData('isDarkMode', isDark);
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });

      if (areNotificationsEnabled) {
        await NotificationService.scheduleNotification(
          1,
          'Recordatorio diario',
          '¡Es hora de revisar tu progreso!',
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            selectedTime.hour,
            selectedTime.minute,
          ),
        );
      }
    }
    await _savePreferences();
  }

  Future<void> _toggleNotifications(bool isEnabled) async {
    setState(() {
      areNotificationsEnabled = isEnabled;
    });

    if (isEnabled) {
      await NotificationService.scheduleNotification(
        1,
        'Recordatorio diario',
        '¡Es hora de revisar tu progreso!',
        DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          selectedTime.hour,
          selectedTime.minute,
        ),
      );
    } else {
      await NotificationService.cancelNotifications();
    }
    await _savePreferences();
  }

  Future<void> _savePreferences() async {
    _localStorage.saveData('areNotificationsEnabled', areNotificationsEnabled);
    _localStorage.saveData('selectedTime', '${selectedTime.hour}:${selectedTime.minute}');
  }
}