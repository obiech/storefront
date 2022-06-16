import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/discovery/discovery.pbgrpc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/core.dart';
import '../../../../di/di_environment.dart';
import '../repository/i_store_repository.dart';

/// Responsible for retrieving stores from [DiscoveryServiceClient].
///
/// May be obsolete once Geofence module is available.
// TODO (obella): add stream to be subscribed from blocs needing it
@LazySingleton(as: IStoreRepository, env: DiEnvironment.grpcEnvs)
class StoreRepository extends IStoreRepository {
  StoreRepository(this._discoveryServiceClient)
      : _storeStream = BehaviorSubject();

  final DiscoveryServiceClient _discoveryServiceClient;

  final BehaviorSubject<String> _storeStream;

  @override
  RepoResult<String> getStore() async {
    try {
      final response =
          await _discoveryServiceClient.getStores(GetStoresRequest());

      if (response.stores.isEmpty) {
        return left(Failure('No stores were found.'));
      } else {
        final storeId = response.stores[0].storeId;
        _storeStream.add(storeId);
        return right(storeId);
      }
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }

  @override
  BehaviorSubject<String> get storeStream => _storeStream;
}
