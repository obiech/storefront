import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';

import '../../../../../features/auth/index.dart';

/// Intercepts unary requests and appends 'authorization' metadata
/// with bearer token obtained from [authService].
///
/// will not intercept for paths in [whitelistedPaths]. To find the path name,
/// check the generated files for [Client] class.
class AuthInterceptor extends ClientInterceptor {
  AuthInterceptor({
    required this.authService,
    required this.whitelistedPaths,
  });

  final AuthService authService;
  final List<String> whitelistedPaths;

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    // do not modify metadata if current path is whitelisted
    final newOptions = whitelistedPaths.contains(method.path)
        ? options
        : options.mergedWith(
            CallOptions(
              providers: [
                appendAuthMetadata,
              ],
            ),
          );

    return invoker(method, request, newOptions);
  }

  /// Appends key 'authorization' to gRPC Metadata
  /// value consists of the string 'bearer ' concatenated with token obtained
  /// from [UserCredentialsStorage.getCredentials].
  ///
  /// Method will terminate earlier if one of the following conditions
  /// is satisfied:
  ///
  /// 1) key 'authorization' is already set,
  /// 2) credentials is null (used is not logged in).
  ///
  /// Is based on [MetadataProvider] type definition.
  @visibleForTesting
  Future<void> appendAuthMetadata(
    Map<String, String> metadata,
    String uri,
  ) async {
    if (metadata['authorization'] != null) {
      return;
    }

    final token = await authService.getToken();

    if (token == null) {
      return;
    }

    metadata['authorization'] = 'bearer $token';
  }
}
