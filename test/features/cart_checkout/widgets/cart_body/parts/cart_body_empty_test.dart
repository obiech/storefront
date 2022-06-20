import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

import '../../../../../../test_commons/finders/cart/cart_body_empty_finders.dart';
import '../../../../../commons.dart';
import '../../../../../src/mock_navigator.dart';

void main() {
  late StackRouter router;

  setUp(() {
    router = MockStackRouter();
    when(() => router.popUntilRoot()).thenAnswer((_) async {});
  });

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
    setUpLocaleInjection();
  });

  group(
    '[CartBodyEmpty]',
    () {
      testWidgets(
        'should display necessary widgets',
        (tester) async {
          // act
          final context = await tester.pumpCartBodyEmpty(router);

          // assert
          // should find an image asset for empty cart
          final assetImage =
              tester.firstWidget<SvgPicture>(CartBodyEmptyFinders.imageAsset);
          expect(assetImage.pictureProvider, isA<ExactAssetPicture>());
          expect(
            (assetImage.pictureProvider as ExactAssetPicture).assetName,
            context.res.paths.imageCart,
          );

          // should find title & caption for empty cart
          expect(find.text(context.res.strings.emptyCartTitle), findsOneWidget);
          expect(
            find.text(context.res.strings.emptyCartCaption),
            findsOneWidget,
          );

          // should find button to Home
          expect(CartBodyEmptyFinders.buttonShopNow, findsOneWidget);
          expect(
            find.descendant(
              of: CartBodyEmptyFinders.buttonShopNow,
              matching: find.text(context.res.strings.shopNow),
            ),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'should pop until root page (Main Page) '
        'when button Shop Now is tapped',
        (tester) async {
          // act
          await tester.pumpCartBodyEmpty(router);
          await tester.tap(CartBodyEmptyFinders.buttonShopNow);

          // assert
          verify(() => router.popUntilRoot()).called(1);
        },
      );
    },
  );
}

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpCartBodyEmpty([StackRouter? router]) async {
    late BuildContext ctx;
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              ctx = context;
              return const CartBodyEmpty();
            },
          ),
        ),
      ).withRouterScope(router),
    );

    return ctx;
  }
}
