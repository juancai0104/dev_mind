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
import '../../../authentication/screens/edit_profile/edit_profile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TLocalStorage _localStorage = TLocalStorage();
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    isDarkMode = _localStorage.readData<bool>('isDarkMode') ?? Get.isPlatformDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            const THomeAppBar(),
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
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
                    onTap: () => Get.to(() => const EditProfile())
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
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
                        onChanged: (value){
                          setState(() {
                            isDarkMode = value;
                          });
                          _changeTheme(value);
                        }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _changeTheme(bool isDark) {
    _localStorage.saveData('isDarkMode', isDark);
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
