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
      productId: 'abcd',
      name: 'milkuat cokelat malt uht 115ml  pcs',
      brand: 'milkuat',
      sku: 'sku0961',
      imageUrl: 'milkuatcokelatmaltuht115mlpcs.jpg',
      storeId: 'store_11',
      stock: 0,
    );

    final product = response.toProduct;

    expect(product.status, ProductStatus.OUT_OF_STOCK);
  });
}
