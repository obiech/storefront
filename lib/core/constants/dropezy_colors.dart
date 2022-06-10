import 'package:flutter/material.dart';

/// Contains color palette used by the app
/// Light variants and grey are typically used for backgroundss
class DropezyColors {
  static const black = Color(0xFF12142A);
  static const white = Colors.white;

  /// From lightest to darkest
  static const grey1 = Color(0xFFF1F4F8);
  static const grey2 = Color(0xFFC4C4C4);
  static const grey3 = Color(0xFF9496AD);
  static const grey5 = Color(0xFF787C8F);

  /// Used for [TextField] [BoxDecoration] [Border] color
  static const textFieldBorderGrey = Color(0xFFDBDFE3);

  static const green = Color(0xFF00A34B);
  static const red = Color(0xFFFC3B5D);
  static const yellow = Color(0xFFFFF3E8);
  static const orange = Color(0xFFFF6712);
  static const lightOrange = Color(0xFFFFF5EC);

  /// [blue] is the primary color (text, buttons)
  /// [altBlue] is alternate
  /// [lightBlue] and [darkBlue] are used for backgrounds
  static const blue = Color(0xFF1574FF);
  static const altBlue = Color(0xFF5F97F6);
  static const lightBlue = Color(0xFFE8F1FF);
  static const darkBlue = Color(0xFF0D4699);

  /// Divider color
  static const dividerColor = Color(0xFFE6EDF5);
}
