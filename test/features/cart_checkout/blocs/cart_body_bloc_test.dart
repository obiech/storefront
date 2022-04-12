import 'package:bloc_test/bloc_test.dart';
import 'package:dropezy_proto/v1/cart/cart.pb.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

void main() {
  group('[CartBodyBloc]', () {
    late CartBodyBloc _bloc;

    final _summaryRequest = SummaryRequest(storeId: '1');
    final _cartService = CartService();

    late CartPaymentSummaryModel _summary;

    setUp(() async {
      _bloc = CartBodyBloc(_cartService);

      _summary = await _cartService.summary(_summaryRequest);
    });

    test('should have [CartBodyStarted] on start', () async {
      expect(_bloc.state is CartBodyStarted, true);
    });

    blocTest<CartBodyBloc, CartBodyState>(
      'When OnLoadCartBody event triggered '
      'should get the cart summary',
      // setUp: () {},
      build: () => _bloc,
      act: (bloc) => bloc.add(OnLoadCartBody(_summaryRequest)),
      expect: () {
        return [isA<CartBodyLoading>(), CartSummaryLoaded(_summary)];
      },
    );
  });
}
