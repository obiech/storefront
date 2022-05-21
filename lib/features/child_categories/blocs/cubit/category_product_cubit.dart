import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../product/index.dart';
import '../../../product_search/index.dart';

part 'category_product_state.dart';

@injectable
class CategoryProductCubit extends Cubit<CategoryProductState> {
  CategoryProductCubit(this.productInventoryRepo)
      : super(InitialCategoryProductState());

  final IProductInventoryRepository productInventoryRepo;

  // TODO (jonathan): Revisit how to obtain storeId on cold start
  // when store coverage bloc is available. Perhaps by having a
  // StreamSubscription on said bloc.

  /// In the meantime, when trying to run gRPC version of InventoryService,
  /// replace this with store ID from your local Mongo instance
  static const dummyStoreId = 'dummyStore';

  Future<void> fetchCategoryProduct(
    String categoryId, {
    String storeId = dummyStoreId,
  }) async {
    emit(LoadingCategoryProductState());

    final result = await productInventoryRepo.getProductByCategory(
      storeId,
      categoryId,
    );

    final state = result.fold(
      (failure) => ErrorCategoryProductState(failure.message),
      (product) => LoadedCategoryProductState(product),
    );

    emit(state);
  }
}
