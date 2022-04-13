part of 'child_category_cubit.dart';

class ChildCategoryState extends Equatable {
  const ChildCategoryState(
    this.childCategoriesList,
    this.selectedChildCategory,
  );

  final List<ChildCategoryModel> childCategoriesList;
  final ChildCategoryModel selectedChildCategory;

  @override
  List<Object?> get props => [childCategoriesList, selectedChildCategory];
}
