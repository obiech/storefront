import 'package:dropezy_proto/meta/meta.pb.dart';
import 'package:dropezy_proto/v1/search/search.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:storefront_app/features/product/domain/domain.dart';

extension SearchInventoryResultX on SearchInventoryResult {
  ProductModel get toProduct {
    final defaultVariant = variants.defaultVariant;

    final defaultVariantImages = defaultVariant.imagesUrls;

    final overallStock = variants.overallStock;

    return ProductModel(
      productId: productId,
      name: name,
      price: defaultVariant.price,
      stock: overallStock,
      sku: defaultVariant.sku,
      unit: defaultVariant.unit,
      description: description,
      thumbnailUrl: defaultVariantImages.first,
      imagesUrls: defaultVariantImages,
      status: overallStock < 1
          ? ProductModelStatus.OUT_OF_STOCK
          : ProductModelStatus.ACTIVE,
      variants: variants
          .map((variant) => VariantModel.fromPbAndProductName(variant, name))
          .toList(),
      defaultProduct: defaultVariant.id,
    );
  }
}

extension SearchInventoryResultListX on List<SearchInventoryResult> {
  List<ProductModel> get toModel => map(
        (result) => result.toProduct,
      ).toList();
}

// TODO(obella465) - Replace with Mehmet's Amount implementation
class AmountModel extends Equatable {
  const AmountModel({required this.num, required this.cur});

  // num is numerical representative of monetary value.
  final String num;

  // dir is the currency of this monetary value.
  final Currency cur;

  factory AmountModel.fromPB(Amount amount) {
    return AmountModel(
      num: amount.num,
      cur: amount.cur,
    );
  }

  @override
  List<Object?> get props => [num, cur];

  Amount toPB() {
    return Amount(num: num, cur: cur);
  }
}
