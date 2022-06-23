part of '../child_categories_list.dart';

class _ChildCategoriesImage extends StatelessWidget {
  const _ChildCategoriesImage({
    Key? key,
    required this.url,
    required this.isActive,
  }) : super(key: key);

  final String url;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isActive
            ? Border.all(
                color: res.colors.blue,
                width: 2,
              )
            : null,
      ),
      child: ClipOval(
        child: DropezyImage(
          url: url,
          borderRadius: 0,
          padding: isActive
              ? EdgeInsets.all(res.dimens.spacingSmall)
              : EdgeInsets.all(res.dimens.spacingLarge),
        ),
      ),
    );
  }
}
