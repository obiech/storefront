import 'package:dropezy_proto/v1/search/search.pbgrpc.dart';
import 'package:injectable/injectable.dart';

import '../../../product/index.dart';
import '../repository/i_product_search_repository.dart';

@LazySingleton(as: IProductSearchRepository)
class ProductSearchService implements IProductSearchRepository {
  final SearchServiceClient searchService;

  ProductSearchService(this.searchService);

  final autoSuggestionSize = 10;

  @override
  Future<List<String>> getSearchSuggestions(
    String query, {
    int limit = 5,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    //TODO - Restore backend service
    // final _result = await searchService.autocompleteInventory(
    //   AutocompleteInventoryRequest(query: query, size: autoSuggestionSize),
    // );
    //
    // return _result.suggestions;
    return [
      'Beanos',
      'Red Beans',
      'White Beans',
      'Green Beans',
      'Coffee Beans'
    ];
  }

  @override
  Future<List<ProductModel>> searchInventoryForItems(
    String query, {
    int page = 0,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    // //TODO - Restore backend service
    // final _result = await searchService.searchInventory(
    //   SearchInventoryRequest(
    //     query: query,
    //     pageCurrent: page,
    //     pageSize: inventorySize,
    //   ),
    // );
    //
    // return _result.results.toModel;
    return const [
      ProductModel(
        productId: 'selada-romaine-id',
        sku: 'selada-romaine-sku',
        name: 'Selada Romaine',
        price: '15000',
        discount: '20000',
        stock: 2,
        thumbnailUrl:
            'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png',
      ),
      ProductModel(
        productId: 'mango-id',
        sku: 'mango-sku',
        name: 'Sweet Mangoes',
        price: '30000',
        stock: 15,
        marketStatus: MarketStatus.FLASH_SALE,
        thumbnailUrl:
            'https://png2.cleanpng.com/sh/7680fbe8a6c4a90575503c3f3feefe81/L0KzQYm3WMIyN5p1g5H0aYP2gLBuTgBweqVmet5uLX7ohMj2kvsub6NmiNpyY4OwhMPojwNxaaNqhtVELXPvecG0ggJ1NZpyRd9qbnfyPcX5gf50eJJ3fdD9LXbsfLa0kP5oNZ9mhdd8LUXlR7S5VPM5PpY3UaYCLkK8Q4SBV8Y2OWY4TKoBMkW2RoW8UcIveJ9s/kisspng-portable-network-graphics-transparency-clip-art-im-mango-transparent-file-png-names-5b7c24c86e2947.2933876515348625364512.png',
      ),
      ProductModel(
        productId: 'irish-id',
        sku: 'irish-sku',
        name: 'Irish Potatoes',
        price: '10000',
        stock: 50,
        marketStatus: MarketStatus.BEST_SELLER,
        thumbnailUrl:
            'https://png2.cleanpng.com/sh/d8c9fc6388c317dea186dbeeefcc18a0/L0KzQYm3WcI2N6lBgpH0aYP2gLBuTfZzbZ9ogJ9vcnnog373jCRifJCyjtdwZYTkgrrojr1kfZp4gdDuLXnxdLroTgZmb5Z5ReJ4dHH3f7b6TcVjaZI3ftM6M0e2RLa3TsQzQWQ4Sqs8MUW2R4mAWck3QWM3TqM3cH7q/kisspng-french-fries-potato-vegetarian-cuisine-india-veget-potatoes-5baa2fa13734e0.4293329315378799692261.png',
      )
    ];
  }
}
