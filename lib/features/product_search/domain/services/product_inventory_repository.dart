import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/inventory/inventory.pbgrpc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';

import '../../../../di/di_environment.dart';
import '../../../product/index.dart';
import '../../index.dart';

/// Repository for fetching inventories product from storefront-backend
/// using gRPC connection.
@LazySingleton(as: IProductInventoryRepository, env: DiEnvironment.grpcEnvs)
class ProductInventoryRepository extends IProductInventoryRepository {
  ProductInventoryRepository(this._inventoryServiceClient);

  final InventoryServiceClient _inventoryServiceClient;

  @override
  RepoResult<List<ProductModel>> getProductByCategory(
    String storeId,
    String categoryId,
  ) async {
    try {
      final response = await _inventoryServiceClient.get(
        GetRequest(
          storeId: storeId,
          categoryId: categoryId,
        ),
      );

      final List<ProductModel> _productResult = [];

      for (final inventory in response.inventories) {
        final products = inventory.products.map(ProductModel.fromPb).toList();
        _productResult.addAll(products);
      }

      return right(_productResult);
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }
}
