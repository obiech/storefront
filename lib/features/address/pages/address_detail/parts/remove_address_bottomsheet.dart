part of '../address_detail_page.dart';

class RemoveAddressBottomSheet extends StatelessWidget {
  const RemoveAddressBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyBottomSheet.twoButtons(
      image: SvgPicture.asset(
        context.res.paths.imageDropezyPinLocation,
      ),
      content: Text(
        context.res.strings.removeYourLocation,
        style: context.res.styles.subtitle
            .copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            )
            .withLineHeight(26),
        textAlign: TextAlign.center,
      ),
      primaryButton: DropezyButton.primary(
        label: context.res.strings.cancel,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      secondaryButton: DropezyButton(
        label: context.res.strings.remove,
        textStyle: context.res.styles.caption1
            .copyWith(
              color: context.res.colors.blue,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            )
            .withLineHeight(24),
        backgroundColor: context.res.colors.lightBlue,
        onPressed: () {
          // TODO (Jonathan) : add remove and called address list to refresh
          Navigator.of(context).pop();
          context.router.pop();
        },
      ),
    );
  }
}
