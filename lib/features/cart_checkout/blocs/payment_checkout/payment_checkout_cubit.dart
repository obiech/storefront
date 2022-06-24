import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/res/strings/base_strings.dart';

import '../../../order/index.dart';
import '../../domain/domains.dart';

part 'payment_checkout_state.dart';

@injectable
class PaymentCheckoutCubit extends Cubit<PaymentCheckoutState> {
  final IPaymentRepository paymentRepository;
  final BaseStrings strings;

  PaymentCheckoutCubit(this.paymentRepository, this.strings)
      : super(InitialPaymentCheckoutState());

  /// Query [PaymentMethodDetails] end-point
  /// for checkout link
  Future<void> checkoutPayment(PaymentMethodDetails paymentMethod) async {
    emit(LoadingPaymentCheckout());

    final checkoutResponse =
        await paymentRepository.checkoutPayment(paymentMethod.method);

    emit(
      checkoutResponse.fold(
        (failure) {
          if (failure is PaymentMethodNotSupported) {
            return ErrorLoadingPaymentCheckout(failure.message, failure);
          }

          return ErrorLoadingPaymentCheckout(
            strings.errors.cartCheckout.errorCheckingOut,
            failure,
          );
        },
        (checkoutOrder) => LoadedPaymentCheckout(checkoutOrder),
      ),
    );
  }
}
