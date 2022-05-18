import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/models/repo_result.dart';
import 'package:storefront_app/features/product/domain/models/product_model.dart';

//import '../../../../di/di_environment.dart';
import '../../index.dart';

// TODO (Jonathan) : add env: [DiEnvironment.dummy] in gRPC ticket
@LazySingleton(as: IProductInventoryRepository)
class DummyProductInventoryRepository extends IProductInventoryRepository {
  static const productSeladaRomaine = ProductModel(
    productId: 'selada-romaine-id',
    sku: 'selada-romaine-sku',
    name: 'Selada Romaine',
    price: '15000',
    stock: 2,
    variants: [],
    defaultProduct: '',
    thumbnailUrl: 'https://pngimg.com/uploads/spinach/spinach_PNG65.png',
  );

  static const productSeledri = ProductModel(
    productId: 'seledri-id',
    sku: 'seledri-sku',
    name: 'Seledri',
    price: '150000',
    discount: '200000',
    stock: 20,
    variants: [],
    defaultProduct: '',
    thumbnailUrl: 'https://pngimg.com/uploads/celery/celery_PNG12.png',
  );

  final productsCategoryList = [
    // Sayuran Batang
    productSeledri.copyWith(id: '4'),
    productSeledri.copyWith(id: '4'),
    //Sayuran Bunga
    productSeledri.copyWith(id: '1'),
    productSeledri.copyWith(id: '1'),
    productSeladaRomaine.copyWith(id: '1'),
    productSeladaRomaine.copyWith(id: '1'),
    //Sayuran Bawang
    productSeladaRomaine.copyWith(id: '5'),
    productSeladaRomaine.copyWith(id: '5'),
    productSeledri.copyWith(id: '5'),
    productSeledri.copyWith(id: '5'),
    productSeladaRomaine.copyWith(id: '5'),
    productSeladaRomaine.copyWith(id: '5'),
    productSeledri.copyWith(id: '5'),
    productSeledri.copyWith(id: '5'),
  ];

  @override
  RepoResult<List<ProductModel>> getProductByCategory(String categoryId) async {
    await Future.delayed(const Duration(seconds: 1));
    return right(
      productsCategoryList
          .where((product) => product.id == categoryId)
          .toList(),
    );
  }
}
