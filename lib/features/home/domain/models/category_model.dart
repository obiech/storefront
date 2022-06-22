import 'package:dropezy_proto/v1/category/category.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:storefront_app/core/core.dart';

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
    required this.childCategories,
  }) : super(
          categoryId: id,
          name: name,
          thumbnailUrl: thumbnailUrl,
        );

  final List<ChildCategoryModel> childCategories;

  factory ParentCategoryModel.fromPb(Category category) {
    final imageUrls = category.toImageUrls;
    return ParentCategoryModel(
      id: category.categoryId,
      name: category.name,
      thumbnailUrl: imageUrls.isEmpty ? '' : imageUrls.first,
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
    final imageUrls = category.toImageUrls;
    return ChildCategoryModel(
      id: category.categoryId,
      name: category.name,
      thumbnailUrl: imageUrls.isEmpty ? '' : imageUrls.first,
    );
  }
}

// For sorting the child category alphabetically
extension ParentCategoryModelX on ParentCategoryModel {
  List<ChildCategoryModel> get sortChildrenByName =>
      List.of(childCategories)..sort((a, b) => a.name.compareTo(b.name));
}

extension CategoryX on Category {
  /// list of image URL string
  List<String> get toImageUrls =>
      imagesUrls.map((url) => url.toImageUrl).toList();
}
