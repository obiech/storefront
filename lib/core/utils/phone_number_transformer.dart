/// Trims [phoneNumber] and transforms it into international phone number
///
/// If [phoneNumber] stars with '08', returns [phoneNumber] prefixed with +62
/// with leading zero from [phoneNumber] discarded.
///
/// Otherwise returns [phoneNumber] prefixed with +62.
///
/// For example, given a [phoneNumber] of '81234567890' or '081234567890',
/// this will return '+6281234567890'.
String trimAndTransformPhoneToIntlFormat(String phoneNumber) {
  final trimmedInput = phoneNumber.trim();
  if (trimmedInput.startsWith('08')) {
    return '+62${trimmedInput.replaceFirst('08', '8')}';
  }

  return '+62$trimmedInput';
}

/// Trims [phoneNumber] and transforms it into local phone number
///
/// If [phoneNumber] starts with '08', returns [phoneNumber].
///
/// Otherwise returns [phoneNumber] prefixed with 0.
///
/// For example, given a [phoneNumber] of '81234567890' or '081234567890',
/// this will return '081234567890'.
String trimAndTransformPhoneToLocalFormat(String phoneNumber) {
  final trimmedInput = phoneNumber.trim();
  if (trimmedInput.startsWith('08')) {
    return trimmedInput;
  }

  return '0$trimmedInput';
}
