import 'package:storefront_app/features/product/domain/models/variant_model.dart';

const variantMango = VariantModel(
  productId: 'mango-id',
  variantId: 'variant-mango-id',
  name: 'Sweet mangoes',
  defaultImageUrl: 'mango-image-url-1',
  imagesUrls: ['mango-image-url-1', 'mango-image-url-2'],
  price: '5000000',
  sku: 'sku-variant-mango',
  stock: 100,
  unit: '500g',
);

const variantRice = VariantModel(
  productId: 'mango-id',
  variantId: 'variant-rice-id',
  name: 'White rice',
  defaultImageUrl: 'rice-image-url-1',
  imagesUrls: ['rice-image-url-1', 'rice-image-url-2'],
  price: '2000000',
  sku: 'sku-variant-rice',
  stock: 100,
  unit: '1000g',
);
