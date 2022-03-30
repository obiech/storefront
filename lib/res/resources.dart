import 'package:flutter/cupertino.dart';

import 'colors/app_colors.dart';
import 'colors/base_colors.dart';
import 'dimentions/base_dimensions.dart';
import 'dimentions/phone_dimensions.dart';
import 'dimentions/tablet_dimensions.dart';
import 'paths/base_paths.dart';
import 'paths/english_paths.dart';
import 'paths/indonesian_paths.dart';
import 'strings/base_strings.dart';
import 'strings/english_strings.dart';
import 'strings/indonesion_strings.dart';
import 'styles/app_styles.dart';
import 'styles/base_styles.dart';

class Resources {
  final BuildContext _context;

  Resources(this._context);

  BaseStrings get strings {
    // It could be from the user preferences or even from the current locale
    final locale = Localizations.localeOf(_context);

    switch (locale.languageCode) {
      case 'id':
        return IndonesianStrings();
      default:
        return EnglishStrings();
    }
  }

  BaseColors get colors {
    return AppColors();
  }

  BaseDimensions get dimensions {
    final shortestSide = MediaQuery.of(_context).size.shortestSide;

    if (shortestSide > 600) {
      return TabletDimensions();
    }

    return PhoneDimensions();
  }

  BasePaths get paths {
    // It could be from the user preferences or even from the current locale
    final locale = Localizations.localeOf(_context);

    switch (locale.languageCode) {
      case 'id':
        return IndonesianPaths();
      default:
        return EnglishPaths();
    }
  }

  BaseStyles get styles {
    return AppStyles(colors);
  }

  static Resources of(BuildContext context) {
    return Resources(context);
  }
}
