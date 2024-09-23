import 'package:dev_mind/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:dev_mind/features/module/screens/home/widgets/home_appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/modules/module_cards/module_card_python.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../common/widgets/modules/module_cards/module_card_java.dart';
import '../../../../utils/constants/sizes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  THomeAppBar(),
                  Opacity(
                    opacity: 0.3,
                    child: Image(
                      height: 350,
                      image: AssetImage(TImages.lightAppLogo),
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