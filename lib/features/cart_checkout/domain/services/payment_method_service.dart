import 'package:injectable/injectable.dart';
import 'package:storefront_app/features/cart_checkout/domain/models/payment_method.dart';
import 'package:storefront_app/features/cart_checkout/domain/models/payment_method_type.dart';
import 'package:storefront_app/features/cart_checkout/domain/repository/i_payment_method_repository.dart';

@LazySingleton(as: IPaymentMethodRepository)
class PaymentMethodService implements IPaymentMethodRepository {
  @override
  Future<List<PaymentMethod>> getPaymentMethods() async {
    // TODO: query Payment Methods via grpc
    return const [
      PaymentMethod(
        title: 'Go Pay',
        tag: 'go_pay',
        image: 'assets/icons/providers/go_pay.png',
        link: 'gopay.com',
        type: PaymentMethodType.EWallet,
      ),
      PaymentMethod(
        title: 'OVO',
        tag: 'ovo',
        image: 'assets/icons/providers/ovo.png',
        link: 'ovo.com',
        type: PaymentMethodType.EWallet,
      ),
      PaymentMethod(
        title: 'DANA',
        tag: 'dana',
        image: 'assets/icons/providers/dana.png',
        link: 'ovo.com',
        type: PaymentMethodType.EWallet,
      ),
      PaymentMethod(
        title: 'ShopeePay',
        tag: 'shopee_pay',
        image: 'assets/icons/providers/shopeepay.png',
        link: 'shopeepay.com',
        type: PaymentMethodType.EWallet,
      )
    ];
  }
}
