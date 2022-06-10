import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product/index.dart';

import '../../../../../test_commons/fixtures/product/product_models.dart';
import '../../../../commons.dart';

void main() {
  late ProductModel mockProduct;

  setUpAll(() {
    mockProduct = pomegranate;
    setUpLocaleInjection();
  });

  testWidgets(
      'should change product image in carousel '
      'and active dot position in [DotsIndicator] '
      'when swiped', (WidgetTester tester) async {
    /// arrange
    await tester.pumpProductDetailPageHeader(mockProduct);

    /// assert
    expect(find.byType(PageView), findsOneWidget);
    expect(find.byType(DotsIndicator), findsOneWidget);

    /// All image dots displayed
    final dotsIndicator = tester.firstWidget<DotsIndicator>(
      find.byType(DotsIndicator),
    );
    expect(dotsIndicator.dotsCount, mockProduct.imagesUrls.length);

    /// Test forward swipe
    for (int i = 0; i < mockProduct.imagesUrls.length; i++) {
      await tester.testPageViewSwipe(mockProduct, i, SwipeDirection.FORWARD);
    }

    /// Test backward swipe
    for (int i = mockProduct.imagesUrls.length - 1; i >= 0; i--) {
      await tester.testPageViewSwipe(mockProduct, i, SwipeDirection.REVERSE);
    }
  });

  testWidgets('should display market status badge',
      (WidgetTester tester) async {
    /// Flash Sale
    await tester.pumpProductDetailPageHeader(
      mockProduct.copyWith(marketStatus: MarketStatus.FLASH_SALE),
    );

    expect(find.byType(ProductBadge), findsOneWidget);

    var badge = tester.firstWidget<ProductBadge>(find.byType(ProductBadge));

    expect(badge.icon, DropezyIcons.flash);
    expect(badge.text, 'Flash Sale');

    /// Best Seller
    await tester.pumpProductDetailPageHeader(
      mockProduct.copyWith(marketStatus: MarketStatus.BEST_SELLER),
    );

    expect(find.byType(ProductBadge), findsOneWidget);

    badge = tester.firstWidget<ProductBadge>(find.byType(ProductBadge));

    expect(badge.icon, DropezyIcons.best_seller);
    expect(badge.text, 'Best Seller');
  });
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpProductDetailPageHeader(
    ProductModel productModel,
  ) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProductDetailPageHeader(
            product: productModel,
          ),
        ),
      ),
    );
  }

  /// Test PageView Swipe
  Future<void> testPageViewSwipe(
    ProductModel mockProduct,
    int index,
    SwipeDirection swipe,
  ) async {
    /// Check currently displayed image
    final carouselImage = firstWidget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );

    expect(carouselImage.imageUrl, mockProduct.imagesUrls[index]);

    /// Check active dot position
    final dotsIndicator = firstWidget<DotsIndicator>(
      find.byType(DotsIndicator),
    );

    expect(dotsIndicator.position, index);

    // Swipe PageView to next page
    final offset = swipe == SwipeDirection.FORWARD
        ? const Offset(-550.0, 0.0)
        : const Offset(550, 0.0);
    await drag(find.byType(PageView), offset);

    await pumpAndSettle();
  }
}

enum SwipeDirection { FORWARD, REVERSE }
