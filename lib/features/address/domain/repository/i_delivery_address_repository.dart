import 'package:dartz/dartz.dart';
import 'package:storefront_app/core/core.dart';

import '../domains.dart';

abstract class IDeliveryAddressRepository {
  Future<Either<Failure, List<DeliveryAddressModel>>> getDeliveryAddresses();
}
