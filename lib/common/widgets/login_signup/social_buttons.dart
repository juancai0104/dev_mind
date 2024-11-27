import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../features/authentication/controllers/auth_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';

class TSocialButtons extends StatelessWidget {
  const TSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: screenWidth * 0.15, // 15% of screen width
          height: screenHeight * 0.08, // 8% of screen height
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(screenWidth * 0.0375), // 3.75% of screen width
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: screenWidth * 0.005, // 0.5% of screen width
                blurRadius: screenWidth * 0.02, // 2% of screen width
                offset: Offset(0, screenHeight * 0.005), // 0.5% of screen height
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: IconButton(
            onPressed: () {
              Get.find<AuthController>().signInWithGoogle();
            },
            icon: Image.asset(
              TImages.google,
              width: screenWidth * 0.075, // 7.5% of screen width
              height: screenWidth * 0.075,
            ),
          ),
        ),
      ],
    );
  }
}