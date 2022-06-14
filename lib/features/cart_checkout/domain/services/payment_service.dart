import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/order/order.pbgrpc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/di_environment.dart';
import 'package:storefront_app/features/address/index.dart';

import '../../../discovery/domain/repository/i_store_repository.dart';
import '../../../order/index.dart';
import '../domains.dart';

/// The gRPC payment handling service
///
/// * [IPaymentRepository.getPaymentMethods] - Since all payment
/// methods will be provided by the backend, this method hits the
/// gRPC end-point that returns a list of payment methods from which
/// active ones signified by the
/// [PaymentMethodStatus.PAYMENT_METHOD_STATUS_ACTIVE] status can be filtered.
///
/// * [IPaymentRepository.checkoutPayment] - Currently this method is
/// buggy and will always fail since the app has to pass product variants
/// [ProductVariant] which in a security & design perspective is a huge flaw.
///
/// Once the proto request for checkout has been trimmed down to hopefully only
/// the *store_id* and *customer_id* (Which can be accessed via `Bearer token`)
/// meaning only *store_id* in this case. This can be refactored.
@LazySingleton(as: IPaymentRepository, env: DiEnvironment.grpcEnvs)
class PaymentService implements IPaymentRepository {
  final OrderServiceClient orderServiceClient;
  final IStoreRepository storeRepository;
  final IOrderRepository orderRepository;
  final IDeliveryAddressRepository deliveryAddressRepository;

  PaymentService(
    this.orderServiceClient,
    this.orderRepository,
    this.storeRepository,
    this.deliveryAddressRepository,
  );

  @override
  RepoResult<List<PaymentMethodDetails>> getPaymentMethods() async {
    try {
      final paymentMethodsResponse = await orderServiceClient
          .getAvailablePaymentMethod(GetAvailablePaymentMethodRequest());

      final activePaymentMethods =
          paymentMethodsResponse.paymentMethods.where(channelIsActive).toList();

      if (activePaymentMethods.isEmpty) return left(NoPaymentMethods());

      return right(activePaymentMethods.toPaymentDetails());
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }

  @override
  RepoResult<PaymentResultsModel> checkoutPayment(PaymentMethod method) async {
    try {
      // TODO(obella465): Fix once minimal submission details are provided
      final storeId = storeRepository.storeStream.valueOrNull;
      final addressId = deliveryAddressRepository.activeDeliveryAddress?.id;

      // TODO(obella): Handle null storeId
      // TODO(obella): Handle addressId
      final checkoutRequest = CheckoutRequest(
        storeId: storeId,
        addressId: addressId,
        paymentMethod: method,
      );

      final response = await orderServiceClient.checkout(checkoutRequest);

      final resultsModel = PaymentResultsModel.fromCheckoutResponse(response);
      orderRepository.addOrder(resultsModel.order);

      return right(resultsModel);
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }
}
