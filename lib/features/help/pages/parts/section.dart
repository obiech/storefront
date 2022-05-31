part of '../help_page.dart';

///  Header of a Group of FAQ
class _Section extends StatelessWidget {
  const _Section({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: context.res.colors.grey1,
      padding: EdgeInsets.symmetric(
        vertical: context.res.dimens.pagePadding,
        horizontal: context.res.dimens.pagePadding,
      ),
      child: Text(
        text,
        style: context.res.styles.subtitle,
      ),
    );
  }
}
