import 'package:dropezy_proto/v1/cart/cart.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../index.dart';

part 'cart_body_event.dart';
part 'cart_body_state.dart';

@injectable
class CartBodyBloc extends Bloc<CartBodyEvent, CartBodyState> {
  CartBodyBloc(this.cartRepository) : super(const CartBodyStarted()) {
    on<OnLoadCartBody>((event, emit) async {
      emit(const CartBodyLoading());
      try {
        final response = await cartRepository.summary(event.request);
        if (!isClosed) emit(CartSummaryLoaded(response));
      } on Exception catch (e, _) {
        if (!isClosed) emit(CartBodyFailed(e));
      }
    });
  }

  final ICartRepository cartRepository;
}
