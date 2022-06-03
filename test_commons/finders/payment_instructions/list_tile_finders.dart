import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/order/index.dart';

/// This [ListTile] contains elements
/// that belongs to [ListTile] inside [PaymentInformationSection]
class ListTileFinder {
  static Finder get finderTile =>
      find.byKey(const ValueKey(InformationsTileKeys.tile));

  static Finder get finderHeader =>
      find.byKey(const ValueKey(InformationsTileKeys.header));

  static Finder get finderSubtitleText =>
      find.byKey(const ValueKey(InformationsTileKeys.subtitleText));

  static Finder get finderSubtitleLogo =>
      find.byKey(const ValueKey(InformationsTileKeys.subtitleLogo));

  static Finder get finderButton =>
      find.byKey(const ValueKey(InformationsTileKeys.button));
}
