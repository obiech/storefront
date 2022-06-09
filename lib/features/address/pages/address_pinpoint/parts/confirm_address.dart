part of '../address_pinpoint_page.dart';

class ConfirmAddress extends StatelessWidget {
  const ConfirmAddress({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: context.res.styles.bottomSheetStyle,
      width: double.infinity,
      padding: EdgeInsets.all(context.res.dimens.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.res.strings.isThisReallyYourLocation,
            style: context.res.styles.subtitle,
          ),
          SizedBox(height: context.res.dimens.spacingMiddle),
          // TODO(Obiechina) Replace with address.
          PlaceSuggestionTile.address(
            mainAddress: 'Jalan Kebon Jeruk I',
            description: 'Jl. Rawa Belong, Palmerah, Kec. '
                'Palmerah, Kota Jakarta Barat, Daerah '
                'Khusus Ibukota Jakarta, Indonesia',
          ),
          SizedBox(height: context.res.dimens.spacingLarge),
          SizedBox(
            width: double.infinity,
            child: DropezyButton.primary(
              label: context.res.strings.locationConfirm,
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
