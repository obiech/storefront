import 'package:dropezy_proto/v1/inventory/inventory.pbgrpc.dart';
import 'package:dropezy_proto/v1/search/search.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';

import '../../config.dart';

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

  /// Search History Box
  @preResolve
  Future<Box<DateTime>> get searchHistoryBox =>
      Hive.openBox<DateTime>(searchHistoryBoxKey);

  /// Search History Query Box
  @preResolve
  Future<Box<SearchLocationHistoryQuery>> get searchLocationHistoryQueryBox =>
      Hive.openBox<SearchLocationHistoryQuery>(
        searchLocationHistoryQueryBoxKey,
      );

  /// Creates a gRPC [Client] responsible for communicating with
  /// storefront-backend Inventories Service,
  ///
  /// and registers it to Service Locator [GetIt].
  @lazySingleton
  InventoryServiceClient categoryClient(
    ClientChannel channel,
    AuthInterceptor authInterceptor,
    DeviceInterceptor deviceInterceptor,
  ) {
    return InventoryServiceClient(
      channel,
      interceptors: [
        authInterceptor,
        deviceInterceptor,
      ],
    );
  }
}
