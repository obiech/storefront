import 'package:dropezy_proto/v1/cart/cart.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';

@module
abstract class CartServiceModule {
  /// Creates a gRPC [Client] responsible for communicating with
  /// storefront-backend Cart Service,
  ///
  /// and registers it to Service Locator [GetIt].
  @lazySingleton
  CartServiceClient cartServiceClient(
    ClientChannel channel,
    AuthInterceptor authInterceptor,
    DeviceInterceptor deviceInterceptor,
  ) {
    return CartServiceClient(
      channel,
      interceptors: [
        authInterceptor,
        deviceInterceptor,
      ],
    );
  }
}
