enum TimeDiffFormat {
  /// hh:mm:ss
  hhmmss,

  /// mm:ss
  mmss,
}

/// Extension for working with [DateTime]
extension DateTimeX on DateTime {
  /// Returns pretty formatted String of time difference between
  /// [this] [DateTime] and [otherDate]
  ///
  /// Returns:
  /// - difference as hh:mm:ss if [TimeDiffFormat.hhmmss].
  /// - difference as mm:ss if [TimeDiffFormat.mmss].

  String getPrettyTimeDifference(
    TimeDiffFormat format,
    DateTime otherDate,
  ) {
    final timeDiff = difference(otherDate);

    final String diffHours = timeDiff.inHours.toString().padLeft(2, '0');
    final String diffMins =
        (timeDiff.inMinutes % 60).toString().padLeft(2, '0');
    final String diffSeconds =
        (timeDiff.inSeconds % 60).toString().padLeft(2, '0');

    switch (format) {
      case TimeDiffFormat.hhmmss:
        return '$diffHours:$diffMins:$diffSeconds';
      case TimeDiffFormat.mmss:
        return '$diffMins:$diffSeconds';
    }
  }
}
