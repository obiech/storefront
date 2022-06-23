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
  DeliveryAddressModel? _activeAddress;
  final List<DeliveryAddressModel> _addresses;
  final CustomerServiceClient _customerService;

  DeliveryAddressService(this._customerService) : _addresses = [];

  @override
  RepoResult<List<DeliveryAddressModel>> getDeliveryAddresses() async {
    try {
      final request = GetProfileRequest();

      final response = await _customerService.getProfile(request);
      final profile = response.profile;
      final addresses =
          profile.addresses.map(DeliveryAddressModel.fromPb).toList();

      // Add to addresses cache
      _addresses.addAll(addresses);
      _activeAddress = _addresses.primaryAddress;

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

      // Add addresses cache
      final addAddressResponse = await _customerService.addAddress(request);
      _addresses.add(DeliveryAddressModel.fromPb(addAddressResponse.address));
      _activeAddress = _addresses.primaryAddress;

      return right(unit);
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }

  @override
  RepoResult<Unit> updateAddress(DeliveryAddressModel address) async {
    try {
      final Address addressRequest = address.toPb();
      final UpdateAddressRequest request = UpdateAddressRequest(
        address: addressRequest.address,
        addressType: addressRequest.addressType,
        contact: addressRequest.contact,
      );

      // Add addresses cache
      final updateAddressRes = await _customerService.updateAddress(request);
      final oldIndex = _addresses.indexWhere((e) => e.id == address.id);

      if (address.isPrimaryAddress && _addresses.primaryAddress != null) {
        final oldPrimaryAddress = _addresses.primaryAddress!;
        final oldPrimaryIndex = _addresses.indexOf(oldPrimaryAddress);

        // Mark previous primary as non-primary
        // TODO: replace with copywith
        _addresses[oldPrimaryIndex] = DeliveryAddressModel(
          id: oldPrimaryAddress.id,
          title: oldPrimaryAddress.title,
          isPrimaryAddress: false,
          lat: oldPrimaryAddress.lat,
          lng: oldPrimaryAddress.lng,
          notes: oldPrimaryAddress.notes,
          recipientName: oldPrimaryAddress.recipientName,
          recipientPhoneNumber: oldPrimaryAddress.recipientPhoneNumber,
          dateCreated: oldPrimaryAddress.dateCreated,
          details: oldPrimaryAddress.details,
        );
      }

      _addresses[oldIndex] = DeliveryAddressModel.fromPb(
        updateAddressRes.address,
      );

      return right(unit);
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }

  @override
  DeliveryAddressModel? get activeDeliveryAddress => _activeAddress;
}
