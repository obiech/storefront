import 'package:equatable/equatable.dart';

/// Models level one product Category (C1)
///
class CategoryOneModel extends Equatable {
  const CategoryOneModel({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.color,
  });

  final String id;
  final String name;
  final String thumbnailUrl;
  final String color; //TODO (Jonathan): Remove the color

  @override
  List<Object?> get props => [id];
}
