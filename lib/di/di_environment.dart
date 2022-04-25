import 'package:injectable/injectable.dart';

class DiEnvironment extends Environment {
  DiEnvironment(String name) : super(name);

  static const dummy = 'dummy';

  static const dev = Environment.dev;

  static const prod = Environment.prod;

  static const test = Environment.test;

  /// Environments that do not make use of Dummy repositories
  static const grpcEnvs = [dev, prod, test];
}
