import 'package:dev_mind/utils/constants/colors.dart';
import 'package:dev_mind/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';

class TRoundedContainer extends StatelessWidget
{
  const TRoundedContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.showborder = false,
    this.backgroundColor = TColors.white,
    this.borderColor = TColors.borderPrimary,
    this.radius = TSizes.cardRadiusLg,
});

  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showborder;
  final Color backgroundColor;
  final Color borderColor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: showborder ? Border.all(color: borderColor) : null,
      ),
      child: child,
    );
  }
  
}