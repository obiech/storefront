part of 'parent_categories_cubit.dart';

abstract class ParentCategoriesState extends Equatable {
  const ParentCategoriesState();

  @override
  List<Object> get props => [];
}

/// Starting state for C1 categories
class InitialParentCategoriesState extends ParentCategoriesState {}

/// When [ParentCategoryModel] are being loaded
class LoadingParentCategoriesState extends ParentCategoriesState {}

/// Default state for showing the [ParentCategoryModel]
class LoadedParentCategoriesState extends ParentCategoriesState {
  const LoadedParentCategoriesState(this.parentCategoryList);

  /// List of C1 categories
  final List<ParentCategoryModel> parentCategoryList;
}

/// When an error occured while loading [ParentCategoryModel]
class ErrorLoadingParentCategoriesState extends ParentCategoriesState {
  const ErrorLoadingParentCategoriesState(this.message);

  /// Error message
  final String message;

  @override
  List<Object> get props => [message];
}
