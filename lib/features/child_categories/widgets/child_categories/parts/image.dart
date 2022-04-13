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
    return ClipOval(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: res.colors.paleBlue,
          border: isActive
              ? Border.all(
                  color: res.colors.darkBlue,
                  width: 2,
                )
              : null,
        ),
        padding: !isActive
            ? EdgeInsets.all(res.dimens.spacingLarge)
            : EdgeInsets.all(res.dimens.spacingSmall),
        child: CachedNetworkImage(
          fit: BoxFit.scaleDown,
          imageUrl: url,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(
            value: downloadProgress.progress,
          ),
          errorWidget: (context, url, error) => const Icon(DropezyIcons.logo),
        ),
      ),
    );
  }
}
