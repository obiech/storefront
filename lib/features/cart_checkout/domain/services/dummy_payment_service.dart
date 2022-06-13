import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/order/order.pb.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/di_environment.dart';
import 'package:storefront_app/features/order/index.dart';
import 'package:uuid/uuid.dart';

import '../domains.dart';

/// Dummy for [IPaymentRepository]
///
/// * [IPaymentRepository.checkoutPayment]
/// Method sends a request to GoPay sandbox API via https
/// https://docs.midtrans.com/en/core-api/e-wallet
///
/// HTTP Request would be
/// ```
///curl -X 'POST' -d '
///{
///  "payment_type": "gopay",
///  "transaction_details": {
///    "order_id": "{YOUR_ORDER_ID}",
///    "gross_amount": 1000
///  },
///  "item_details": {
///    "id": "test-item-1",
///    "price": 1000,
///    "quantity": 1,
///    "name": "test-item"
///  },
///  "customer_details": {
///    "first_name": "Test",
///    "last_name": "Customer",
///    "email": "customer@test.com",
///    "phone": "+82888888888"
///  },
///  "gopay": {
///    "enable_callback": false,
///    "callback_url": ""
///  }
///}
///' -H 'Accept: application/json' -H 'Authorization: Basic <MIDTRANS_API>' -H 'Content-Type: application/json' 'https: //api.sandbox.midtrans.com/v2/charge'
///```
///
/// and a sample response would be:
///
///```
///{
///  "status_code": "201",
///  "status_message": "GoPay transaction is created",
///  "transaction_id": "49b0eb2d-ac5e-4849-a142-b725a71edafc",
///  "order_id": "fe147fcf-0e0a-4fe7-a5d9-785f78dab052",
///  "merchant_id": "G372837958",
///  "gross_amount": "1000.00",
///  "currency": "IDR",
///  "payment_type": "gopay",
///  "transaction_time": "2022-04-04 08:46:32",
///  "transaction_status": "pending",
///  "fraud_status": "accept",
///  "actions": [
///    {
///      "name": "generate-qr-code",
///      "method": "GET",
///      "url": "https://api.sandbox.midtrans.com/v2/gopay/49b0eb2d-ac5e-4849-a142-b725a71edafc/qr-code"
///    },
///    {
///      "name": "deeplink-redirect",
///      "method": "GET",
///      "url": "https://simulator-v2.sandbox.midtrans.com/gopay/partner/app/payment-pin?id=425dcc4b-0038-44a1-881c-8836548815f1"
///    },
///    {
///      "name": "get-status",
///      "method": "GET",
///      "url": "https://api.sandbox.midtrans.com/v2/49b0eb2d-ac5e-4849-a142-b725a71edafc/status"
///    },
///    {
///      "name": "cancel",
///      "method": "POST",
///      "url": "https://api.sandbox.midtrans.com/v2/49b0eb2d-ac5e-4849-a142-b725a71edafc/cancel"
///    }
///  ]
///}
///```
@LazySingleton(as: IPaymentRepository, env: [DiEnvironment.dummy])
class DummyPaymentService implements IPaymentRepository {
  final Uuid uuid;
  final IOrderRepository orderRepository;

  DummyPaymentService(this.uuid, this.orderRepository);

  @override
  RepoResult<PaymentResultsModel> checkoutPayment(PaymentMethod method) async {
    try {
      if (method == PaymentMethod.PAYMENT_METHOD_GOPAY) {
        final orderId = uuid.v4();
        final resp = await http.post(
          Uri.parse('https://api.sandbox.midtrans.com/v2/charge'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Basic ${dotenv.get('MIDTRANS_SANDBOX_API_KEY', fallback: '')}'
          },
          body: jsonEncode({
            'payment_type': 'gopay',
            'transaction_details': {'order_id': orderId, 'gross_amount': 1000},
            'item_details': {
              'id': 'test-item-1',
              'price': 1000,
              'quantity': 1,
              'name': 'test-item'
            },
            'customer_details': {
              'first_name': 'Test',
              'last_name': 'Customer',
              'email': 'customer@test.com',
              'phone': '+82888888888'
            },
            'gopay': {
              'enable_callback': true,
              'callback_url': 'dropezy://storefront/order/gopay/finish'
            }
          }),
        );

        if (resp.statusCode == 200) {
          final data = jsonDecode(resp.body) as Map<String, dynamic>;

          if (data.containsKey('actions')) {
            final deepLink = (data['actions'] as List<dynamic>)
                .map((action) => action as Map<String, dynamic>)
                .firstWhere(
                  (action) => action['name'] == 'deeplink-redirect',
                )['url'] as String;

            final order = (await orderRepository.getOrderById('1')).getRight();
            orderRepository.addOrder(order.copyWith(id: orderId));

            return right(
              PaymentResultsModel(
                paymentMethod: PaymentMethod.PAYMENT_METHOD_GOPAY,
                paymentInformation: PaymentInformationModel(deeplink: deepLink),
                order: order,
                expiryTime: DateTime.now(),
              ),
            );
          }
        }
      }

      return left(PaymentMethodNotSupported(method));
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }

  @override
  RepoResult<List<PaymentMethodDetails>> getPaymentMethods() async {
    ///Simulate network wait
    await Future.delayed(const Duration(seconds: 1));

    final goPaymentChannel = PaymentChannel(
      paymentMethod: PaymentMethod.PAYMENT_METHOD_GOPAY,
      paymentType: PaymentMethodType.PAYMENT_METHOD_TYPE_DEEPLINK,
      status: PaymentMethodStatus.PAYMENT_METHOD_STATUS_ACTIVE,
    );

    final bcaPaymentChannel = PaymentChannel(
      paymentMethod: PaymentMethod.PAYMENT_METHOD_VA_BCA,
      paymentType: PaymentMethodType.PAYMENT_METHOD_TYPE_BANK_TRANSFER,
      status: PaymentMethodStatus.PAYMENT_METHOD_STATUS_ACTIVE,
    );

    return right([
      goPaymentChannel.paymentInfo(),
      bcaPaymentChannel.paymentInfo(),
    ]);
  }
}
