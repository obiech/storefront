import 'package:flutter/material.dart';

import 'base_dimensions.dart';

class PhoneDimensions implements BaseDimensions {
  @override
  double get spacingXxlarge => 36;

  @override
  double get spacingXlarge => 32;

  @override
  double get spacingMxlarge => 28;

  @override
  double get spacingMlarge => 24;

  @override
  double get spacingSmlarge => 20;

  @override
  double get spacingLarge => 16;

  @override
  double get spacingMiddle => 12;

  @override
  double get spacingMedium => 8;

  @override
  double get spacingSmall => 4;

  @override
  double get highElevation => 16;

  @override
  double get mediumElevation => 8;

  @override
  double get lightElevation => 4;

  @override
  double get bigText => 22;

  @override
  double get defaultText => 18;

  @override
  double get mediumText => 16;

  @override
  double get smallText => 12;

  @override
  double get verySmallText => 8;

  @override
  double get bottomSheetHorizontalPadding => 24;

  @override
  double get pagePadding => 16;

  @override
  double get leadingWidth => 40;

  @override
  double get appBarSize => AppBar().preferredSize.height;

  /// offset = cart height + margin * 2
  /// cart height is 42
  /// margin is 12
  ///
  /// Dimensions taken from Figma,
  @override
  double get minOffsetForCartSummary => 66;
}
