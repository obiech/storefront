import 'package:injectable/injectable.dart';

/// Abstraction for [DateTime]
/// so it can be mocked/stubbed during tests
@LazySingleton()
class DateTimeProvider {
  DateTime get now => DateTime.now();
}
