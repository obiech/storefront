import 'package:flutter/cupertino.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';

import 'colors/app_colors.dart';
import 'colors/base_colors.dart';
import 'dimensions/base_dimensions.dart';
import 'dimensions/phone_dimensions.dart';
import 'dimensions/tablet_dimensions.dart';
import 'links/base_links.dart';
import 'links/english_links.dart';
import 'links/indonesian_links.dart';
import 'paths/base_paths.dart';
import 'paths/english_paths.dart';
import 'paths/indonesian_paths.dart';
import 'strings/base_strings.dart';
import 'strings/base_strings.ext.dart';
import 'styles/app_styles.dart';
import 'styles/base_styles.dart';

class Resources {
  final BuildContext _context;
  final Locale _locale;

  Resources(this._context, this._locale);

  BaseStrings get strings => _locale.strings;

  BaseColors get colors {
    return AppColors();
  }

  BaseDimensions get dimens {
    final shortestSide = MediaQuery.of(_context).size.shortestSide;

    if (shortestSide > 600) {
      return TabletDimensions();
    }

    return PhoneDimensions();
  }

  BaseLinks get links {
    switch (_locale.languageCode) {
      case 'id':
        return IndonesianLinks();
      default:
        return EnglishLinks();
    }
  }

  BasePaths get paths {
    switch (_locale.languageCode) {
      case 'id':
        return IndonesianPaths();
      default:
        return EnglishPaths();
    }
  }

  BaseStyles get styles {
    return AppStyles(colors, dimens);
  }

  // TODO: think of another approach perhaps through use of singletons, or
  // look at existing .of implementations in Provider, Localization, etc.
  // ignore: prefer_constructors_over_static_methods
  static Resources of(BuildContext context) {
    final deviceLocale = getIt<IPrefsRepository>().getDeviceLocale();
    return Resources(context, deviceLocale);
  }
}
