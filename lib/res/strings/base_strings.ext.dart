import 'package:flutter/material.dart';

import 'base_strings.dart';
import 'english_strings.dart';
import 'indonesian_strings.dart';

extension BaseStringX on Locale {
  BaseStrings get strings {
    switch (languageCode) {
      case 'id':
        return IndonesianStrings();
      default:
        return EnglishStrings();
    }
  }
}
