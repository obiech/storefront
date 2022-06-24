import 'package:flutter/services.dart';

import './string.ext.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.capitalize(),
      selection: newValue.selection,
    );
  }
}
