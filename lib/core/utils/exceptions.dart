import 'package:dartz/dartz.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../core.dart';

/// For quick error handling, code can be wrapped in this helper method.
///
/// [logToCrashlytics] can be used to toggle whether the exception should
/// be logged to firebase crashlytics. Which is true by default.
///
/// Usage:
/// ```dart
/// RepoResult<MyModel> myMethod() async {
///     return safeCall(() async {
///             // Your code here
///           });
/// }
/// ```
RepoResult<R> safeCall<R>(
  RepoResult<R> Function() body, {
  bool logToCrashlytics = true,
}) async {
  try {
    return await body();
  } on Exception catch (err, stack) {
    if (logToCrashlytics) {
      FirebaseCrashlytics.instance.recordError(err, stack);
    }

    return Left(err.toFailure);
  }
}
