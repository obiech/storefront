import 'package:dropezy_proto/meta/meta.pb.dart';
import 'package:dropezy_proto/v1/search/search.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product/domain/domain.dart';
import 'package:storefront_app/features/product/domain/models/variant_model.dart';

extension SearchInventoryResultX on SearchInventoryResult {
  ProductModel get toProduct => ProductModel(
        productId: productId,
        name: name,
        categoryOneId: '',
        categoryTwoId: '',
        price: price.num,
        stock: stock,
        sku: sku,
        thumbnailUrl: '${AssetsConfig.assetsUrl}$imageUrl',
        status: stock < 1 ? ProductStatus.OUT_OF_STOCK : ProductStatus.ACTIVE,
        variants: [
          VariantModel(
            variantId: 'default',
            name: name,
            imagesUrls: ['${AssetsConfig.assetsUrl}$imageUrl'],
            price: price.num,
            sku: sku,
            stock: stock,
          )
        ],
        defaultProduct: 'default',
      );
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
