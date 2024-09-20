import 'package:flutter/cupertino.dart';

import '../../utils/constants/colors.dart';

class TShadowStyle
{
  static final verticalModuleShadow  = BoxShadow(
    color: TColors.darkerGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2)
  );
}