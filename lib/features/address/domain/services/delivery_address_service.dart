import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/customer/customer.pbgrpc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/di_environment.dart';
import 'package:storefront_app/features/address/index.dart';

/// Repository for fetching customer address from storefront-backend
/// using gRPC connection.
@LazySingleton(as: IDeliveryAddressRepository, env: DiEnvironment.grpcEnvs)
class DeliveryAddressService implements IDeliveryAddressRepository {
  final CustomerServiceClient _customerService;

  DeliveryAddressService(CustomerServiceClient customerServiceClient)
      : _customerService = customerServiceClient;

  @override
  RepoResult<List<DeliveryAddressModel>> getDeliveryAddresses() async {
    try {
      final request = GetProfileRequest();

      final response = await _customerService.getProfile(request);
      final profile = response.profile;
      final addresses =
          profile.addresses.map(DeliveryAddressModel.fromPb).toList();

      return right(addresses);
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }

  @override
  RepoResult<Unit> saveAddress(DeliveryAddressModel address) async {
    try {
      final Address addressRequest = address.toPb();
      final AddAddressRequest request = AddAddressRequest(
        address: addressRequest.address,
        addressType: addressRequest.addressType,
        contact: addressRequest.contact,
      );

      await _customerService.addAddress(request);

      return right(unit);
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }
}
