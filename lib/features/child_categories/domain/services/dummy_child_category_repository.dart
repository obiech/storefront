import '../../../home/domain/models/category_model.dart';

/// Dummy [DummyChildCategoryRepository].
///
/// Returns data for development purposes, hardcoded in class definition.
/// WARNING: DO NOT use in production!

class DummyChildCategoryRepository {
  /// Dummy data for veggies
  /// https://www.lemonilo.com/blog/inilah-jenis-penggolongan-sayuran-yang-harus-diketahui
  static const childCategoryVeggies = [
    ChildCategoryModel(
      id: '0',
      name: 'Daun',
      thumbnailUrl: 'https://pngimg.com/uploads/spinach/spinach_PNG65.png',
    ),
    ChildCategoryModel(
      id: '1',
      name: 'Bunga',
      thumbnailUrl:
          'https://pngimg.com/uploads/cauliflower/small/cauliflower_PNG12683.png',
    ),
    ChildCategoryModel(
      id: '2',
      name: 'Polong',
      thumbnailUrl: 'https://www.kindpng.com/picc/b/130-1301767_beans-png.png',
    ),
    ChildCategoryModel(
      id: '3',
      name: 'Umbi',
      thumbnailUrl: 'https://pngimg.com/uploads/potato/potato_PNG435.png',
    ),
    ChildCategoryModel(
      id: '4',
      name: 'Batang',
      thumbnailUrl: 'https://pngimg.com/uploads/celery/celery_PNG12.png',
    ),
    ChildCategoryModel(
      id: '5',
      name: 'Bawang',
      thumbnailUrl: 'https://pngimg.com/uploads/onion/onion_PNG599.png',
    ),
    ChildCategoryModel(
      id: '6',
      name: 'Jamur',
      thumbnailUrl:
          'https://pngimg.com/uploads/mushroom/small/mushroom_PNG3224.png',
    ),
  ];

  /// Dummy data for fruits
  /// https://www.betterhealth.vic.gov.au/health/healthyliving/fruit-and-vegetables
  static const childCategoryFruits = [
    ChildCategoryModel(
      id: '0',
      name: 'Apel',
      thumbnailUrl:
          'https://freepngimg.com/thumb/apple/88-png-apple-image-clipart-transparent-png-apple-thumb.png',
    ),
    ChildCategoryModel(
      id: '1',
      name: 'Jeruk',
      thumbnailUrl: 'https://pngimg.com/uploads/orange/orange_PNG803.png',
    ),
    ChildCategoryModel(
      id: '2',
      name: 'Persik',
      thumbnailUrl:
          'https://pngimg.com/uploads/apricot/small/apricot_PNG12634.png',
    ),
    ChildCategoryModel(
      id: '3',
      name: 'Tropis',
      thumbnailUrl: 'https://pngimg.com/uploads/mango/small/mango_PNG9171.png',
    ),
    ChildCategoryModel(
      id: '4',
      name: 'Beri',
      thumbnailUrl:
          'https://pngimg.com/uploads/strawberry/small/strawberry_PNG2615.png',
    ),
    ChildCategoryModel(
      id: '5',
      name: 'Melon',
      thumbnailUrl: 'https://pngimg.com/uploads/melon/melon_PNG14387.png',
    ),
    ChildCategoryModel(
      id: '6',
      name: 'Alpukat',
      thumbnailUrl:
          'https://pngimg.com/uploads/avocado/small/avocado_PNG15489.png',
    ),
  ];

  /// Dummy data for Bread, egg, and milk
  static const childCategoryBreadMilk = [
    ChildCategoryModel(
      id: '0',
      name: 'Sereal dan Bar Energi',
      thumbnailUrl:
          'https://png2.cleanpng.com/dy/dc9dafdd89c5b25d34ceebf68f802a5b/L0KzQYm3VsI5N5ZrR91yc4Pzfri0jvV0fJ0yeARAbnPrPcjvigRmNZRth9V4bHH3dX7qiP9kd51mjNc2YnH1Pbb1hgJoNZh3edD4bHGwcrL5TcVjO2Y3SqMAZUG7dYqATsQ5O2g1SaYBMUW2QIO3WMc5QWo3S6s3cH7q/kisspng-nestl-crunch-white-chocolate-chocolate-bar-energ-granola-bar-5b352215e18e97.4837014615302087899239.png',
    ),
    ChildCategoryModel(
      id: '1',
      name: 'Selai dan Spread',
      thumbnailUrl: 'https://pngimg.com/uploads/jam/small/jam_PNG3.png',
    ),
    ChildCategoryModel(
      id: '2',
      name: 'Roti',
      thumbnailUrl:
          'https://pngimg.com/uploads/croissant/small/croissant_PNG15.png',
    ),
    ChildCategoryModel(
      id: '3',
      name: 'Susu',
      thumbnailUrl: 'https://pngimg.com/uploads/milk/small/milk_PNG12741.png',
    ),
    ChildCategoryModel(
      id: '4',
      name: 'Telur',
      thumbnailUrl: 'https://pngimg.com/uploads/egg/small/egg_PNG40781.png',
    ),
    ChildCategoryModel(
      id: '5',
      name: 'Barang Bakery',
      thumbnailUrl: 'https://pngimg.com/uploads/flour/small/flour_PNG3.png',
    ),
  ];

  /// Dummy data for meat,seafood,frozen
  static const childCategoryMeat = [
    ChildCategoryModel(
      id: '0',
      name: 'Ayam',
      thumbnailUrl:
          'https://pngimg.com/uploads/turkey_food/small/turkey_food_PNG18.png',
    ),
    ChildCategoryModel(
      id: '1',
      name: 'Sapi',
      thumbnailUrl:
          'https://freepngimg.com/thumb/meat/34425-6-beef-meat-transparent-image-thumb.png',
    ),
    ChildCategoryModel(
      id: '2',
      name: 'Ikan',
      thumbnailUrl: 'https://pngimg.com/uploads/fish/small/fish_PNG25090.png',
    ),
    ChildCategoryModel(
      id: '3',
      name: 'Makanan Laut',
      thumbnailUrl: 'https://pngimg.com/uploads/crab/small/crab_PNG8.png',
    ),
    ChildCategoryModel(
      id: '4',
      name: 'Daging Kalengan',
      thumbnailUrl:
          'https://www.pngitem.com/pimgs/b/156-1563990_canned-food-png.png',
    ),
    ChildCategoryModel(
      id: '5',
      name: 'Ikan Kalengan',
      thumbnailUrl:
          'https://www.pngitem.com/pimgs/b/32-329413_tuna-fish-png.png',
    ),
  ];
}
