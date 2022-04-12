part of 'cart_body_bloc.dart';

abstract class CartBodyState extends Equatable {
  const CartBodyState();

  @override
  List<Object?> get props => [];
}

class CartBodyStarted extends CartBodyState {
  const CartBodyStarted();
}

class CartBodyLoading extends CartBodyState {
  const CartBodyLoading();
}

class CartBodyFailed extends CartBodyState {
  const CartBodyFailed(this.exception);

  final Exception exception;

  @override
  List<Object?> get props => [exception];
}

class CartSummaryLoaded extends CartBodyState {
  const CartSummaryLoaded(this.summary);

  final CartPaymentSummaryModel summary;

  @override
  List<Object?> get props => [summary];
}
