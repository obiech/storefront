part of 'categories_one_cubit.dart';

abstract class CategoriesOneState extends Equatable {
  const CategoriesOneState();

  @override
  List<Object> get props => [];
}

/// Starting state for C1 categories
class InitialCategoriesOneState extends CategoriesOneState {}

/// When [CategoryOneModel] are being loaded
class LoadingCategoriesOneState extends CategoriesOneState {}

/// Default state for showing the [CategoryOneModel]
class LoadedCategoriesOneState extends CategoriesOneState {
  const LoadedCategoriesOneState(this.categoryOneList);

  /// List of C1 categories
  final List<CategoryOneModel> categoryOneList;
}

/// When an error occured while loading [CategoryOneModel]
class ErrorLoadingCategoriesOneState extends CategoriesOneState {
  const ErrorLoadingCategoriesOneState(this.message);

  /// Error message
  final String message;

  @override
  List<Object> get props => [message];
}
