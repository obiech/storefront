part of '../parent_categories_grid.dart';

class ParentCategoriesItemLoading extends StatelessWidget {
  const ParentCategoriesItemLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Column(
        children: [
          const Flexible(
            flex: 3,
            child: SkeletonItem(
              child: DropezyImage(
                url: '',
                borderRadius: 16,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: SkeletonParagraph(
              style: SkeletonParagraphStyle(
                lines: 2,
                spacing: 4,
                lineStyle: SkeletonLineStyle(
                  height: 8,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
