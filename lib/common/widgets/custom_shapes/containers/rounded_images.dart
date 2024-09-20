import 'package:dev_mind/utils/constants/colors.dart';
import 'package:dev_mind/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';

class TRoundedImage extends StatelessWidget
{
  const TRoundedImage({
    super.key,
    this.border,
    this.padding,
    this.onPressed,
    this.width,
    this.height,
    this.applyImageRadius = true,
    required this.imageUrl,
    this.fit = BoxFit.contain,
    this.backgroundColor = TColors.light,
    this.isNetworkImage = false,
    this.borderRadius = TSizes.md,
});

  final double? width, height,borderRadius;
  final String imageUrl;
  final bool isNetworkImage, applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius!),
          border: border,
        ),
        child: ClipRRect(
          borderRadius: applyImageRadius ? BorderRadius.circular(borderRadius!) : BorderRadius.zero,
          child: Image(fit : fit!, image: isNetworkImage ? NetworkImage(imageUrl) : AssetImage(imageUrl) as ImageProvider),
        ),
      ),
    );
  }

}