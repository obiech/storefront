import 'package:storefront_app/core/core.dart';

import '../domains.dart';

abstract class IDeliveryAddressRepository {
  RepoResult<List<DeliveryAddressModel>> getDeliveryAddresses();
}
