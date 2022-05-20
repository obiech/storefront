extension IntX on int {
  /// Badge label
  String get badgeText => this < 10 ? toString() : '9+';
}
