import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../custom_shapes/containers/rounded_container.dart';
import '../../custom_shapes/containers/rounded_images.dart';

class TModuleCardPython extends StatelessWidget {
  const TModuleCardPython({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final textStyle = TextStyle(
      color: dark ? Colors.white : Colors.black87,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );

    return GestureDetector(
      onTap: () {
        // Implement navigation or any other interaction
      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: dark ? Colors.grey.shade900 : Colors.grey.shade500,
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
          borderRadius: BorderRadius.circular(TSizes.moduleImageRadius),
          gradient: LinearGradient(
            colors: dark
                ? [Colors.grey.shade800, Colors.black]
                : [Colors.white, Colors.grey.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TRoundedContainer(
                height: 180,
                padding: const EdgeInsets.all(TSizes.sm),
                backgroundColor: dark ? Colors.black : Colors.white,
                child: Stack(
                  children: [
                    const TRoundedImage(
                      imageUrl: TImages.python,
                      applyImageRadius: true,
                    ),
                    Positioned(
                      bottom: -1,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(TSizes.sm),
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent.withOpacity(0.8),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(TSizes.moduleImageRadius),
                            bottomRight: Radius.circular(TSizes.moduleImageRadius),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Python',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'From zero to pro',
                              style: textStyle.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '60 minutos',
                    style: textStyle,
                  ),
                  Icon(
                    Icons.code,
                    color: Colors.deepPurpleAccent,
                    size: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
