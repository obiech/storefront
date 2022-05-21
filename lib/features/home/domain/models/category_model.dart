import 'package:dropezy_proto/v1/category/category.pb.dart';
import 'package:equatable/equatable.dart';

//Enum for category level

/// Models for product Category
abstract class CategoryModel extends Equatable {
  const CategoryModel({
    required this.categoryId,
    required this.name,
    required this.thumbnailUrl,
  });

  final String categoryId;
  final String name;
  final String thumbnailUrl;

  @override
  List<Object?> get props => [categoryId];
}

/// Model for C1
class ParentCategoryModel extends CategoryModel {
  const ParentCategoryModel({
    required String id,
    required String name,
    required String thumbnailUrl,
    required this.color,
    required this.childCategories,
  }) : super(
          categoryId: id,
          name: name,
          thumbnailUrl: thumbnailUrl,
        );
  final String color; //TODO (Jonathan): Remove the color
  final List<ChildCategoryModel> childCategories;

  factory ParentCategoryModel.fromPb(Category category) {
    return ParentCategoryModel(
      id: category.categoryId,
      name: category.name,
      thumbnailUrl: category.imagesUrls.isEmpty ? '' : category.imagesUrls[0],
      color: '91bbff',
      childCategories:
          category.childCategories.map(ChildCategoryModel.fromPb).toList(),
    );
  }
}

/// Model for C2
class ChildCategoryModel extends CategoryModel {
  const ChildCategoryModel({
    required String id,
    required String name,
    required String thumbnailUrl,
  }) : super(
          categoryId: id,
          name: name,
          thumbnailUrl: thumbnailUrl,
        );

  factory ChildCategoryModel.fromPb(Category category) {
    return ChildCategoryModel(
      id: category.categoryId,
      name: category.name,
      thumbnailUrl: category.imagesUrls.isEmpty ? '' : category.imagesUrls[0],
    );
  }
}

// For sorting the child category alphabetically
extension ParentCategoryModelX on ParentCategoryModel {
  List<ChildCategoryModel> get sortChildrenByName =>
      List.of(childCategories)..sort((a, b) => a.name.compareTo(b.name));
}
