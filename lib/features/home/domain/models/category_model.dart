import 'package:equatable/equatable.dart';

//Enum for category level
enum Level {
  CATEGORY_ONE,
  CATEGORY_TWO,
}

/// Models for product Category
abstract class CategoryModel extends Equatable {
  const CategoryModel({
    required this.categoryId,
    required this.level,
    required this.name,
    required this.thumbnailUrl,
  });

  final String categoryId;
  final Level level;
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
          level: Level.CATEGORY_ONE,
          name: name,
          thumbnailUrl: thumbnailUrl,
        );
  final String color; //TODO (Jonathan): Remove the color
  final List<ChildCategoryModel> childCategories;
}

// Model for C2
class ChildCategoryModel extends CategoryModel {
  const ChildCategoryModel({
    required String id,
    required String name,
    required String thumbnailUrl,
  }) : super(
          categoryId: id,
          level: Level.CATEGORY_TWO,
          name: name,
          thumbnailUrl: thumbnailUrl,
        );
}

// For sorting the child category alphabetically
extension ParentCategoryModelX on ParentCategoryModel {
  List<ChildCategoryModel> get sortChildrenByName =>
      List.of(childCategories)..sort((a, b) => a.name.compareTo(b.name));
}
