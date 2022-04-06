import 'dart:convert';

import 'package:dropezy_proto/v1/order/order.pbgrpc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../domains.dart';

@LazySingleton(as: IPaymentRepository)
class PaymentService implements IPaymentRepository {
  final Uuid uuid;
  final OrderServiceClient orderServiceClient;

  PaymentService(this.uuid, this.orderServiceClient);

  @override
  Future<List<PaymentChannel>> getPaymentMethods() async {
    final paymentMethods = await orderServiceClient
        .getAvailablePaymentMethod(GetAvailablePaymentMethodRequest());

    return paymentMethods.paymentMethods
        .where(
          (channel) =>
              channel.status ==
              PaymentMethodStatus.PAYMENT_METHOD_STATUS_ACTIVE,
        )
        .toList();
  }

  @override
  Future<String> checkoutPayment(PaymentMethod method) async {
    if (method == PaymentMethod.PAYMENT_METHOD_GOPAY) {
      // TODO - Replace with grpc call for checkout
      final resp = await http.post(
        Uri.parse('https://api.sandbox.midtrans.com/v2/charge'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${dotenv.get('MIDTRANS_SANDBOX_API_KEY', fallback: '')}'
        },
        body: jsonEncode({
          'payment_type': 'gopay',
          'transaction_details': {'order_id': uuid.v4(), 'gross_amount': 1000},
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

          return deepLink;
        }
      }
    }

    throw Exception('Could not complete payment');
  }
}
