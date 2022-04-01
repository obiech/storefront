import 'package:flutter/material.dart';

import '../colors/base_colors.dart';
import 'base_styles.dart';

class AppStyles implements BaseStyles {
  AppStyles(this._colors);

  final BaseColors _colors;

  @override
  TextStyle get button => TextStyle(
        color: _colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      );

  @override
  TextStyle get caption1 => TextStyle(
        color: _colors.black,
        fontSize: 14,
      );

  @override
  TextStyle get caption2 => TextStyle(
        color: _colors.black,
        fontSize: 12,
      );

  @override
  TextStyle get caption3 => TextStyle(
        color: _colors.black,
        fontSize: 10,
      );

  @override
  TextStyle get clickableText => TextStyle(
        color: _colors.blue,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );

  @override
  TextStyle get subtitle => TextStyle(
        color: _colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  @override
  TextStyle get textFieldContent => TextStyle(
        color: _colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  @override
  TextStyle get textFieldHint => TextStyle(
        color: _colors.grey3,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  @override
  TextStyle get textOtp => TextStyle(
        color: _colors.black,
        fontSize: 22,
        fontWeight: FontWeight.w400,
      );

  @override
  TextStyle get title => TextStyle(
        color: _colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  @override
  BoxDecoration get bottomSheetStyle => BoxDecoration(
        color: _colors.white,
        boxShadow: [
          BoxShadow(
            color: _colors.black.withOpacity(.1),
            blurRadius: 16,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      );
}
