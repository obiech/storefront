import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/models/payment_method.dart';
import '../../domain/repository/i_payment_repository.dart';

part 'payment_checkout_state.dart';

@injectable
class PaymentCheckoutCubit extends Cubit<PaymentCheckoutState> {
  final IPaymentRepository paymentRepository;

  PaymentCheckoutCubit(this.paymentRepository)
      : super(InitialPaymentCheckoutState());

  /// Query [PaymentCheckout] end-point
  /// for checkout link
  Future<void> checkoutPayment(PaymentMethod method) async {
    emit(LoadingPaymentCheckout());

    try {
      final checkoutLink = await paymentRepository.checkoutPayment(method);
      emit(LoadedPaymentCheckout(checkoutLink));
    } catch (_) {
      emit(const ErrorLoadingPaymentCheckout('Error checking out'));
    }
  }
}
