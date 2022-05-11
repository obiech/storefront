import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../utils/dotenv.ext.dart';

/// Contains configuration for gRPC client
///
/// Make sure to call [dotenv.load()] before using this class
class GrpcConfig {
  static String get grpcServerUrl => dotenv.getString('GRPC_SERVER_URL');

  static int get grpcServerPort =>
      dotenv.getInt('GRPC_SERVER_PORT', fallback: 443);

  static bool get grpcEnableTls =>
      dotenv.getBool('GRPC_ENABLE_TLS', fallback: true);
}
