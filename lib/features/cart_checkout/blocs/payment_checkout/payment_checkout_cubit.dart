import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

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

    try {
      final checkoutLink =
          await paymentRepository.checkoutPayment(paymentMethod.method);
      emit(LoadedPaymentCheckout(checkoutLink));
    } catch (_) {
      emit(const ErrorLoadingPaymentCheckout('Error checking out'));
    }
  }
}
