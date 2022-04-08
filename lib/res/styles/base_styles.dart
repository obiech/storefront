import 'package:flutter/material.dart';

abstract class BaseStyles {
  TextStyle get button;

  TextStyle get title;

  TextStyle get subtitle;

  /// Default text style
  TextStyle get caption1;

  TextStyle get caption2;

  TextStyle get caption3;

  TextStyle get textFieldContent;

  TextStyle get textFieldHint;

  TextStyle get textOtp;

  TextStyle get clickableText;

  BorderRadius get topBorderRadius;
  BoxDecoration get bottomSheetStyle;
  InputDecoration get roundedInputStyle;
}
