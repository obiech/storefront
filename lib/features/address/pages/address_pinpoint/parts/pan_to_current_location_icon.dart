part of '../address_pinpoint_page.dart';

class PanToCurrentLocationIcon extends StatelessWidget {
  const PanToCurrentLocationIcon({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(
          bottom: context.res.dimens.pagePadding,
          right: context.res.dimens.pagePadding,
        ),
        padding: EdgeInsets.all(context.res.dimens.spacingSmall),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.res.colors.white,
        ),
        child: Icon(
          Icons.my_location_rounded,
          color: context.res.colors.black,
        ),
      ),
    );
  }
}
