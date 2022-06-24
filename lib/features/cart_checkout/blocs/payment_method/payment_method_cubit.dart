import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domains.dart';

part 'payment_method_state.dart';

@lazySingleton
class PaymentMethodCubit extends Cubit<PaymentMethodState> {
  final IPaymentRepository paymentMethodRepository;

  PaymentMethodCubit(this.paymentMethodRepository)
      : super(InitialPaymentMethodState());

  /// Query [PaymentMethodDetails]s from cache or end-point
  Future<void> queryPaymentMethods() async {
    if (state is LoadedPaymentMethods) return;

    emit(LoadingPaymentMethods());

    final paymentMethodsResponse =
        await paymentMethodRepository.getPaymentMethods();

    final paymentMethodState = paymentMethodsResponse.fold(
      (failure) {
        if (failure is NoPaymentMethods) {
          return const ErrorLoadingPaymentMethods('No Payment Methods');
        }

        return const ErrorLoadingPaymentMethods(
          'Error loading payment methods',
        );
      },
      (paymentMethods) =>
          LoadedPaymentMethods(paymentMethods, paymentMethods.first),
    );

    emit(paymentMethodState);
  }

  /// Set the active [PaymentMethodDetails]
  void setPaymentMethod(PaymentMethodDetails paymentMethod) {
    if (state is! LoadedPaymentMethods) return;

    emit(
      (state as LoadedPaymentMethods)
          .copyWith(activePaymentMethod: paymentMethod),
    );
  }
}
