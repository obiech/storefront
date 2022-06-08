import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/order/order.pbgrpc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/di_environment.dart';

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

  PaymentService(this.orderServiceClient);

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
  RepoResult<String> checkoutPayment(PaymentMethod method) async {
    try {
      // TODO(obella465): Fix once minimal submission details are provided

      final checkoutRequest = CheckoutRequest(
        storeId: 'store_11',
        addressId: 'address_11',
        paymentMethod: method,
      );

      final checkoutResponse =
          await orderServiceClient.checkout(checkoutRequest);

      final paymentInfo = checkoutResponse.paymentInformation;

      switch (paymentInfo.whichFlow()) {
        case PaymentInformation_Flow.gopayPaymentInfo:
          return right(paymentInfo.gopayPaymentInfo.deeplink);
        case PaymentInformation_Flow.vaPaymentInfo:
          // TODO: implement VA Checkout
          throw UnimplementedError();
        case PaymentInformation_Flow.notSet:
          return left(CheckoutFailure('Missing payment information'));
      }
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }
}
