import 'package:dropezy_proto/meta/meta.pb.dart';
import 'package:dropezy_proto/v1/cart/cart.pb.dart';
import 'package:dropezy_proto/v1/payment/payment.pb.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

@LazySingleton(as: ICartRepository)
class CartService implements ICartRepository {
  @override
  Future<AddResponse> add(AddRequest request) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<CartPaymentSummaryModel> summary(SummaryRequest request) async {
    final _dummySummary = CartPaymentSummaryModel.fromPB(
      PaymentSummary(
        subtotal: Amount(num: '10300000', cur: Currency.CURRENCY_IDR),
        deliveryFee: Amount(num: '700000', cur: Currency.CURRENCY_IDR),
        discount: Amount(num: '1300000', cur: Currency.CURRENCY_IDR),
        total: Amount(num: '4300000', cur: Currency.CURRENCY_IDR),
      ),
    );

    return _dummySummary;
  }

  @override
  Future<UpdateResponse> update(UpdateRequest method) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
