part of '../parent_categories_grid.dart';

class ParentCategoriesItemLoading extends StatelessWidget {
  const ParentCategoriesItemLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Column(
        children: [
          const SkeletonItem(
            child: Flexible(
              flex: 3,
              child: DropezyImage(
                url: '',
                borderRadius: 16,
              ),
            ),
          ),
          SkeletonParagraph(
            style: SkeletonParagraphStyle(
              spacing: 4,
              lineStyle: SkeletonLineStyle(
                height: 8,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          )
        ],
      ),
    );
  }
}
