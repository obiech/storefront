import 'package:dartz/dartz.dart';
import 'package:storefront_app/core/core.dart';

import '../domains.dart';

abstract class IDeliveryAddressRepository {
  RepoResult<List<DeliveryAddressModel>> getDeliveryAddresses();
  RepoResult<Unit> saveAddress(DeliveryAddressModel address);

  /// Pick current primary delivery address
  DeliveryAddressModel? get activeDeliveryAddress;
}
