import 'package:storefront_app/features/product/index.dart';

/// Dummy Products
const productSeladaRomaine = ProductModel(
  productId: 'selada-romaine-id',
  sku: 'selada-romaine-sku',
  name: 'Selada Romaine',
  price: '15000',
  stock: 2,
  variants: [],
  defaultProduct: '',
  unit: '500g',
  thumbnailUrl: 'https://d1d8o7q9jg8pjk.cloudfront.net/p/md_5d29587da3a66.jpg',
);

const productCookingOilSania = ProductModel(
  productId: 'cooking-oil-sania-id',
  sku: 'cooking-oil-sania-sku',
  name: 'Minyak Goreng Sania 2L',
  price: '70000',
  stock: 2,
  variants: [],
  defaultProduct: '',
  unit: '500g',
  thumbnailUrl:
      'https://dn56y54v4g6fs.cloudfront.net/product/22_03_2021_02_11_19_sania_2_liter.jpg',
);

const productBellPepperYellow = ProductModel(
  productId: 'paprika-kuning-id',
  sku: 'paprika-kuning-sku',
  name: 'Paprika Kuning',
  price: '10000',
  stock: 2,
  variants: [],
  defaultProduct: '',
  unit: '500g',
  thumbnailUrl:
      'https://qph.fs.quoracdn.net/main-qimg-1324af1d727feb089eabfb9b3e74e8ca-lq',
);

const seledaRomaine = ProductModel(
  productId: 'selada-romaine-id',
  sku: 'selada-romaine-sku',
  name: 'Selada Romaine',
  price: '15000',
  discount: '20000',
  variants: [
    VariantModel(
      variantId: '',
      name: '',
      imagesUrls: ['default-url'],
      defaultImageUrl: 'default-url',
      price: '30000',
      sku: 'default-sku',
      stock: 5,
      unit: '200 ml',
    )
  ],
  defaultProduct: '',
  unit: '500g',
  stock: 100,
  thumbnailUrl:
      'https://purepng.com/public/uploads/large/purepng.com-cabbagecabbagevegetablesgreenfoodcalenonesense-481521740200e5vca.png',
);

final fakeCategoryProductList = [
  productSeladaRomaine,
  productBellPepperYellow,
];
