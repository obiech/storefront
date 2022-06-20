import 'package:dropezy_proto/v1/inventory/inventory.pb.dart';
import 'package:dropezy_proto/v1/search/search.pb.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/product/domain/domain.dart';
import 'package:storefront_app/features/product_search/index.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'env/.env');

  test('should mark item as out of stock if stock is zero', () async {
    /// assert
    final response = SearchInventoryResult(
      productId: 'product-id',
      name: 'milkuat cokelat malt uht 115ml  pcs',
      brandName: 'milkuat',
      description: 'Dummy description',
      storeId: 'store_11',
      variants: [
        Variant(
          variantId: 'variant-id',
          imagesUrls: ['milkuatcokelatmaltuht115mlpcs.jpg'],
          variantQuantifier: 'ml',
          variantValue: '500 ml',
          name: '500 ml',
          sku: 'sku-000',
          stock: 0,
        )
      ],
    );

    final product = response.toProduct;

    expect(product.status, ProductModelStatus.OUT_OF_STOCK);
  });
}
