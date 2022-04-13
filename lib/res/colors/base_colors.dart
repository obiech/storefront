import 'package:flutter/material.dart';

/// Contains color palette used by the app
/// Light variants and grey are typically used for backgroundss
abstract class BaseColors {
  Color get black;

  Color get white;

  /// From lightest to darkest
  Color get grey1;

  Color get grey2;

  Color get grey3;

  Color get grey4;

  Color get grey5;

  Color get grey6;

  /// Used for [TextField] [BoxDecoration] [Border] color
  Color get textFieldBorderGrey;

  Color get cartCheckBorderColor;

  /// Pale variants are used for backgrounds e.g. in [OrderStatusChip]

  Color get red;

  Color get yellow;

  Color get paleYellow;

  Color get deepYellow;

  Color get orange;

  Color get lightOrange;

  Color get green;

  Color get paleGreen;
  Color get savingsRibbonGreen;

  Color get dividerColor;

  /// [blue] is the primary Color (text, buttons)
  /// [altBlue] is alternate
  /// [lightBlue] and [darkBlue] are used for backgrounds
  Color get blue;

  Color get altBlue;

  Color get paleBlue;

  Color get lightBlue;

  Color get darkBlue;

  /// Box shadow colors
  Color get boxShadow;
}
