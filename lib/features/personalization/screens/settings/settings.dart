import 'package:dev_mind/common/widgets/appbar/appbar.dart';
import 'package:dev_mind/features/module/screens/home/widgets/home_appbar.dart';
import 'package:dev_mind/utils/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// ---- Header
            THomeAppBar()
          ]

        ),
      ),
    );
  }
}