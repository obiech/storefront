/// Extension methods for [String] data
extension StringX on String {
  /// Takes a [String] [this] and converts it to IDR currency
  /// by applying [toIDRFormat] and prefixing the result with 'Rp '
  String toCurrency([String fallback = '0']) {
    return 'Rp ${toIDRFormat(fallback)}';
  }

  /// Takes a [String] [this] and converts it to IDR format
  /// i.e. with period '.' as thousands separator
  /// and comma ',' as decimal separator
  ///
  /// Omits cents component if last two digits are zero
  ///
  /// [fallback] is returned if string is malformed
  String toIDRFormat([String fallback = '0']) {
    // String is malformed
    if (!isNumeric() || length < 3) return fallback;

    /// Pick last two digits
    final cents = substring(length - 2, length);

    /// Pick the rest of the digits & format them
    final body = substring(0, length - 2).formatNumber('.');

    /// Omit cents if it's 0
    if (cents == '00') return body;

    return '$body,$cents';
  }

  /// Takes in a string number and formats it using separator
  String formatNumber(String separator) {
    if (!isNumeric()) return '';

    /// Individual formatted digits
    final List<dynamic> digits = [];

    for (int i = 0; i < length; i++) {
      /// Insert separator every three digits
      if (i % 3 == 0 && i != 0) {
        digits.insert(0, separator);
      }

      digits.insert(0, this[length - (i + 1)]);
    }

    final buffer = StringBuffer();
    buffer.writeAll(digits);
    return buffer.toString();
  }

  /// Checks if a [String] is numeric
  ///
  /// i.e can be parsed to a number
  bool isNumeric() {
    return double.tryParse(this) != null;
  }
}
