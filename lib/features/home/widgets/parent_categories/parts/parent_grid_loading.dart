part of '../parent_categories_grid.dart';

class ParentLoadingGrid extends StatelessWidget {
  const ParentLoadingGrid({
    Key? key,
    required this.columns,
    required this.rows,
    required this.horizontalSpacing,
    required this.verticalSpacing,
  }) : super(key: key);

  /// Number of loading columns
  final int columns;

  /// Number of loading rows
  final int rows;

  /// Grid horizontal spacing
  final double horizontalSpacing;

  /// Grid vertical spacing
  final double verticalSpacing;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: 3 / 5,
        crossAxisSpacing: horizontalSpacing,
        mainAxisSpacing: verticalSpacing,
      ),
      itemCount: columns * rows,
      itemBuilder: (context, index) {
        return const ParentCategoriesItemLoading();
      },
    );
  }
}
