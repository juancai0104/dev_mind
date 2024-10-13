import 'package:dev_mind/common/widgets/list_tiles/settings_menu_tile.dart';
import 'package:dev_mind/features/authentication/screens/edit_profile/widgets/edit_profile_appbar.dart';
import 'package:dev_mind/features/personalization/screens/settings/widgets/section_heading.dart';
import 'package:dev_mind/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:dev_mind/features/module/screens/home/widgets/home_appbar.dart';
import 'package:dev_mind/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../authentication/screens/edit_profile/edit_profile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
                    title: TTexts.settingsTitle,
                    showActionButton: false,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TSettingsMenuTile(
                    icon: Iconsax.safe_home,
                    title: TTexts.settingsMyProfileTitle,
                    subTitle: TTexts.settingsMyProfileSubtitle,
                    onTap: (){}
                  ),
                  const SizedBox(height: TSizes.spaceBtwTiles),
                  TSettingsMenuTile(
                      icon: Iconsax.document_favorite,
                      title: TTexts.settingsPreferencesTitle,
                      subTitle: TTexts.settingsPreferencesSubtitle,
                      onTap: (){}
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
