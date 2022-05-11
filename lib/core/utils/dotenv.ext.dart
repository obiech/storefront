import 'package:flutter_dotenv/flutter_dotenv.dart';

typedef EnvParser<T> = T Function(String);

/// Wrapper methods for typecasting values from [DotEnv]
/// and supports an optional fallback value when value is not found.
///
/// For unsupported types, you can use [tryGet] to write a
/// new wrapper.
extension DotEnvX on DotEnv {
  /// Wrapper function for getting a [String] value from [DotEnv].
  String getString(String keyName, {String? fallback}) {
    return tryGet<String>(
      keyName,
      (value) => value,
      fallback: fallback,
    );
  }

  /// Wrapper function for getting an [int] value from [DotEnv].
  ///
  /// Will call [int.parse] on the value [String], which throws
  /// a [FormatException] if value is not an [int].
  int getInt(String keyName, {int? fallback}) {
    return tryGet<int>(
      keyName,
      (value) => int.parse(value),
      fallback: fallback,
    );
  }

  /// Wrapper function for getting a [double] value from [DotEnv].
  ///
  /// Will call [double.parse] on the value [String], which throws
  /// a [FormatException] if value is not an [double].
  double getDouble(String keyName, {double? fallback}) {
    return tryGet<double>(
      keyName,
      (value) => double.parse(value),
      fallback: fallback,
    );
  }

  /// Wrapper function for getting a [bool] value from [DotEnv].
  ///
  /// Checks if the value [String] is == 'true'.
  bool getBool(String keyName, {bool? fallback}) {
    return tryGet<bool>(
      keyName,
      (value) => value.toLowerCase().trim() == 'true',
      fallback: fallback,
    );
  }

  /// Base function for getting a value given a key [keyName].
  ///
  /// [parser] is a function for parsing the value [String] into [T].
  ///
  /// [fallback] will be returned if key [keyName] is not found. Otherwise,
  /// throws a [MissingEnvError].
  T tryGet<T>(String keyName, T Function(String) parser, {T? fallback}) {
    final String? value = dotenv.maybeGet(keyName);

    if (value == null && fallback != null) {
      return fallback;
    }

    if (value != null) {
      return parser(value);
    }

    throw MissingEnvError(keyName);
  }
}

class MissingEnvError extends Error {
  final String envKeyName;

  MissingEnvError(this.envKeyName);

  @override
  String toString() {
    return 'Failed to load env variable with name: $envKeyName';
  }
}
