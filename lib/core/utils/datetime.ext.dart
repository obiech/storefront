import 'package:intl/intl.dart';

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

    switch (format) {
      case TimeDiffFormat.hhmmss:
        return timeDiff.toHhMmSs();
      case TimeDiffFormat.mmss:
        return timeDiff.toMmSs();
    }
  }

  String formatHm() {
    return DateFormat.Hm().format(this);
  }
}

extension DurationX on Duration {
  String toHhMmSs() {
    final String hh = inHours.toString().padLeft(2, '0');
    final String mm = (inMinutes % 60).toString().padLeft(2, '0');
    final String ss = (inSeconds % 60).toString().padLeft(2, '0');

    return '$hh:$mm:$ss';
  }

  String toMmSs() {
    final String mm = (inMinutes % 60).toString().padLeft(2, '0');
    final String ss = (inSeconds % 60).toString().padLeft(2, '0');

    return '$mm:$ss';
  }
}
