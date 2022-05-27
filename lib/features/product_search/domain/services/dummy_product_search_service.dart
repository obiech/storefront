import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/di_environment.dart';

import '../../../product/index.dart';
import '../../index.dart';

@LazySingleton(as: IProductSearchRepository, env: [DiEnvironment.dummy])
class DummyProductSearchService implements IProductSearchRepository {
  DummyProductSearchService();

  @override
  RepoResult<List<String>> getSearchSuggestions(
    String query, {
    int limit = 3,
  }) async {
    // Simulate network wait
    await Future.delayed(const Duration(seconds: 1));

    return right(
      ['Beanos', 'Red Beans', 'White Beans', 'Green Beans', 'Coffee Beans']
          .take(limit)
          .toList(),
    );
  }

  @override
  RepoResult<List<ProductModel>> searchInventoryForItems(
    String query, {
    int page = 0,
    int limit = 10,
  }) async {
    // Simulate network wait
    await Future.delayed(const Duration(seconds: 1));

    return right(
      _dummyInventory.skip(page * limit).take(limit).toList(),
    );
  }
}

const _dummyInventory = [
  ProductModel(
    productId: 'selada-romaine-id',
    sku: 'selada-romaine-sku',
    name: 'Selada Romaine',
    discount: '20000',
    price: '30000',
    stock: 2,
    thumbnailUrl:
        'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png',
    imagesUrls: [
      'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png'
    ],
    defaultProduct: 'selada-romaine-variant-id',
    unit: '500g',
    variants: [
      VariantModel(
        variantId: 'selada-romaine-variant-id',
        name: 'Selada Romaine',
        imagesUrls: [
          'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png'
        ],
        defaultImageUrl:
            'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png',
        price: '30000',
        sku: 'selada-romaine-sku',
        stock: 2,
        unit: '500g',
      ),
      VariantModel(
        variantId: 'selada-romaine-variant-2-id',
        name: 'Selada Romaine 2',
        imagesUrls: [
          'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png'
        ],
        defaultImageUrl:
            'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png',
        price: '35000',
        sku: 'selada-romaine-2-sku',
        stock: 0,
        unit: '500g',
      ),
    ],
  ),
  ProductModel(
    productId: 'mango-id',
    sku: 'mango-sku',
    name: 'Sweet Mangoes',
    price: '30000',
    stock: 15,
    defaultProduct: 'mango-variant-id',
    unit: '500g',
    marketStatus: MarketStatus.FLASH_SALE,
    variants: [
      VariantModel(
        variantId: 'mango-variant-id',
        name: 'Sweet Mangoes',
        defaultImageUrl:
            'https://png2.cleanpng.com/sh/7680fbe8a6c4a90575503c3f3feefe81/L0KzQYm3WMIyN5p1g5H0aYP2gLBuTgBweqVmet5uLX7ohMj2kvsub6NmiNpyY4OwhMPojwNxaaNqhtVELXPvecG0ggJ1NZpyRd9qbnfyPcX5gf50eJJ3fdD9LXbsfLa0kP5oNZ9mhdd8LUXlR7S5VPM5PpY3UaYCLkK8Q4SBV8Y2OWY4TKoBMkW2RoW8UcIveJ9s/kisspng-portable-network-graphics-transparency-clip-art-im-mango-transparent-file-png-names-5b7c24c86e2947.2933876515348625364512.png',
        imagesUrls: [
          'https://png2.cleanpng.com/sh/7680fbe8a6c4a90575503c3f3feefe81/L0KzQYm3WMIyN5p1g5H0aYP2gLBuTgBweqVmet5uLX7ohMj2kvsub6NmiNpyY4OwhMPojwNxaaNqhtVELXPvecG0ggJ1NZpyRd9qbnfyPcX5gf50eJJ3fdD9LXbsfLa0kP5oNZ9mhdd8LUXlR7S5VPM5PpY3UaYCLkK8Q4SBV8Y2OWY4TKoBMkW2RoW8UcIveJ9s/kisspng-portable-network-graphics-transparency-clip-art-im-mango-transparent-file-png-names-5b7c24c86e2947.2933876515348625364512.png'
        ],
        price: '30000',
        sku: 'mango-variant-sku',
        stock: 15,
        unit: '500g',
      )
    ],
    thumbnailUrl:
        'https://png2.cleanpng.com/sh/7680fbe8a6c4a90575503c3f3feefe81/L0KzQYm3WMIyN5p1g5H0aYP2gLBuTgBweqVmet5uLX7ohMj2kvsub6NmiNpyY4OwhMPojwNxaaNqhtVELXPvecG0ggJ1NZpyRd9qbnfyPcX5gf50eJJ3fdD9LXbsfLa0kP5oNZ9mhdd8LUXlR7S5VPM5PpY3UaYCLkK8Q4SBV8Y2OWY4TKoBMkW2RoW8UcIveJ9s/kisspng-portable-network-graphics-transparency-clip-art-im-mango-transparent-file-png-names-5b7c24c86e2947.2933876515348625364512.png',
    imagesUrls: [
      'https://png2.cleanpng.com/sh/7680fbe8a6c4a90575503c3f3feefe81/L0KzQYm3WMIyN5p1g5H0aYP2gLBuTgBweqVmet5uLX7ohMj2kvsub6NmiNpyY4OwhMPojwNxaaNqhtVELXPvecG0ggJ1NZpyRd9qbnfyPcX5gf50eJJ3fdD9LXbsfLa0kP5oNZ9mhdd8LUXlR7S5VPM5PpY3UaYCLkK8Q4SBV8Y2OWY4TKoBMkW2RoW8UcIveJ9s/kisspng-portable-network-graphics-transparency-clip-art-im-mango-transparent-file-png-names-5b7c24c86e2947.2933876515348625364512.png'
    ],
  ),
  ProductModel(
    productId: 'pomegrate-id',
    sku: 'pomegrate-sku',
    name: 'Pomegranate Red',
    price: '30000',
    stock: 15,
    defaultProduct: 'pomegranate-variant-id',
    unit: '500g',
    marketStatus: MarketStatus.FLASH_SALE,
    variants: [
      VariantModel(
        variantId: 'pomegranate-500g-variant-id',
        name: '500g',
        defaultImageUrl: 'https://source.unsplash.com/XiWQbLEhFyo/600x600',
        imagesUrls: [
          'https://source.unsplash.com/XiWQbLEhFyo/600x600',
          'https://source.unsplash.com/haSJEJYzl5A/600x600',
        ],
        price: '30000',
        sku: 'pomegranate-variant-sku',
        stock: 15,
        unit: '500g',
      ),
      VariantModel(
        variantId: 'pomegranate-1kg-variant-id',
        name: '1kg',
        defaultImageUrl: 'https://source.unsplash.com/XiWQbLEhFyo/600x600',
        imagesUrls: ['https://source.unsplash.com/XiWQbLEhFyo/600x600'],
        price: '30000',
        sku: 'pomegranate-1kg-variant-sku',
        stock: 12,
        unit: '1kg',
      )
    ],
    thumbnailUrl: 'https://source.unsplash.com/XiWQbLEhFyo/600x600',
    imagesUrls: [
      'https://source.unsplash.com/XiWQbLEhFyo/600x600',
      'https://source.unsplash.com/haSJEJYzl5A/600x600',
      'https://source.unsplash.com/rxN2MRdFJVg/600x600',
      'https://source.unsplash.com/JbnUwSe7XuE/600x600',
    ],
  ),
  ProductModel(
    productId: 'irish-id',
    sku: 'irish-sku',
    name: 'Irish Potatoes',
    price: '10000',
    variants: [],
    defaultProduct: '',
    unit: '500g',
    stock: 50,
    status: ProductStatus.OUT_OF_STOCK,
    marketStatus: MarketStatus.BEST_SELLER,
    thumbnailUrl:
        'https://png2.cleanpng.com/sh/d8c9fc6388c317dea186dbeeefcc18a0/L0KzQYm3WcI2N6lBgpH0aYP2gLBuTfZzbZ9ogJ9vcnnog373jCRifJCyjtdwZYTkgrrojr1kfZp4gdDuLXnxdLroTgZmb5Z5ReJ4dHH3f7b6TcVjaZI3ftM6M0e2RLa3TsQzQWQ4Sqs8MUW2R4mAWck3QWM3TqM3cH7q/kisspng-french-fries-potato-vegetarian-cuisine-india-veget-potatoes-5baa2fa13734e0.4293329315378799692261.png',
    imagesUrls: [
      'https://png2.cleanpng.com/sh/d8c9fc6388c317dea186dbeeefcc18a0/L0KzQYm3WcI2N6lBgpH0aYP2gLBuTfZzbZ9ogJ9vcnnog373jCRifJCyjtdwZYTkgrrojr1kfZp4gdDuLXnxdLroTgZmb5Z5ReJ4dHH3f7b6TcVjaZI3ftM6M0e2RLa3TsQzQWQ4Sqs8MUW2R4mAWck3QWM3TqM3cH7q/kisspng-french-fries-potato-vegetarian-cuisine-india-veget-potatoes-5baa2fa13734e0.4293329315378799692261.png'
    ],
  ),
  ProductModel(
    productId: 'sweet-pepper-id',
    sku: 'sweet-pepper-sku',
    name: 'Sweet Pepper',
    price: '15000',
    discount: '20000',
    variants: [],
    defaultProduct: '',
    unit: '500g',
    stock: 2,
    thumbnailUrl:
        'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png',
    imagesUrls: [
      'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png'
    ],
  ),
  ProductModel(
    productId: 'sweet-pepper-yellow-id',
    sku: 'sweet-pepper-yellow-sku',
    name: 'Sweet Pepper',
    price: '15000',
    discount: '20000',
    stock: 2,
    variants: [],
    defaultProduct: '',
    unit: '500g',
    thumbnailUrl:
        'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png',
    imagesUrls: [
      'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png'
    ],
  ),
  ProductModel(
    productId: 'sweet-pepper-red-id',
    sku: 'sweet-pepper-red-sku',
    name: 'Sweet Pepper(Red)',
    price: '15000',
    discount: '20000',
    stock: 2,
    variants: [],
    defaultProduct: '',
    unit: '500g',
    thumbnailUrl:
        'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png',
    imagesUrls: [
      'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png'
    ],
  ),
  ProductModel(
    productId: 'irish-id-1',
    sku: 'irish-sku-1',
    name: 'Irish Potatoes',
    price: '10000',
    stock: 50,
    variants: [],
    defaultProduct: '',
    unit: '500g',
    marketStatus: MarketStatus.BEST_SELLER,
    thumbnailUrl:
        'https://png2.cleanpng.com/sh/d8c9fc6388c317dea186dbeeefcc18a0/L0KzQYm3WcI2N6lBgpH0aYP2gLBuTfZzbZ9ogJ9vcnnog373jCRifJCyjtdwZYTkgrrojr1kfZp4gdDuLXnxdLroTgZmb5Z5ReJ4dHH3f7b6TcVjaZI3ftM6M0e2RLa3TsQzQWQ4Sqs8MUW2R4mAWck3QWM3TqM3cH7q/kisspng-french-fries-potato-vegetarian-cuisine-india-veget-potatoes-5baa2fa13734e0.4293329315378799692261.png',
    imagesUrls: [
      'https://png2.cleanpng.com/sh/d8c9fc6388c317dea186dbeeefcc18a0/L0KzQYm3WcI2N6lBgpH0aYP2gLBuTfZzbZ9ogJ9vcnnog373jCRifJCyjtdwZYTkgrrojr1kfZp4gdDuLXnxdLroTgZmb5Z5ReJ4dHH3f7b6TcVjaZI3ftM6M0e2RLa3TsQzQWQ4Sqs8MUW2R4mAWck3QWM3TqM3cH7q/kisspng-french-fries-potato-vegetarian-cuisine-india-veget-potatoes-5baa2fa13734e0.4293329315378799692261.png'
    ],
  ),
  ProductModel(
    productId: 'sweet-pepper-id-1',
    sku: 'sweet-pepper-sku-1',
    name: 'Sweet Pepper',
    price: '15000',
    discount: '20000',
    stock: 2,
    variants: [],
    defaultProduct: '',
    unit: '500g',
    thumbnailUrl:
        'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png',
    imagesUrls: [
      'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png'
    ],
  ),
  ProductModel(
    productId: 'sweet-pepper-yellow-id-1',
    sku: 'sweet-pepper-yellow-sku-1',
    name: 'Sweet Pepper',
    price: '15000',
    discount: '20000',
    stock: 2,
    variants: [],
    defaultProduct: '',
    unit: '500g',
    thumbnailUrl:
        'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png',
    imagesUrls: [
      'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png'
    ],
  ),
  ProductModel(
    productId: 'sweet-pepper-red-id-1',
    sku: 'sweet-pepper-red-sku-1',
    name: 'Sweet Pepper(Red)',
    price: '15000',
    discount: '20000',
    stock: 2,
    variants: [],
    defaultProduct: '',
    unit: '500g',
    thumbnailUrl:
        'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png',
    imagesUrls: [
      'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png'
    ],
  ),
];
