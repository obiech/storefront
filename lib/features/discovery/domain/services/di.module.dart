import 'package:dropezy_proto/v1/discovery/discovery.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';

@module
abstract class DiscoveryServiceModule {
  /// Creates a gRPC [Client] responsible for communicating with
  /// storefront-backend Discovery Service,
  ///
  /// and registers it to Service Locator [GetIt].
  @lazySingleton
  DiscoveryServiceClient discoveryClient(
    ClientChannel channel,
    AuthInterceptor authInterceptor,
    DeviceInterceptor deviceInterceptor,
  ) {
    return DiscoveryServiceClient(
      channel,
      interceptors: [
        authInterceptor,
        deviceInterceptor,
      ],
    );
  }
}
