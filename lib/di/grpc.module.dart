import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

import '../core/config/grpc_config.dart';
import '../core/network/grpc/customer/customer.pbgrpc.dart';

/// GRPC Dependency Injection Module
///
/// Provide all dependencies for grpc related injection here
@module
abstract class GrpcModule {
  /// Create a channel for gRPC connection
  /// And registers gRPC [Client]s to Service Locator [GetIt]
  //TODO (leovinsen): set up gRPC certificates for secure connection
  //TODO (leovinsen): throw an error if TLS is not enabled on production build
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

  CustomerServiceClient serviceClient(ClientChannel channel) {
    return CustomerServiceClient(channel);
  }
}
