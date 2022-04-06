import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domains.dart';

part 'payment_method_state.dart';

@injectable
class PaymentMethodCubit extends Cubit<PaymentMethodState> {
  final IPaymentRepository paymentMethodRepository;

  PaymentMethodCubit(this.paymentMethodRepository)
      : super(InitialPaymentMethodState()) {
    queryPaymentMethods();
  }

  /// Query [PaymentMethodDetails]s from cache or end-point
  Future<void> queryPaymentMethods() async {
    emit(LoadingPaymentMethods());

    try {
      final methods = await paymentMethodRepository.getPaymentMethods();
      if (methods.isNotEmpty) {
        final paymentMethods = methods.toPaymentDetails();
        emit(LoadedPaymentMethods(paymentMethods, paymentMethods.first));
      } else {
        emit(const ErrorLoadingPaymentMethods('No Payment Methods'));
      }
    } catch (_) {
      emit(const ErrorLoadingPaymentMethods('Error loading payment methods'));
    }
  }

  /// Set the active [PaymentMethodDetails]
  void setPaymentMethod(PaymentMethodDetails paymentMethod) {
    if (state is LoadedPaymentMethods) {
      emit(
        LoadedPaymentMethods(
          (state as LoadedPaymentMethods).methods,
          paymentMethod,
        ),
      );
    }
  }
}
