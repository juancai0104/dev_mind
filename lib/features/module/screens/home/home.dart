import 'package:flutter/material.dart';

import 'package:dev_mind/features/module/screens/home/widgets/home_appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';

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
                            THomeAppBar()
                          ]
                      )
                  )
                ]
            )
        )
    );
  }
}