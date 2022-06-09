import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/discovery/discovery.pbgrpc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../../../di/di_environment.dart';
import '../repository/i_store_repository.dart';

/// Responsible for retrieving stores from [DiscoveryServiceClient].
///
/// May be obsolete once Geofence module is available.
// TODO (leovinsen): add stream to be subscribed from blocs needing it
@LazySingleton(as: IStoreRepository, env: DiEnvironment.grpcEnvs)
class StoreRepository extends IStoreRepository {
  StoreRepository(this._discoveryServiceClient);

  final DiscoveryServiceClient _discoveryServiceClient;

  @override
  RepoResult<String> getStore() async {
    try {
      final response =
          await _discoveryServiceClient.getStores(GetStoresRequest());

      if (response.stores.isEmpty) {
        return left(Failure('No stores were found.'));
      } else {
        return right(response.stores[0].storeId);
      }
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }
}
