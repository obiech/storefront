import 'package:dropezy_proto/v1/order/order.pbgrpc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/discovery/domain/repository/i_store_repository.dart';
import 'package:storefront_app/features/order/domain/domains.dart';

import '../../../../../test_commons/fixtures/address/delivery_address_models.dart';
import '../../../../commons.dart';
import '../../../../src/mock_customer_service_client.dart';
import '../../../../src/mock_response_future.dart';
import '../../../address/mocks.dart';
import '../../../order/mocks.dart';

void main() {
  late IPaymentRepository paymentRepository;
  late OrderServiceClient orderServiceClient;
  late IOrderRepository orderRepository;
  late IStoreRepository storeRepository;
  late IDeliveryAddressRepository deliveryAddressRepository;

  final paymentMethods = samplePaymentMethods;

  // Order Data
  const orderId = 'abcdefg';

  final order = orderCreated;
  order.orderId = orderId;

  final deliveryAddressModel = sampleDeliveryAddressList.first;

  final paymentInformation = mockGoPayPaymentInformation;

  /// Store Data
  const storeId = 'mock_store_id';

  setUp(() {
    orderServiceClient = MockOrderServiceClient();
    orderRepository = MockOrderRepository();
    storeRepository = MockStoreRepository();
    deliveryAddressRepository = MockDeliveryAddressRepository();
    paymentRepository = PaymentService(
      orderServiceClient,
      orderRepository,
      storeRepository,
      deliveryAddressRepository,
    );
  });

  setUpAll(() {
    registerFallbackValue(GetAvailablePaymentMethodRequest());
  });

  group('[getPaymentMethods]', () {
    test(
        'should return only active payment methods '
        'when [getPaymentMethods] is called', () async {
      when(() => orderServiceClient.getAvailablePaymentMethod(any()))
          .thenAnswer(
        (_) => MockResponseFuture.value(
          GetAvailablePaymentMethodResponse(
            paymentMethods: paymentMethods,
          ),
        ),
      );

      final response = await paymentRepository.getPaymentMethods();
      expect(response.isRight(), true);
      expect(response.getRight(), paymentMethods.toPaymentDetails());

      verify(
        () => orderServiceClient.getAvailablePaymentMethod(
          GetAvailablePaymentMethodRequest(),
        ),
      ).called(1);
    });

    test('should return [NoPaymentMethods] if no active payments are found',
        () async {
      when(() => orderServiceClient.getAvailablePaymentMethod(any()))
          .thenAnswer(
        (_) => MockResponseFuture.value(
          GetAvailablePaymentMethodResponse(
            paymentMethods: [],
          ),
        ),
      );

      final response = await paymentRepository.getPaymentMethods();
      expect(response.isLeft(), true);
      expect(response.getLeft(), isA<NoPaymentMethods>());

      verify(
        () => orderServiceClient.getAvailablePaymentMethod(
          GetAvailablePaymentMethodRequest(),
        ),
      ).called(1);
    });

    test('should return a failure when an exception is thrown', () async {
      when(() => orderServiceClient.getAvailablePaymentMethod(any()))
          .thenThrow(Exception('[Test Error]'));

      final response = await paymentRepository.getPaymentMethods();
      expect(response.isLeft(), true);
      expect(response.getLeft(), isA<Failure>());

      verify(
        () => orderServiceClient.getAvailablePaymentMethod(
          GetAvailablePaymentMethodRequest(),
        ),
      ).called(1);
    });
  });

  group('[checkoutPayment]', () {
    setUp(() {
      when(() => storeRepository.storeStream).thenAnswer(
        (_) => BehaviorSubject.seeded(storeId),
      );

      when(() => deliveryAddressRepository.activeDeliveryAddress).thenAnswer(
        (_) => deliveryAddressModel,
      );

      registerFallbackValue(CheckoutRequest());
      registerFallbackValue(OrderModel.fromPb(order));

      when(() => orderServiceClient.checkout(any())).thenAnswer(
        (_) => MockResponseFuture.value(
          CheckoutResponse(
            order: order,
            paymentInformation: paymentInformation,
          ),
        ),
      );
    });

    test(
        "should call [OrderServiceClient]'s [checkout] method with valid arguments "
        'when called', () async {
      // act
      const paymentMethod = PaymentMethod.PAYMENT_METHOD_GOPAY;
      await paymentRepository.checkoutPayment(paymentMethod);

      // assert
      verify(
        () => orderServiceClient.checkout(
          CheckoutRequest(
            storeId: storeId,
            addressId: deliveryAddressModel.id,
            paymentMethod: paymentMethod,
          ),
        ),
      ).called(1);
    });

    test(
        "should call [IOrderRepository]'s [addOrder] "
        'then return a [PaymentResultsModel] '
        'when [checkout] is successful', () async {
      // arrange
      when(() => orderRepository.addOrder(any())).thenAnswer((_) {});

      // act
      final response = await paymentRepository.checkoutPayment(
        PaymentMethod.PAYMENT_METHOD_GOPAY,
      );
      expect(response.isRight(), true);

      final result = response.getRight();
      expect(result.paymentMethod, paymentInformation.paymentMethod);
      expect(result.order, OrderModel.fromPb(order));

      // assert
      verify(
        () => orderRepository.addOrder(OrderModel.fromPb(order)),
      ).called(1);
    });

    test('should return a failure when [checkout] throws an exception',
        () async {
      // arrange
      when(() => orderServiceClient.checkout(any()))
          .thenThrow(Exception('[Test Error]'));
      // act
      final response = await paymentRepository.checkoutPayment(
        PaymentMethod.PAYMENT_METHOD_GOPAY,
      );
      expect(response.isLeft(), true);
      expect(response.getLeft(), isA<Failure>());

      // assert
      verifyNever(
        () => orderRepository.addOrder(OrderModel.fromPb(order)),
      );
    });
  });
}
