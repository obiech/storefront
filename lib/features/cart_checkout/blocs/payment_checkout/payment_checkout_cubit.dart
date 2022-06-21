import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../order/index.dart';
import '../../domain/domains.dart';

part 'payment_checkout_state.dart';

@injectable
class PaymentCheckoutCubit extends Cubit<PaymentCheckoutState> {
  final IPaymentRepository paymentRepository;

  PaymentCheckoutCubit(this.paymentRepository)
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
            return const ErrorLoadingPaymentCheckout(
              'Payment method not supported',
            );
          }

          return const ErrorLoadingPaymentCheckout('Error checking out');
        },
        (checkoutOrder) => LoadedPaymentCheckout(checkoutOrder),
      ),
    );
  }
}
