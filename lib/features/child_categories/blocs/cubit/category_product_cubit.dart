import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../product/index.dart';
import '../../../product_search/index.dart';

part 'category_product_state.dart';

@injectable
class CategoryProductCubit extends Cubit<CategoryProductState> {
  CategoryProductCubit(
    this.productInventoryRepo,
  ) : super(InitialCategoryProductState());

  final IProductInventoryRepository productInventoryRepo;

  Future<void> fetchCategoryProduct(String categoryId, String storeId) async {
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
