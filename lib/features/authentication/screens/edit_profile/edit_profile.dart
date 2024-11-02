import 'package:dev_mind/features/authentication/controllers/auth_controller.dart';
import 'package:dev_mind/features/authentication/screens/edit_profile/widgets/change_user_pass_form.dart';
import 'package:dev_mind/features/authentication/screens/edit_profile/widgets/edit_profile_appbar.dart';
import 'package:dev_mind/features/authentication/screens/edit_profile/widgets/edit_profile_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final size = MediaQuery.of(context).size;

    // Define el color personalizado
    final Color customIconAndTextColor = TColors.primary;
    final Color customUnderlineColor = Colors.blueAccent;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 350,
                child: TEditProfileAppBar(),
              ),
            ),
            Positioned(
              top: 240,
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                children: [
                  TabBar(
                    labelColor: customIconAndTextColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: customUnderlineColor,
                    tabs: [
                      Tab(
                        text: 'Perfil',
                        icon: Icon(Icons.person, color: customIconAndTextColor),
                      ),
                      Tab(
                        text: 'Contraseña',
                        icon: Icon(Icons.lock, color: customIconAndTextColor),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TabBarView(
                        children: [
                          Obx(() => EditProfileForm(currentUser: authController.currentUser.value!)),
                          ChangePasswordScreen(),
                        ],
                      ),
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
