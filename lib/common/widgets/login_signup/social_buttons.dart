import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';

class TSocialButtons extends StatelessWidget {
  const TSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Image.asset(
              TImages.google,
              width: TSizes.iconMd,
              height: TSizes.iconMd,
            ),
          ),
        ),
      ],
    );
  }
}
