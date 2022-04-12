part of 'cart_body_bloc.dart';

abstract class CartBodyEvent {
  const CartBodyEvent();
}

class OnStartCartBody extends CartBodyEvent {
  const OnStartCartBody();
}

class OnLoadCartBody extends CartBodyEvent {
  const OnLoadCartBody(this.request);

  final SummaryRequest request;
}
