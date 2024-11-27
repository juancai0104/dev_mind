import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.alignment = Alignment.center,
  });

  final String image, title, subtitle;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 700),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Image(
              width: screenWidth * 0.8,
              height: screenHeight * 0.5,
              image: AssetImage(image),
              alignment: alignment,
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 500),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                fontSize: screenWidth * 0.06,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 500),
            child: Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
                letterSpacing: 0.5,
                fontSize: screenWidth * 0.045,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
