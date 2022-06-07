import 'package:dropezy_proto/google/protobuf/timestamp.pb.dart';

extension TimestampX on Timestamp {
  DateTime toDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(seconds.toInt() * 1000);
  }
}
