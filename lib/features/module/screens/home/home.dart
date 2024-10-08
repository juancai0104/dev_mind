import 'package:flutter/material.dart';
import 'package:dev_mind/features/module/screens/home/widgets/home_appbar.dart';
import '../../../../common/widgets/modules/module_cards/module_card_python.dart';
import '../../../../common/widgets/modules/module_cards/module_card_java.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            const THomeAppBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: (160 / 250),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                TModuleCardJava(),
                TModuleCardPython(),
              ],
            ),
          ),
        )
          ],
        ),
    );
  }
}