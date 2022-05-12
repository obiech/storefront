import 'package:flutter/material.dart';
import 'package:storefront_app/res/dimensions/base_dimensions.dart';

import '../../core/utils/text_style.ext.dart';
import '../colors/base_colors.dart';
import 'base_styles.dart';

class AppStyles implements BaseStyles {
  AppStyles(this._colors, this._dimens);

  final BaseColors _colors;
  final BaseDimensions _dimens;

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
  TextStyle get textSmall => TextStyle(
        color: _colors.black,
        fontSize: 9,
      );

  @override
  TextStyle get clickableText => TextStyle(
        color: _colors.blue,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );

  /// [ProductTile] specific
  @override
  TextStyle get productTileProductName => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: _colors.black,
      ).withLineHeight(16);

  @override
  TextStyle get productTileSlashedPrice => const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: Color(0xFF787C8F),
        decoration: TextDecoration.lineThrough,
      ).withLineHeight(13.5);

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
        borderRadius: topBorderRadius,
      );

  @override
  InputDecoration get roundedInputStyle => InputDecoration(
        filled: true,
        fillColor: _colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_dimens.spacingMiddle),
          borderSide: BorderSide(color: _colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_dimens.spacingMiddle),
          borderSide: BorderSide(color: _colors.black),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_dimens.spacingMiddle),
          borderSide: BorderSide(color: _colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_dimens.spacingMiddle),
          borderSide: BorderSide(color: _colors.orange),
        ),
      );

  @override
  BorderRadius get topBorderRadius => BorderRadius.only(
        topLeft: Radius.circular(_dimens.spacingMlarge),
        topRight: Radius.circular(_dimens.spacingMlarge),
      );
}
