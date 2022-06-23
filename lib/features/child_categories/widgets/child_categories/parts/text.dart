part of '../child_categories_list.dart';

class _ChildCategoriesText extends StatelessWidget {
  const _ChildCategoriesText({
    Key? key,
    required this.name,
    required this.isActive,
  }) : super(key: key);

  final String name;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return Text(
      name,
      maxLines: 2,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: isActive
          ? res.styles.caption3
              .copyWith(
                color: res.colors.blue,
                fontWeight: FontWeight.w500,
                fontSize: 11,
              )
              .withLineHeight(13)
          : context.res.styles.caption3
              .copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: DropezyColors.grey6,
              )
              .withLineHeight(13),
    );
  }
}
