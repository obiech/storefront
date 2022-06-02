import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/models/repo_result.dart';

import '../../../../di/di_environment.dart';
import '../../../product/index.dart';
import '../../index.dart';

@LazySingleton(as: IProductInventoryRepository, env: [DiEnvironment.dummy])
class DummyProductInventoryRepository extends IProductInventoryRepository {
  static const productTehBotol = ProductModel(
    productId: 'teh-botol-sosro-original',
    sku: 'SKUTBS002',
    name: 'Teh Botol Sosro Original',
    price: '3200',
    stock: 50,
    variants: [
      VariantModel(
        variantId: '0-variant-id',
        name: '250ml / Pcs',
        defaultImageUrl: 'https://i.imgur.com/rHfndKT.jpeg',
        imagesUrls: [
          'https://i.imgur.com/rHfndKT.jpeg',
        ],
        price: '3200',
        sku: 'SKUTBS002',
        stock: 15,
        unit: '250ml / Pcs',
      ),
      VariantModel(
        variantId: '1-variant-id',
        name: '330ml / Pcs',
        defaultImageUrl: 'https://i.imgur.com/JxNPDNU.jpeg',
        imagesUrls: [
          'https://i.imgur.com/JxNPDNU.jpeg',
        ],
        price: '3500',
        sku: 'SKUTBS003',
        stock: 15,
        unit: '330ml / Pcs',
      ),
      VariantModel(
        variantId: '2-variant-id',
        name: '450ml / Botol',
        defaultImageUrl: 'https://i.imgur.com/3hGn49J.jpeg',
        imagesUrls: [
          'https://i.imgur.com/3hGn49J.jpeg',
        ],
        price: '6000',
        sku: 'SKUTBS001',
        stock: 15,
        unit: '450ml / Botol',
      ),
    ],
    defaultProduct: '0-variant-id',
    unit: '250ml / Pcs',
    description:
        'Teh Botol Sosro Original Kotak dihasilkan dari daun teh dengan kualitas terbaik dengan cita rasa dan aroma jasmine yang khas',
    thumbnailUrl: 'https://i.imgur.com/rHfndKT.jpeg',
    imagesUrls: [
      'https://i.imgur.com/rHfndKT.jpeg',
      'https://i.imgur.com/JxNPDNU.jpeg',
      'https://i.imgur.com/3hGn49J.jpeg'
    ],
  );

  static const productKacangHijau = ProductModel(
    productId: 'ultra-milk-sari-kacang-hijau',
    sku: 'SKU0360',
    name: 'Ultra Milk Sari Kacang Hijau',
    price: '3900',
    stock: 50,
    variants: [
      VariantModel(
        variantId: '0-variant-id',
        name: '250ml / Pcs',
        defaultImageUrl: 'https://i.imgur.com/h31ZPb2.jpeg',
        imagesUrls: [
          'https://i.imgur.com/h31ZPb2.jpeg',
        ],
        price: '3900',
        sku: 'SKU0360',
        stock: 15,
        unit: '250ml / Pcs',
      ),
    ],
    defaultProduct: '0-variant-id',
    unit: '250ml / Pcs',
    description:
        'Ultra sari kacang hijau minuman sari kacang hijau siap minum.',
    thumbnailUrl: 'https://i.imgur.com/h31ZPb2.jpeg',
    imagesUrls: ['https://i.imgur.com/h31ZPb2.jpeg'],
  );

  final productsCategoryList = [
    // Sayuran Batang
    productKacangHijau.copyWith(id: '4'),
    productKacangHijau.copyWith(id: '4'),
    //Sayuran Bunga
    productKacangHijau.copyWith(id: '1'),
    productKacangHijau.copyWith(id: '1'),
    productTehBotol.copyWith(id: '1'),
    productTehBotol.copyWith(id: '1'),
    //Sayuran Bawang
    productTehBotol.copyWith(id: '5'),
    productTehBotol.copyWith(id: '5'),
    productKacangHijau.copyWith(id: '5'),
    productKacangHijau.copyWith(id: '5'),
    productTehBotol.copyWith(id: '5'),
    productTehBotol.copyWith(id: '5'),
    productKacangHijau.copyWith(id: '5'),
    productKacangHijau.copyWith(id: '5'),
  ];

  @override
  RepoResult<List<ProductModel>> getProductByCategory(
    String storeId,
    String categoryId,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return right(
      productsCategoryList
          .where((product) => product.id == categoryId)
          .toList(),
    );
  }
}
