import 'package:dropezy_proto/v1/customer/customer.pbgrpc.dart';
import 'package:dropezy_proto/v1/order/order.pbgrpc.dart';
import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

import '../core/config/grpc_config.dart';
import '../core/network/grpc/interceptors/auth/index.dart';
import '../features/auth/domain/services/user_credentials_storage.dart';

/// GRPC Dependency Injection Module
///
/// Provide all dependencies for grpc related injection here
@module
abstract class GrpcModule {
  /// Creates a gRPC [ClientInterceptor] responsible for appending
  /// authorization metadata to every gRPC requests except for whitelisted
  /// paths which can be found in [authWhitelistedPaths],
  ///
  /// and registers it to Service Locator [GetIt].
  @lazySingleton
  AuthInterceptor authInterceptor(
    UserCredentialsStorage userCredentialsStorage,
  ) =>
      AuthInterceptor(
        userCredentialsStorage: userCredentialsStorage,
        whitelistedPaths: authWhitelistedPaths,
      );

  /// Create a channel for gRPC connection
  /// And registers gRPC [ClientChannel]s to Service Locator [GetIt].
  //TODO (leovinsen): throw an error if TLS is not enabled on production build
  @lazySingleton
  ClientChannel get clientChannel => ClientChannel(
        GrpcConfig.grpcServerUrl,
        port: GrpcConfig.grpcServerPort,
        options: ChannelOptions(
          connectionTimeout: const Duration(seconds: 5),
          credentials: GrpcConfig.grpcEnableTls
              ? const ChannelCredentials.secure()
              : const ChannelCredentials.insecure(),
          codecRegistry:
              CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
        ),
      );

  /// Creates a gRPC [Client] responsible for communicating with
  /// storefront-backend Customer Service,
  ///
  /// and registers it to Service Locator [GetIt].
  @lazySingleton
  CustomerServiceClient serviceClient(
    ClientChannel channel,
    AuthInterceptor authInterceptor,
  ) {
    return CustomerServiceClient(
      channel,
      interceptors: [
        authInterceptor,
      ],
    );
  }

  /// Creates a gRPC [Client] responsible for communicating with
  /// storefront-backend Order Service,
  ///
  /// and registers it to Service Locator [GetIt].
  OrderServiceClient orderClient(
    ClientChannel channel,
    AuthInterceptor authInterceptor,
  ) {
    return OrderServiceClient(
      channel,
      interceptors: [
        authInterceptor,
      ],
    );
  }
}
