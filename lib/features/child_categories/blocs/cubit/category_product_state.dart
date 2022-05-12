part of 'category_product_cubit.dart';

abstract class CategoryProductState extends Equatable {
  const CategoryProductState();

  @override
  List<Object> get props => [];
}

/// Starting state for product in child categories
class InitialCategoryProductState extends CategoryProductState {}

/// When [ProductModel] are being loaded
class LoadingCategoryProductState extends CategoryProductState {}

/// Default state for showing the [ProductModel]
class LoadedCategoryProductState extends CategoryProductState {
  const LoadedCategoryProductState(
    this.productModelList,
  );

  final List<ProductModel> productModelList;

  @override
  List<Object> get props => [productModelList];
}

/// When an error occured while loading [ProductModel]
class ErrorCategoryProductState extends CategoryProductState {
  const ErrorCategoryProductState(this.message);

  /// Error message
  final String message;

  @override
  List<Object> get props => [message];
}
