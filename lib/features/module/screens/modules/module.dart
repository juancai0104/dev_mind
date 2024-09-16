import 'package:dev_mind/common/widgets/modules/module_cards/module_card_vertical.dart';
import 'package:dev_mind/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ModuleScreen extends StatelessWidget {
  const ModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              TModuleCardVertical()
            ],
          ),
        ),
      ),
    );
  }
}