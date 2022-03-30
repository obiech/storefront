/// Extension methods for [String] data
extension StringX on String {
  /// Takes a [String] [this] and converts it to IDR currency
  String toCurrency() {
    return 'Rp ${toIDRFormat()}';
  }

  /// Takes a [String] [this] and converts it to IDR format
  String toIDRFormat() {
    if (!isNumeric()) return '0,00';

    switch (length) {
      case 1:
        return '0,0$this';
      case 2:
        return '0,$this';
      default:

        /// Pick last two digits
        final cents = substring(length - 2, length);

        /// Pick the rest of the digits & format them
        final body = substring(0, length - 2).formatNumber('.');

        return '$body,$cents';
    }
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
