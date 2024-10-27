import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class TDialogTheme {
  TDialogTheme._();

  static final DialogTheme lightDialogTheme = DialogTheme(
    backgroundColor: TColors.secondary,
    titleTextStyle: const TextStyle(
      color: TColors.primary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    contentTextStyle: const TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  static final DialogTheme darkDialogTheme = DialogTheme(
    backgroundColor: TColors.primary,
    titleTextStyle: const TextStyle(
      color: TColors.secondary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    contentTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );
}