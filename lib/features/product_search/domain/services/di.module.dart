import 'package:dropezy_proto/v1/search/search.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';

@module
abstract class ServiceModule {
  /// Creates a gRPC [Client] responsible for communicating with
  /// storefront-backend Search Service,
  ///
  /// and registers it to Service Locator [GetIt].
  @lazySingleton
  SearchServiceClient searchClient(
    ClientChannel channel,
    AuthInterceptor authInterceptor,
    DeviceInterceptor deviceInterceptor,
  ) {
    return SearchServiceClient(
      channel,
      interceptors: [
        authInterceptor,
        deviceInterceptor,
      ],
    );
  }
}
