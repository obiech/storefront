import 'package:dropezy_proto/v1/category/category.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';

@module
abstract class HomeServiceModule {
  /// Creates a gRPC [Client] responsible for communicating with
  /// storefront-backend Categories Service,
  ///
  /// and registers it to Service Locator [GetIt].
  @lazySingleton
  CategoryServiceClient categoryClient(
    ClientChannel channel,
    AuthInterceptor authInterceptor,
    DeviceInterceptor deviceInterceptor,
  ) {
    return CategoryServiceClient(
      channel,
      interceptors: [
        authInterceptor,
        deviceInterceptor,
      ],
    );
  }
}
