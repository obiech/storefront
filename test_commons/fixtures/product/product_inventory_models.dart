import 'package:dropezy_proto/v1/inventory/inventory.pbgrpc.dart';

final fakeVariant = Variant(imagesUrls: ['default-url']);

final fakeVariants = [fakeVariant, fakeVariant];

final fakeProduct = Product(
  variants: fakeVariants,
);

final fakeProducts = [fakeProduct, fakeProduct, fakeProduct];

final fakeInventory = Inventory(products: fakeProducts);

final fakeInventories = [fakeInventory, fakeInventory, fakeInventory];
