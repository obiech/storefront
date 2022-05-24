import 'package:dartz/dartz.dart';

/// The following methods should only be used in Test files,
/// to quickly terminate the test case by throwing an [Error]
/// when an unexpected value is returned.
///
/// In production code, this would cause a crash.
extension EitherTestX<L, R> on Either<L, R> {
  /// Returns left value if [this] is a [Left].
  /// Otherwise, throws a [NotLeftError].
  L getLeft() => isLeft() ? (this as Left).value : throw NotLeftError();

  /// Returns right value if [this] is a [Right].
  /// Otherwise, throws a [NotRightError].
  R getRight() => isRight() ? (this as Right).value : throw NotRightError();
}

class NotLeftError extends Error {
  NotLeftError();

  @override
  String toString() => 'Found a Right when Left is expected';
}

class NotRightError extends Error {
  NotRightError();

  @override
  String toString() => 'Found a Left when Right is expected';
}
