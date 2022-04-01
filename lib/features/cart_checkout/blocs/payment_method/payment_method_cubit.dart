import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/models/payment_method.dart';
import '../../domain/repository/i_payment_method_repository.dart';

part 'payment_method_state.dart';

@lazySingleton
class PaymentMethodCubit extends Cubit<PaymentMethodState> {
  final IPaymentMethodRepository paymentMethodRepository;

  PaymentMethodCubit(this.paymentMethodRepository) : super(InitialState()) {
    queryPaymentMethods();
  }

  /// Query [PaymentMethod]s from cache or end-point
  Future<void> queryPaymentMethods() async {
    emit(LoadingPaymentMethods());

    try {
      final methods = await paymentMethodRepository.getPaymentMethods();
      if (methods.isNotEmpty) {
        emit(LoadedPaymentMethods(methods, methods.first));
      } else {
        emit(const ErrorLoadingPaymentMethods('No Payment Methods'));
      }
    } catch (_) {
      emit(const ErrorLoadingPaymentMethods('Error loading payment methods'));
    }
  }

  /// Set the active [PaymentMethod]
  void setPaymentMethod(PaymentMethod paymentMethod) {
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
